import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';
import 'router.dart';

void main() {
  runApp(const ProviderScope(child: BatikApp()));
}

class BatikApp extends StatelessWidget {
  const BatikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Batik Heritage',
      debugShowCheckedModeBanner: false,
      theme: batikTheme(),
      routerConfig: router,
    );
  }
}
