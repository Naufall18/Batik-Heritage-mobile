import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config.dart';
import 'models.dart';

/// Dio tunggal untuk seluruh app.
final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    headers: {'Accept': 'application/json'},
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
});

/// Daftar produk (halaman pertama katalog).
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final dio = ref.watch(dioProvider);
  final res = await dio.get('/products');
  final data = res.data['data'] as List;
  return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
});

/// Detail produk by slug.
final productProvider = FutureProvider.family<Product, String>((ref, slug) async {
  final dio = ref.watch(dioProvider);
  final res = await dio.get('/products/$slug');
  return Product.fromJson(res.data['data'] as Map<String, dynamic>);
});

/// Argumen untuk pencarian UMKM terdekat.
typedef NearbyArgs = ({double lat, double lng, double radius});

/// UMKM terdekat (Haversine dari backend).
final nearbyVendorsProvider =
    FutureProvider.family<List<Vendor>, NearbyArgs>((ref, args) async {
  final dio = ref.watch(dioProvider);
  final res = await dio.get('/vendors/nearby', queryParameters: {
    'lat': args.lat,
    'lng': args.lng,
    'radius': args.radius,
  });
  final data = res.data['data'] as List;
  return data.map((e) => Vendor.fromJson(e as Map<String, dynamic>)).toList();
});
