import 'package:flutter/material.dart';
import 'package:ppb_produk_bawaan/models/product_model.dart';
import 'package:ppb_produk_bawaan/services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  List<Product> _allProducts = [];
  List<Product> _displayedProducts = [];
  bool _isLoading = false;

  List<Product> get products => _displayedProducts;
  bool get isLoading => _isLoading;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _allProducts = await _api.fetchProducts();
      _displayedProducts = List.from(_allProducts);
    } catch (e) {
      debugPrint('Error fetch products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search Lokal agar produk buatan user tidak hilang saat filter
  void search(String query) {
    if (query.isEmpty) {
      _displayedProducts = List.from(_allProducts);
    } else {
      _displayedProducts = _allProducts.where((p) {
        return p.title.toLowerCase().contains(query.toLowerCase()) ||
            p.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  // CREATE (Tambah Produk + Foto URL)
  Future<void> addProduct(
    String title,
    double price,
    String description,
    String imageUrl,
  ) async {
    final finalImageUrl = imageUrl.isEmpty
        ? 'https://cdn.dummyjson.com/product-images/1/thumbnail.jpg'
        : imageUrl;

    final customProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      description: description,
      category: 'custom',
      price: price,
      rating: 5.0,
      brand: 'Katalog Store',
      thumbnail: finalImageUrl,
      images: [finalImageUrl],
    );

    _allProducts.insert(0, customProduct);
    _displayedProducts = List.from(_allProducts);
    notifyListeners();

    try {
      await _api.addProduct({
        'title': title,
        'price': price,
        'description': description,
        'thumbnail': finalImageUrl,
      });
    } catch (e) {
      debugPrint('API Add Product error: $e');
    }
  }

  // UPDATE (Edit Produk)
  Future<void> updateProduct(int id, String title, double price) async {
    final index = _allProducts.indexWhere((p) => p.id == id);
    if (index != -1) {
      final old = _allProducts[index];
      _allProducts[index] = Product(
        id: old.id,
        title: title,
        description: old.description,
        category: old.category,
        price: price,
        rating: old.rating,
        brand: old.brand,
        thumbnail: old.thumbnail,
        images: old.images,
      );
      _displayedProducts = List.from(_allProducts);
      notifyListeners();
    }

    try {
      await _api.updateProduct(id, {'title': title, 'price': price});
    } catch (e) {
      debugPrint('API Update error: $e');
    }
  }

  // DELETE (Hapus Produk)
  Future<void> deleteProduct(int id) async {
    _allProducts.removeWhere((p) => p.id == id);
    _displayedProducts = List.from(_allProducts);
    notifyListeners();

    try {
      await _api.deleteProduct(id);
    } catch (e) {
      debugPrint('API Delete error: $e');
    }
  }
}
