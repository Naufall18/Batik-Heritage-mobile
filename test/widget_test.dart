import 'package:flutter_test/flutter_test.dart';
import 'package:batik_heritage/core/currency.dart';

void main() {
  test('rupiah memformat ribuan dengan titik', () {
    expect(rupiah(450000), 'Rp 450.000');
    expect(rupiah(85000), 'Rp 85.000');
    expect(rupiah(1500000), 'Rp 1.500.000');
  });

  test('techniqueLabel memetakan teknik batik', () {
    expect(techniqueLabel['tulis'], 'Batik Tulis');
    expect(techniqueLabel['cap'], 'Batik Cap');
  });
}
