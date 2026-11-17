/// Konfigurasi aplikasi KosFinder.
/// Membaca URL dan Anon Key Supabase secara aman saat waktu kompilasi
/// menggunakan flag `--dart-define` (atau `--dart-define-from-file`),
/// sehingga tidak ada kredensial yang ditulis langsung (hardcoded) di kode sumber.
class AppConfig {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  /// Memvalidasi apakah kredensial Supabase sudah diberikan
  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
