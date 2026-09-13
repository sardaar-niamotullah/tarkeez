part of 'customer_report_bloc.dart';

sealed class CustomerReportState extends Equatable {
  const CustomerReportState();

  @override
  List<Object?> get props => [];
}

final class CustomerReportInitial extends CustomerReportState {
  const CustomerReportInitial();
}

final class CustomerReportLoading extends CustomerReportState {
  const CustomerReportLoading();
}

final class CustomerReportSuccess extends CustomerReportState {
  const CustomerReportSuccess();
}

final class CustomerReportFailure extends CustomerReportState {
  final String message;
  const CustomerReportFailure(this.message);

  @override
  List<Object?> get props => [message];
}
