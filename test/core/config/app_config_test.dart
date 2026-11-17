import 'package:flutter_test/flutter_test.dart';
import 'package:kosfinder/core/config/app_config.dart';

void main() {
  group('AppConfig Tests', () {
    test('Nilai default AppConfig jika tidak di-passing via --dart-define', () {
      // Tanpa --dart-define, nilai harus berupa string kosong
      expect(AppConfig.supabaseUrl, isEmpty);
      expect(AppConfig.supabaseAnonKey, isEmpty);
      expect(AppConfig.isConfigured, isFalse);
    });
  });
}
