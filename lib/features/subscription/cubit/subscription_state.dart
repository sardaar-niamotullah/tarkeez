import 'package:in_app_purchase/in_app_purchase.dart';

enum PurchaseResult { none, success, failed, unconfirmed }

class SubscriptionState {
  const new({this.products, this.result = PurchaseResult.none});

  final Map<String, ProductDetails>? products; // null = still loading
  final PurchaseResult result;
}
