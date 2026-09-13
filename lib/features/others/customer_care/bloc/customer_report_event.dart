part of 'customer_report_bloc.dart';

sealed class CustomerReportEvent extends Equatable {
  const CustomerReportEvent();

  @override
  List<Object?> get props => [];
}

final class SubmitCustomerReportRequested extends CustomerReportEvent {
  final String report;
  final String? profileId;
  final String? fullName;
  final String? contactNumber;

  const SubmitCustomerReportRequested({
    required this.report,
    this.profileId,
    this.fullName,
    this.contactNumber,
  });

  @override
  List<Object?> get props => [report, profileId, fullName, contactNumber];
}

final class CustomerReportReset extends CustomerReportEvent {
  const CustomerReportReset();
}
