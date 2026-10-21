import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { english, bangla }

class LanguageCubit extends Cubit<AppLanguage> {
  static const _key = 'app_language';

  LanguageCubit() : super(AppLanguage.english) {
    _loadLanguage();
  }

  bool get isBangla => state == AppLanguage.bangla;

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final isBangla = prefs.getBool(_key) ?? false;
    emit(isBangla ? AppLanguage.bangla : AppLanguage.english);
  }

  Future<void> switchLanguage() async {
    final newLang = isBangla ? AppLanguage.english : AppLanguage.bangla;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, newLang == AppLanguage.bangla);
    emit(newLang);
  }
}