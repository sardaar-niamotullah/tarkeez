import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/database/daos/users_dao.dart';

class PremiumCubit extends Cubit<bool> {
  new(this._usersDao) : super(false);

  final UsersDao _usersDao;
  StreamSubscription<bool>? _sub;

  /// Watches the active account's premium state.
  /// Call it again after an account switch or a history erase.
  Future<void> load() async {
    await _sub?.cancel();
    _sub = _usersDao.watchIsPremium().listen(emit);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
