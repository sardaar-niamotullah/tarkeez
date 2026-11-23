import 'package:in_app_purchase/in_app_purchase.dart';

enum PurchaseResult { none, success, failed, unconfirmed, capExceeded }

class SubscriptionState {
  const new({
    this.products,
    this.blocked = const {},
    this.result = PurchaseResult.none,
  });

  final Map<String, ProductDetails>? products; // null = still loading
  final Set<String> blocked; // product ids that would pass the premium cap
  final PurchaseResult result;
}
