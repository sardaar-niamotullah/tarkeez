import 'package:tarkeez/core/shared_files/validators/form_validators.dart';
import 'package:tarkeez/features/others/customer_care/data/models/customer_report_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'customer_report_form_state.dart';

class CustomerReportFormCubit extends Cubit<CustomerReportFormState> {
  CustomerReportFormCubit() : super(const CustomerReportFormState()) {
    nameController.addListener(() => _onChanged('name'));
    phoneController.addListener(() => _onChanged('phone'));
    reportController.addListener(() => _onChanged('report'));
  }

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final reportController = TextEditingController();

  void setMode(CustomerReportMode mode) => emit(state.copyWith(mode: mode));

  void reset() {
    nameController.text = state.initialName;
    phoneController.text = state.initialPhone;
    reportController.text = state.initialReport;

    emit(_validate(state.copyWith(touched: const {})));
  }

  @override
  Future<void> close() {
    nameController.dispose();
    phoneController.dispose();
    reportController.dispose();
    return super.close();
  }

  void _onChanged(String field) =>
      emit(_validate(state.copyWith(touched: {...state.touched, field})));

  // ─────────────────────────────────────────────
  // Validation
  // ─────────────────────────────────────────────
  CustomerReportFormState _validate(CustomerReportFormState s) {
    final isGuest = s.mode == CustomerReportMode.guest;

    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final report = reportController.text.trim();

    final next = s.copyWith(
      nameError: () => (isGuest && s.touched.contains('name'))
          ? FormValidators.validateName(name)
          : null,
      reportError: () => s.touched.contains('report')
          ? FormValidators.validateReport(report)
          : null,
    );

    final baseValid =
        next.nameError == null &&
        next.phoneError == null &&
        next.reportError == null;

    final requiredFieldsValid = isGuest
        ? name.isNotEmpty && phone.isNotEmpty && report.isNotEmpty
        : report.isNotEmpty;

    final hasChanges =
        name != s.initialName ||
        phone != s.initialPhone ||
        report != s.initialReport;

    return next.copyWith(
      canSubmit: hasChanges && baseValid && requiredFieldsValid,
      hasChanges: hasChanges,
    );
  }

  // ─────────────────────────────────────────────
  // Submit
  // ─────────────────────────────────────────────
  // bool submit(BuildContext context, {ProfileModel? profile}) {
  //   final mode = profile == null
  //       ? CustomerReportMode.guest
  //       : CustomerReportMode.authenticated;

  //   emit(state.copyWith(mode: mode));

  //   final allTouched = mode == CustomerReportMode.guest
  //       ? const {'name', 'phone', 'report'}
  //       : const {'report'};

  //   final validated = _validate(state.copyWith(touched: allTouched));

  //   emit(validated);

  //   if (!validated.canSubmit) return false;

  //   context.read<CustomerReportBloc>().add(
  //     SubmitCustomerReportRequested(
  //       report: reportController.text.trim(),
  //       profileId: profile?.id,
  //       fullName: profile?.fullName ?? nameController.text.trim(),
  //     ),
  //   );
  //   return true;
  // }
}
