import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/dependency_injection/di.dart';
import 'package:tarkeez/core/shared_files/enums/user_settings_enums.dart';

class LeaderboardPeriodCubit extends Cubit<PeriodRange> {
  new() : super(PeriodRange.last3Days);

  final _dao = getIt<LocalDatabase>().userPreferencesDao;

  Future<void> load() async {
    final settings = await _dao.getPreferences();
    if (isClosed) return;
    emit(settings.leaderboardPeriod);
  }

  Future<void> select(PeriodRange period) async {
    if (period.isLocked) return;
    emit(period);
    await _dao.setLeaderboardPeriod(period);
  }
}