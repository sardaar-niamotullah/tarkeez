import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/features/others/customer_care/data/repositories/customer_report_repository.dart';

part 'customer_report_event.dart';
part 'customer_report_state.dart';

class CustomerReportBloc
    extends Bloc<CustomerReportEvent, CustomerReportState> {
  final CustomerReportRepository _repository;

  CustomerReportBloc(this._repository) : super(const CustomerReportInitial()) {
    on<SubmitCustomerReportRequested>(_onSubmitReport);
    on<CustomerReportReset>((_, emit) => emit(const CustomerReportInitial()));
  }

  Future<void> _onSubmitReport(
    SubmitCustomerReportRequested event,
    Emitter<CustomerReportState> emit,
  ) async {
    emit(const CustomerReportLoading());

    final result = await _repository.submitCustomerReport(
      report: event.report,
      profileId: event.profileId,
      fullName: event.fullName,
      contactNumber: event.contactNumber,
    );

    result.fold(
      onSuccess: (_) => emit(const CustomerReportSuccess()),
      onFailure: (error) => emit(CustomerReportFailure(error.message)),
    );
  }
}
