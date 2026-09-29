import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/shared_files/enums/period_range.dart';

class ReportPeriodCubit extends Cubit<PeriodRange> {
  ReportPeriodCubit() : super(PeriodRange.last7Days);

  void select(PeriodRange period) {
    if (period.isLocked) return;
    emit(period);
  }
}