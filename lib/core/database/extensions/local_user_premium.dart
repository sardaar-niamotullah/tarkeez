import 'package:tarkeez/core/database/local_database.dart';

extension LocalUserPremium on LocalUser {
  bool get isPremium {
    final until = DateTime.tryParse(premiumUntil ?? '');
    return until != null && until.isAfter(DateTime.now());
  }
}
