import 'package:flutter/foundation.dart';

/// Status state dari KosProvider
enum KosState { initial, loading, loaded, empty, error }

/// Entitas data Kos sederhana untuk keperluan KosProvider
class Kos {
  final String id;
  final String ownerId;
  final String name;
  final String area;
  final num price;
  final List<String> facilities;
  final String contact;
  final bool isAvailable;

  const Kos({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.area,
    required this.price,
    required this.facilities,
    required this.contact,
    this.isAvailable = true,
  });

  factory Kos.fromMap(Map<String, dynamic> map) {
    return Kos(
      id: map['id'] as String? ?? '',
      ownerId: map['owner_id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      area: map['area'] as String? ?? '',
      price: map['price'] as num? ?? 0,
      facilities: List<String>.from(map['facilities'] as List? ?? []),
      contact: map['contact'] as String? ?? '',
      isAvailable: map['is_available'] as bool? ?? true,
    );
  }
}

/// Kontrak abstraksi repository data kos
abstract class KosRepository {
  Future<List<Kos>> getKosList();
}

/// Provider pengelola state katalog kos
/// Menangani US01-AC1 (daftar kos), US01-AC2 (data kosong), dan US01-AC3 (koneksi gagal)
class KosProvider extends ChangeNotifier {
  final KosRepository repository;

  KosState _state = KosState.initial;
  List<Kos> _kosList = [];
  String? _errorMessage;

  KosProvider({required this.repository});

  KosState get state => _state;
  List<Kos> get kosList => _kosList;
  String? get errorMessage => _errorMessage;

  bool get isLoading => _state == KosState.loading;
  bool get isEmpty => _state == KosState.empty;
  bool get hasError => _state == KosState.error;
  bool get isLoaded => _state == KosState.loaded;

  /// Memuat daftar kos dari repository
  Future<void> fetchKosList() async {
    _state = KosState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.getKosList();
      if (result.isEmpty) {
        _kosList = [];
        _state = KosState.empty;
      } else {
        _kosList = result;
        _state = KosState.loaded;
      }
    } catch (_) {
      _kosList = [];
      _state = KosState.error;
      _errorMessage = 'Gagal memuat data. Periksa koneksi internet Anda';
    } finally {
      notifyListeners();
    }
  }

  /// Mencoba memuat ulang data saat terjadi kegagalan koneksi
  Future<void> retry() async {
    await fetchKosList();
  }
}
