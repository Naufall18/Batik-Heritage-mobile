import 'package:go_router/go_router.dart';

import 'features/catalog/product_detail_page.dart';
import 'home_shell.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeShell()),
    GoRoute(
      path: '/produk/:slug',
      builder: (_, state) => ProductDetailPage(slug: state.pathParameters['slug']!),
    ),
  ],
);
