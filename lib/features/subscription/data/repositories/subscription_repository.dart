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

  Future<void> buy(ProductDetails product) {
    return _iap.buyConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
      autoConsume: false,
    );
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

      await _iap
          .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>()
          .consumePurchase(purchase as GooglePlayPurchaseDetails);

      await _usersDao.setPremiumUntil(response.data['premium_until'] as String);
      return true;
    } on FunctionException catch (e) {
      if (e.details.toString().contains('premium_cap_exceeded')) return false;
      rethrow;
    }
  }
}
