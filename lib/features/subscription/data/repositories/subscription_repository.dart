import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tarkeez/core/database/daos/users_dao.dart';

class SubscriptionRepository {
  new(this._iap, this._supabase, this._usersDao);

  final InAppPurchase _iap;
  final SupabaseClient _supabase;
  final UsersDao _usersDao;

  Stream<List<PurchaseDetails>> get purchases => _iap.purchaseStream;

  /// Fires after every sign-in.
  Stream<void> get signedIn => _supabase.auth.onAuthStateChange.where(
    (data) => data.event == AuthChangeEvent.signedIn,
  );

  Future<Map<String, ProductDetails>> loadProducts(Set<String> ids) async {
    final response = await _iap.queryProductDetails(ids);
    return {for (final p in response.productDetails) p.id: p};
  }

  /// Asks the database if a plan of [months] still fits under the premium cap.
  Future<bool> canBuy(int months) async {
    try {
      final result = await _supabase.rpc(
        'can_buy_premium',
        params: {'p_months': months},
      );
      return result as bool;
    } catch (_) {
      return true; // offline: the server checks again after payment
    }
  }

  /// The purchase is tagged with the signed-in account, so only that account
  /// can claim it, even if the user switches account before it is verified.
  Future<void> buy(ProductDetails product) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;
    await _iap.buyConsumable(
      purchaseParam: PurchaseParam(
        productDetails: product,
        applicationUserName: userId,
      ),
      autoConsume: false,
    );
  }

  /// Re-delivers payments that were never consumed (verification failed, the
  /// app was closed, or the user was signed out). They arrive on [purchases]
  /// with the status `restored`.
  Future<void> restore() async {
    if (_supabase.auth.currentUser == null) return;
    try {
      await _iap.restorePurchases();
    } catch (_) {
      // Play Store unavailable: the next start tries again.
    }
  }

  /// False when the purchase was made while another account was signed in.
  /// It stays unconsumed until that account signs in again.
  bool isForCurrentUser(PurchaseDetails purchase) {
    final owner = (purchase as GooglePlayPurchaseDetails)
        .billingClientPurchase
        .obfuscatedAccountId;
    return owner == null ||
        owner.isEmpty ||
        owner == _supabase.auth.currentUser?.id;
  }

  /// The backend checks the token with Google and adds the time.
  /// The purchase is consumed only after the backend confirmed,
  /// so the same plan can be bought again.
  /// Returns false when the backend refused it because it would pass the
  /// premium cap (the backend refunds the order).
  Future<bool> verifyAndConsume(
    PurchaseDetails purchase,
    ProductDetails? product,
  ) async {
    // Read before the first await, so the premium date below is saved for the
    // account that sent the request, even if the user switches account meanwhile.
    final userId = _supabase.auth.currentUser!.id;
    try {
      final response = await _supabase.functions.invoke(
        'verify-purchase',
        body: {
          'product_id': purchase.productID,
          'purchase_token': purchase.verificationData.serverVerificationData,
          'amount': product?.rawPrice,
          'currency': product?.currencyCode,
        },
      );

      await _usersDao.setPremiumUntil(
        response.data['premium_until'] as String,
        userId: userId,
      );

      try {
        await _iap
            .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>()
            .consumePurchase(purchase as GooglePlayPurchaseDetails);
      } catch (_) {
        // Premium is already granted. restore() consumes it at the next start.
      }
      return true;
    } on FunctionException catch (e) {
      if (e.details.toString().contains('premium_cap_exceeded')) return false;
      rethrow;
    }
  }
}
