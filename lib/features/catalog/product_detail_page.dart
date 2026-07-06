import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/batik_motif.dart';
import '../../core/currency.dart';
import '../../core/theme.dart';
import 'catalog_providers.dart';

class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({super.key, required this.slug});
  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productProvider(slug));
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: product.when(
        loading: () => const Center(child: CircularProgressIndicator(color: BatikColors.nila)),
        error: (e, _) => Center(child: Text('Produk tidak ditemukan.\n$e')),
        data: (p) {
          final facts = <List<String>>[
            ['Teknik', techniqueLabel[p.technique] ?? p.technique],
            if (p.motif != null) ['Motif', p.motif!],
            if (p.material != null) ['Bahan', p.material!],
            if (p.color != null) ['Warna', p.color!],
            if (p.categoryName != null) ['Kategori', p.categoryName!],
          ];
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              // Media
              AspectRatio(
                aspectRatio: 4 / 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (p.primaryImage != null)
                      Image.network(
                        p.primaryImage!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            BatikMotif(seed: p.slug, label: p.motif ?? p.categoryName ?? 'Batik'),
                      )
                    else
                      BatikMotif(seed: p.slug, label: p.motif ?? p.categoryName ?? 'Batik'),
                    Positioned(
                      left: 16,
                      top: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
                        decoration: BoxDecoration(
                          color: BatikColors.mori.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          techniqueLabel[p.technique] ?? p.technique,
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w700, color: BatikColors.soga),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (p.categoryName != null)
                      Text(p.categoryName!, style: batikDisplay(size: 14, italic: true, color: BatikColors.soga)),
                    const SizedBox(height: 2),
                    Text(p.name, style: batikDisplay(size: 28, weight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Text(rupiah(p.price),
                        style: const TextStyle(
                            fontSize: 26, color: BatikColors.sogaDeep, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 8, color: p.stock > 0 ? Colors.green.shade600 : BatikColors.tanah),
                        const SizedBox(width: 6),
                        Text(
                          p.stock > 0 ? 'Tersedia · stok ${p.stock}' : 'Stok habis',
                          style: TextStyle(color: BatikColors.nila.withValues(alpha: 0.6), fontSize: 13),
                        ),
                      ],
                    ),
                    if (p.description != null) ...[
                      const SizedBox(height: 16),
                      Text(p.description!,
                          style: TextStyle(height: 1.6, color: BatikColors.nila.withValues(alpha: 0.75))),
                    ],
                    const SizedBox(height: 20),

                    // Aksi
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                            label: const Text('Pesan sekarang'),
                            style: FilledButton.styleFrom(
                              backgroundColor: BatikColors.nila,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: BatikColors.tanah,
                            side: BorderSide(color: BatikColors.nila.withValues(alpha: 0.15)),
                            padding: const EdgeInsets.all(14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Icon(Icons.favorite_border),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Spesifikasi
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        children: [
                          for (var i = 0; i < facts.length; i++)
                            Container(
                              color: i.isEven ? BatikColors.paper : BatikColors.moriDeep.withValues(alpha: 0.4),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(facts[i][0],
                                      style: TextStyle(color: BatikColors.nila.withValues(alpha: 0.5))),
                                  Text(facts[i][1], style: const TextStyle(fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    if (p.vendorName != null) ...[
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: BatikColors.paper,
                          border: Border.all(color: BatikColors.nila.withValues(alpha: 0.1)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: BatikColors.nila,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(p.vendorName![0],
                                  style: batikDisplay(size: 20, weight: FontWeight.w700, color: BatikColors.kunyit)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Dijual oleh UMKM',
                                      style: TextStyle(fontSize: 11, color: BatikColors.nila.withValues(alpha: 0.5))),
                                  Text(p.vendorName!, style: batikDisplay(size: 18, weight: FontWeight.w600)),
                                  if (p.vendorKecamatan != null)
                                    Text('${p.vendorKecamatan}, Pasuruan',
                                        style: TextStyle(fontSize: 12, color: BatikColors.nila.withValues(alpha: 0.6))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
