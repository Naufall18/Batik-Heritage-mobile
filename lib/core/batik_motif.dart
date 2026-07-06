import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Pattern batik on-brand & deterministik (seed dari slug) — padanan mobile
/// dari komponen web BatikMotif. Dipakai sebagai fallback saat produk/UMKM
/// belum punya foto asli, agar tetap bernuansa heritage (bukan kotak kosong).
class BatikMotif extends StatelessWidget {
  const BatikMotif({super.key, required this.seed, this.label});
  final String seed;
  final String? label;

  @override
  Widget build(BuildContext context) {
    // RepaintBoundary + isComplex/willChange:false → engine merasterisasi pattern
    // sekali ke cache layer, mencegah repaint mahal tiap frame (hindari ANR di grid).
    return RepaintBoundary(
      child: CustomPaint(
        painter: _BatikPainter(seed: seed, label: label),
        size: Size.infinite,
        isComplex: true,
        willChange: false,
      ),
    );
  }
}

class _Combo {
  final Color bg, ink, accent;
  const _Combo(this.bg, this.ink, this.accent);
}

const _combos = <_Combo>[
  _Combo(Color(0xFF24305E), Color(0xFFF2CD7A), Color(0xFFE0A526)), // nila · kunyit
  _Combo(Color(0xFF5E3820), Color(0xFFE9D9BE), Color(0xFFC67B5C)), // soga · tanah
  _Combo(Color(0xFF1A2347), Color(0xFF9C6A44), Color(0xFF7B4B2A)), // nila deep · soga
  _Combo(Color(0xFF7B4B2A), Color(0xFFF7F3E8), Color(0xFFE0A526)), // soga · mori
  _Combo(Color(0xFF2F3A2A), Color(0xFFD4C4A8), Color(0xFF8A9A5B)), // hijau · sand
];

const _motifs = ['kawung', 'ceplok', 'parang', 'truntum'];

int _hash(String s) {
  var h = 0;
  for (var i = 0; i < s.length; i++) {
    h = (h << 5) - h + s.codeUnitAt(i);
    h &= 0x7fffffff;
  }
  return h;
}

class _BatikPainter extends CustomPainter {
  _BatikPainter({required this.seed, this.label});
  final String seed;
  final String? label;

  @override
  void paint(Canvas canvas, Size size) {
    final h = _hash(seed);
    final combo = _combos[h % _combos.length];
    final motif = _motifs[(h >> 3) % _motifs.length];

    // Latar gradien
    final bgRect = Offset.zero & size;
    canvas.drawRect(
      bgRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [combo.bg, combo.bg.withValues(alpha: 0.82)],
        ).createShader(bgRect),
    );

    // Ubin motif
    const tile = 56.0;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = combo.ink.withValues(alpha: 0.62);
    final dot = Paint()..color = combo.accent.withValues(alpha: 0.62);

    for (double y = 0; y < size.height + tile; y += tile) {
      for (double x = 0; x < size.width + tile; x += tile) {
        canvas.save();
        canvas.translate(x, y);
        _drawMotif(canvas, motif, tile, stroke, dot);
        canvas.restore();
      }
    }

    // Label motif di bawah
    if (label != null && label!.isNotEmpty) {
      final tp = TextPainter(
        text: TextSpan(
          text: label!.toUpperCase(),
          style: batikBody(combo.ink),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: size.width - 24);
      tp.paint(canvas, Offset((size.width - tp.width) / 2, size.height - tp.height - 12));
    }
  }

  void _drawMotif(Canvas c, String motif, double t, Paint s, Paint dot) {
    final m = t / 2;
    switch (motif) {
      case 'kawung':
        _oval(c, m, m * 0.45, 8, 13, s);
        _oval(c, m, m * 1.55, 8, 13, s);
        _oval(c, m * 0.45, m, 13, 8, s);
        _oval(c, m * 1.55, m, 13, 8, s);
        c.drawCircle(Offset(m, m), 2, dot);
        break;
      case 'ceplok':
        c.drawCircle(Offset(m, m), 14, s);
        c.drawCircle(Offset(m, m), 7, s);
        c.drawLine(Offset(m, 2), Offset(m, t - 2), s);
        c.drawLine(Offset(2, m), Offset(t - 2, m), s);
        c.drawCircle(Offset(m, m), 2.5, dot);
        break;
      case 'parang':
        for (var i = 0; i < 4; i++) {
          final ox = i * 14.0 + 2;
          final path = Path()
            ..moveTo(ox, t - 2)
            ..quadraticBezierTo(ox + 12, t - 16, ox + 6, m + 2)
            ..quadraticBezierTo(ox, m - 8, ox + 12, m - 16)
            ..quadraticBezierTo(ox + 18, m - 22, ox + 14, 2);
          c.drawPath(path, s);
          c.drawCircle(Offset(ox + 9, m), 1.6, dot);
        }
        break;
      case 'truntum':
        for (var a = 0; a < 4; a++) {
          c.save();
          c.translate(m, m);
          c.rotate(a * math.pi / 2);
          c.drawLine(const Offset(0, 0), const Offset(0, -18), s);
          c.restore();
        }
        for (var a = 0; a < 4; a++) {
          final ang = math.pi / 4 + a * math.pi / 2;
          c.drawCircle(Offset(m + 16 * math.cos(ang), m + 16 * math.sin(ang)), 3, dot);
        }
        c.drawCircle(Offset(m, m), 3.5, s);
        break;
    }
  }

  void _oval(Canvas c, double cx, double cy, double rx, double ry, Paint s) {
    c.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: rx * 2, height: ry * 2), s);
  }

  @override
  bool shouldRepaint(_BatikPainter old) => old.seed != seed || old.label != label;
}

TextStyle batikBody(Color color) => TextStyle(
      color: color.withValues(alpha: 0.75),
      fontSize: 11,
      letterSpacing: 2,
      fontWeight: FontWeight.w600,
    );
