import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Palet Batik Heritage — warna pewarna alam wastra (Nature Distilled).
class BatikColors {
  static const mori = Color(0xFFF7F3E8); // kain mori (latar)
  static const moriDeep = Color(0xFFEFE7D4);
  static const paper = Color(0xFFFBF8F0); // kertas hangat (kartu)

  static const nila = Color(0xFF24305E);
  static const nilaDeep = Color(0xFF1A2347);

  static const soga = Color(0xFF7B4B2A);
  static const sogaDeep = Color(0xFF5E3820);

  static const kunyit = Color(0xFFE0A526);
  static const kunyitSoft = Color(0xFFF2CD7A);

  static const tanah = Color(0xFFC67B5C); // terracotta aksen
}

/// Font display (serif heritage) — dipakai untuk judul.
TextStyle batikDisplay({
  double size = 20,
  FontWeight weight = FontWeight.w600,
  Color color = BatikColors.nila,
  bool italic = false,
  double height = 1.1,
}) =>
    GoogleFonts.cormorantGaramond(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
    );

ThemeData batikTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: BatikColors.nila,
    primary: BatikColors.nila,
    secondary: BatikColors.soga,
    surface: BatikColors.mori,
  );
  final base = ThemeData(useMaterial3: true, colorScheme: scheme);
  return base.copyWith(
    scaffoldBackgroundColor: BatikColors.mori,
    textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
      bodyColor: BatikColors.nila,
      displayColor: BatikColors.nila,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: BatikColors.mori,
      foregroundColor: BatikColors.nila,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: batikDisplay(size: 24, weight: FontWeight.w700),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: BatikColors.paper,
      indicatorColor: BatikColors.nila.withValues(alpha: 0.1),
      labelTextStyle: WidgetStatePropertyAll(
        GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
