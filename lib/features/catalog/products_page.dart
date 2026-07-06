import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/batik_motif.dart';
import '../../core/currency.dart';
import '../../core/theme.dart';
import 'catalog_providers.dart';
import 'models.dart';

class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    return products.when(
      loading: () => const Center(child: CircularProgressIndicator(color: BatikColors.nila)),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Gagal memuat produk.\n$e', textAlign: TextAlign.center),
        ),
      ),
      data: (items) => RefreshIndicator(
        color: BatikColors.nila,
        onRefresh: () async => ref.refresh(productsProvider.future),
        child: GridView.builder(
          padding: const EdgeInsets.all(14),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemCount: items.length,
          itemBuilder: (_, i) => _ProductCard(product: items[i]),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/produk/${product.slug}'),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: BatikColors.paper,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: BatikColors.nila.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: BatikColors.nila.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (product.primaryImage != null)
                    Image.network(
                      product.primaryImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          BatikMotif(seed: product.slug, label: product.motif ?? product.categoryName ?? 'Batik'),
                    )
                  else
                    BatikMotif(seed: product.slug, label: product.motif ?? product.categoryName ?? 'Batik'),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: BatikColors.mori.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        techniqueLabel[product.technique] ?? product.technique,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: BatikColors.soga,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: batikDisplay(size: 16, weight: FontWeight.w600, height: 1.05),
                  ),
                  if (product.vendorKecamatan != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.place_outlined, size: 12, color: BatikColors.nila.withValues(alpha: 0.5)),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            product.vendorKecamatan!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 11, color: BatikColors.nila.withValues(alpha: 0.5)),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    rupiah(product.price),
                    style: const TextStyle(color: BatikColors.sogaDeep, fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
