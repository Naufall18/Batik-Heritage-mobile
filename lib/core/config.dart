class AppConfig {
  /// Base URL API. Emulator Android memetakan host laptop ke 10.0.2.2.
  /// HP fisik: ganti ke IP LAN laptop (mis. http://192.168.x.x:8000/api).
  static const String apiBaseUrl = 'http://10.0.2.2:8000/api';

  /// Titik acuan default: pusat Kota Pasuruan (fallback bila GPS ditolak).
  static const double pasuruanLat = -7.6453;
  static const double pasuruanLng = 112.9075;
}
