import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/shared_files/enums/period_range.dart';

class SessionPeriodCubit extends Cubit<PeriodRange> {
  new() : super(PeriodRange.last3Days);

  void select(PeriodRange period) {
    if (period.isLocked) return;
    emit(period);
  }
}
