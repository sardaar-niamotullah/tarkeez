import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tarkeez/features/subscription/data/models/pricing_plan.dart';
import 'package:tarkeez/features/subscription/data/repositories/subscription_repository.dart';

import 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  new(this._repository) : super(const SubscriptionState()) {
    _purchaseSub = _repository.purchases.listen(_onPurchases);
    _signInSub = _repository.signedIn.listen((_) => _onSignedIn());
    _loadProducts();
    _onSignedIn(); // app start with a saved session
  }

  final SubscriptionRepository _repository;
  late final StreamSubscription<List<PurchaseDetails>> _purchaseSub;
  late final StreamSubscription<void> _signInSub;

  /// Purchase tokens being verified right now, so one payment is never
  /// verified twice at the same time.
  final _verifying = <String>{};

  @override
  Future<void> close() {
    _purchaseSub.cancel();
    _signInSub.cancel();
    return super.close();
  }

  /// App start and every sign-in: finish payments that were left open, and
  /// check again which plans fit under the premium cap for this account.
  void _onSignedIn() {
    unawaited(_repository.restore());
    _loadBlocked();
  }

  Future<void> _loadProducts() async {
    final products = await _repository.loadProducts(
      pricingPlans.map((plan) => plan.productId).toSet(),
    );
    if (isClosed) return;
    emit(SubscriptionState(products: products, blocked: state.blocked));
  }

  /// Asks the database which plans would pass the premium cap.
  Future<void> _loadBlocked() async {
    final blocked = <String>{};
    await Future.wait(
      pricingPlans.map((plan) async {
        if (!await _repository.canBuy(plan.months)) blocked.add(plan.productId);
      }),
    );
    if (isClosed) return;
    emit(SubscriptionState(products: state.products, blocked: blocked));
  }

  void buy(PricingPlan plan) {
    final product = state.products?[plan.productId];
    if (product == null) return;
    _repository.buy(product);
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.error) {
        _emitResult(PurchaseResult.failed);
        // "Already owned" means an earlier payment is still waiting.
        unawaited(_repository.restore());
        continue;
      }

      if (purchase.status != PurchaseStatus.purchased &&
          purchase.status != PurchaseStatus.restored) {
        continue;
      }

      // Bought while another account was signed in: leave it for that account.
      if (!_repository.isForCurrentUser(purchase)) continue;

      final token = purchase.verificationData.serverVerificationData;
      if (!_verifying.add(token)) continue;

      try {
        final granted = await _repository.verifyAndConsume(
          purchase,
          state.products?[purchase.productID],
        );
        _emitResult(
          granted ? PurchaseResult.success : PurchaseResult.capExceeded,
        );
      } catch (_) {
        _emitResult(PurchaseResult.unconfirmed);
      } finally {
        _verifying.remove(token);
      }

      await _loadBlocked(); // premium_until changed, so the cap check changed too
    }
  }

  void _emitResult(PurchaseResult result) {
    if (isClosed) return;
    emit(
      SubscriptionState(
        products: state.products,
        blocked: state.blocked,
        result: result,
      ),
    );
  }
}
