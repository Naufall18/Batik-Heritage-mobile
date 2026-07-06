class Product {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final double price;
  final int stock;
  final String technique;
  final String? motif;
  final String? material;
  final String? color;
  final String? primaryImage;
  final String? categoryName;
  final String? vendorName;
  final String? vendorSlug;
  final String? vendorKecamatan;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.price,
    required this.stock,
    required this.technique,
    this.description,
    this.motif,
    this.material,
    this.color,
    this.primaryImage,
    this.categoryName,
    this.vendorName,
    this.vendorSlug,
    this.vendorKecamatan,
  });

  factory Product.fromJson(Map<String, dynamic> j) {
    final category = j['category'] as Map<String, dynamic>?;
    final vendor = j['vendor'] as Map<String, dynamic>?;
    return Product(
      id: j['id'] as int,
      name: j['name'] as String,
      slug: j['slug'] as String,
      description: j['description'] as String?,
      price: (j['price'] as num).toDouble(),
      stock: (j['stock'] as num?)?.toInt() ?? 0,
      technique: j['technique'] as String? ?? 'cap',
      motif: j['motif'] as String?,
      material: j['material'] as String?,
      color: j['color'] as String?,
      primaryImage: j['primary_image'] as String?,
      categoryName: category?['name'] as String?,
      vendorName: vendor?['name'] as String?,
      vendorSlug: vendor?['slug'] as String?,
      vendorKecamatan: vendor?['kecamatan'] as String?,
    );
  }
}

class Vendor {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? whatsapp;
  final String? kecamatan;
  final double? latitude;
  final double? longitude;
  final double? distanceKm;
  final int productsCount;

  Vendor({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.whatsapp,
    this.kecamatan,
    this.latitude,
    this.longitude,
    this.distanceKm,
    this.productsCount = 0,
  });

  factory Vendor.fromJson(Map<String, dynamic> j) {
    return Vendor(
      id: j['id'] as int,
      name: j['name'] as String,
      slug: j['slug'] as String,
      description: j['description'] as String?,
      whatsapp: j['whatsapp'] as String?,
      kecamatan: j['kecamatan'] as String?,
      latitude: (j['latitude'] as num?)?.toDouble(),
      longitude: (j['longitude'] as num?)?.toDouble(),
      distanceKm: (j['distance_km'] as num?)?.toDouble(),
      productsCount: (j['products_count'] as num?)?.toInt() ?? 0,
    );
  }
}
