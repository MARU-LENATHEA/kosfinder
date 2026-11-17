import 'package:flutter_test/flutter_test.dart';
import 'package:kosfinder/presentation/providers/kos_provider.dart';

/// Fake implementation of KosRepository for unit testing
class FakeKosRepository implements KosRepository {
  List<Kos> mockData = [];
  bool shouldThrow = false;

  @override
  Future<List<Kos>> getKosList() async {
    if (shouldThrow) {
      throw Exception('Koneksi terputus');
    }
    return mockData;
  }
}

void main() {
  group('KosProvider Tests', () {
    late FakeKosRepository fakeRepository;
    late KosProvider provider;

    final sampleKos = Kos(
      id: 'kos-001',
      ownerId: 'owner-001',
      name: 'Kos Melati',
      area: 'Sekaran',
      price: 600000,
      facilities: const ['WiFi', 'Kasur'],
      contact: '08123456789',
      isAvailable: true,
    );

    setUp(() {
      fakeRepository = FakeKosRepository();
      provider = KosProvider(repository: fakeRepository);
    });

    test('State awal provider harus initial', () {
      expect(provider.state, KosState.initial);
      expect(provider.kosList, isEmpty);
      expect(provider.errorMessage, isNull);
      expect(provider.isLoading, isFalse);
      expect(provider.isEmpty, isFalse);
      expect(provider.hasError, isFalse);
      expect(provider.isLoaded, isFalse);
    });

    test('US01-AC1: fetchKosList berhasil memuat data kos', () async {
      fakeRepository.mockData = [sampleKos];

      final future = provider.fetchKosList();
      expect(provider.isLoading, isTrue);

      await future;

      expect(provider.state, KosState.loaded);
      expect(provider.isLoaded, isTrue);
      expect(provider.kosList.length, 1);
      expect(provider.kosList.first.name, 'Kos Melati');
      expect(provider.errorMessage, isNull);
    });

    test('US01-AC2: fetchKosList menghasilkan empty state saat data kosong', () async {
      fakeRepository.mockData = [];

      await provider.fetchKosList();

      expect(provider.state, KosState.empty);
      expect(provider.isEmpty, isTrue);
      expect(provider.kosList, isEmpty);
      expect(provider.errorMessage, isNull);
    });

    test('US01-AC3: fetchKosList menghasilkan error state saat terjadi kegagalan jaringan', () async {
      fakeRepository.shouldThrow = true;

      await provider.fetchKosList();

      expect(provider.state, KosState.error);
      expect(provider.hasError, isTrue);
      expect(provider.kosList, isEmpty);
      expect(provider.errorMessage, 'Gagal memuat data. Periksa koneksi internet Anda');
    });

    test('retry() mencoba memuat ulang data setelah error', () async {
      fakeRepository.shouldThrow = true;
      await provider.fetchKosList();
      expect(provider.hasError, isTrue);

      // Perbaiki koneksi dan sediakan data
      fakeRepository.shouldThrow = false;
      fakeRepository.mockData = [sampleKos];

      await provider.retry();

      expect(provider.state, KosState.loaded);
      expect(provider.isLoaded, isTrue);
      expect(provider.kosList.length, 1);
      expect(provider.errorMessage, isNull);
    });
  });
}
