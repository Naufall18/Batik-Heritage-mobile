String rupiah(double n) {
  final s = n.toInt().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return 'Rp ${buf.toString()}';
}

const techniqueLabel = <String, String>{
  'tulis': 'Batik Tulis',
  'cap': 'Batik Cap',
  'printing': 'Printing',
  'kombinasi': 'Kombinasi',
};
