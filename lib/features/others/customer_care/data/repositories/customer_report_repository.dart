import 'package:tarkeez/core/error/exception_mapper.dart';
import 'package:tarkeez/core/error/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class CustomerReportRepository {
  Future<Result<void>> submitCustomerReport({
    required String report,
    String? profileId,
    String? fullName,
    String? contactNumber,
  });
}

class ReportRepositoryImpl implements CustomerReportRepository {
  final SupabaseClient _supabase;

  const ReportRepositoryImpl(this._supabase);

  @override
  Future<Result<void>> submitCustomerReport({
    required String report,
    String? profileId,
    String? fullName,
    String? contactNumber,
  }) async {
    try {
      final payload = <String, dynamic>{
        'report': report,
        'user_id': profileId,
        'full_name': fullName,
        'contact_number': contactNumber,
      }..removeWhere((key, value) => value == null);

      await _supabase.from('reports').insert(payload);

      return Success(null);
    } catch (e) {
      return Failure(mapException(e));
    }
  }
}
