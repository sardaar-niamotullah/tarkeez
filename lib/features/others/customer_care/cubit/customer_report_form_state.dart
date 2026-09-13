part of 'customer_report_form_cubit.dart';

class CustomerReportFormState extends Equatable {
  final CustomerReportMode mode;
  final Set<String> touched;

  final String? nameError;
  final String? phoneError;
  final String? reportError;

  final bool canSubmit;
  final bool hasChanges;

  // ─────────────────────────────────────────────
  // INITIAL VALUES (for reset + diff tracking)
  // ─────────────────────────────────────────────
  final String initialName;
  final String initialPhone;
  final String initialReport;

  const CustomerReportFormState({
    this.mode = CustomerReportMode.guest,
    this.touched = const {},

    this.nameError,
    this.phoneError,
    this.reportError,

    this.canSubmit = false,
    this.hasChanges = false,

    this.initialName = '',
    this.initialPhone = '',
    this.initialReport = '',
  });

  @override
  List<Object?> get props => [
    mode,
    touched,
    nameError,
    phoneError,
    reportError,
    canSubmit,
    hasChanges,
    initialName,
    initialPhone,
    initialReport,
  ];

  CustomerReportFormState copyWith({
    CustomerReportMode? mode,
    Set<String>? touched,
    String? Function()? nameError,
    String? Function()? phoneError,
    String? Function()? reportError,
    bool? canSubmit,
    bool? hasChanges,

    String? initialName,
    String? initialPhone,
    String? initialReport,
  }) {
    return CustomerReportFormState(
      mode: mode ?? this.mode,
      touched: touched ?? this.touched,

      nameError: nameError != null ? nameError() : this.nameError,
      phoneError: phoneError != null ? phoneError() : this.phoneError,
      reportError: reportError != null ? reportError() : this.reportError,

      canSubmit: canSubmit ?? this.canSubmit,
      hasChanges: hasChanges ?? this.hasChanges,

      initialName: initialName ?? this.initialName,
      initialPhone: initialPhone ?? this.initialPhone,
      initialReport: initialReport ?? this.initialReport,
    );
  }
}
