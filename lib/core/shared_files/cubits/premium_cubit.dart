import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/database/daos/users_dao.dart';

class PremiumCubit extends Cubit<DateTime?> {
  new(this._usersDao) : super(null);

  final UsersDao _usersDao;
  StreamSubscription<DateTime?>? _sub;

  bool get isPremium => state?.isAfter(DateTime.now()) ?? false;

  /// Watches the active account's premium end date.
  /// Call it again after an account switch or a history erase.
  Future<void> load() async {
    await _sub?.cancel();
    _sub = _usersDao.watchPremiumUntil().listen(emit);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
