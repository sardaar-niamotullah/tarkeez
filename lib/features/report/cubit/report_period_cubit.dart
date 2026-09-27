import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/shared_files/enums/report_period.dart';

class ReportPeriodCubit extends Cubit<ReportPeriod> {
  ReportPeriodCubit() : super(ReportPeriod.last7Days);

  void select(ReportPeriod period) {
    if (period.isLocked) return;
    emit(period);
  }
}