class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double rating;
  final String brand;
  final String thumbnail;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.brand,
    required this.thumbnail,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      brand: json['brand'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      images:
          (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class ProductsResponse {
  final List<Product> products;
  ProductsResponse({required this.products});

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['products'] as List;
    return ProductsResponse(
      products: list.map((e) => Product.fromJson(e)).toList(),
    );
  }
}
