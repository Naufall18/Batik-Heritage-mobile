import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../core/config.dart';
import '../../core/theme.dart';
import '../catalog/catalog_providers.dart';

class NearbyPage extends ConsumerStatefulWidget {
  const NearbyPage({super.key});

  @override
  ConsumerState<NearbyPage> createState() => _NearbyPageState();
}

class _NearbyPageState extends ConsumerState<NearbyPage> {
  final _mapController = MapController();
  LatLng? _user;
  double _radius = 25;
  bool _locating = false;

  LatLng get _origin =>
      _user ?? const LatLng(AppConfig.pasuruanLat, AppConfig.pasuruanLng);

  Future<void> _locate() async {
    setState(() => _locating = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return;
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      final ll = LatLng(pos.latitude, pos.longitude);
      if (!mounted) return;
      setState(() => _user = ll);
      _mapController.move(ll, 12);
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = (lat: _origin.latitude, lng: _origin.longitude, radius: _radius);
    final vendors = ref.watch(nearbyVendorsProvider(args));
    final list = vendors.asData?.value ?? [];

    return Column(
      children: [
        // Peta
        Expanded(
          flex: 3,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: _origin, initialZoom: 11),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'id.batikheritage',
              ),
              MarkerLayer(
                markers: [
                  if (_user != null)
                    Marker(
                      point: _user!,
                      width: 30,
                      height: 30,
                      child: const Icon(Icons.my_location, color: BatikColors.kunyit),
                    ),
                  for (final v in list)
                    if (v.latitude != null && v.longitude != null)
                      Marker(
                        point: LatLng(v.latitude!, v.longitude!),
                        width: 30,
                        height: 30,
                        child: const Icon(Icons.location_on, color: BatikColors.soga, size: 30),
                      ),
                ],
              ),
            ],
          ),
        ),
        // Kontrol
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              FilledButton.icon(
                onPressed: _locating ? null : _locate,
                icon: const Icon(Icons.gps_fixed, size: 18),
                label: Text(_locating ? 'Mencari…' : 'Lokasi saya'),
                style: FilledButton.styleFrom(backgroundColor: BatikColors.nila),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: [
                    Text('${_radius.toInt()} km'),
                    Expanded(
                      child: Slider(
                        value: _radius,
                        min: 1,
                        max: 50,
                        activeColor: BatikColors.soga,
                        onChanged: (v) => setState(() => _radius = v),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Daftar
        Expanded(
          flex: 2,
          child: vendors.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Gagal memuat.\n$e')),
            data: (items) => items.isEmpty
                ? Center(child: Text('Tidak ada UMKM dalam ${_radius.toInt()} km.'))
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final v = items[i];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: BatikColors.paper,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: BatikColors.nila.withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: BatikColors.nila,
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Text(v.name[0],
                                  style: batikDisplay(size: 18, weight: FontWeight.w700, color: BatikColors.kunyit)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(v.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: batikDisplay(size: 17, weight: FontWeight.w600)),
                                  Text('${v.kecamatan ?? '-'} · ${v.productsCount} produk',
                                      style: TextStyle(fontSize: 12, color: BatikColors.nila.withValues(alpha: 0.55))),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: BatikColors.soga.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.navigation, size: 12, color: BatikColors.soga),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${v.distanceKm?.toStringAsFixed(1) ?? '-'} km',
                                    style: const TextStyle(color: BatikColors.soga, fontWeight: FontWeight.w700, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
