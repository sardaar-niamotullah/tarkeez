import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tarkeez/features/subscription/data/models/pricing_plan.dart';
import 'package:tarkeez/features/subscription/data/repositories/subscription_repository.dart';

import 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  new(this._repository) : super(const SubscriptionState()) {
    _purchaseSub = _repository.purchases.listen(_onPurchases);
    _loadProducts();
    _loadBlocked();
  }

  final SubscriptionRepository _repository;
  late final StreamSubscription<List<PurchaseDetails>> _purchaseSub;

  @override
  Future<void> close() {
    _purchaseSub.cancel();
    return super.close();
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
        continue;
      }

      if (purchase.status != PurchaseStatus.purchased &&
          purchase.status != PurchaseStatus.restored) {
        continue;
      }

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
