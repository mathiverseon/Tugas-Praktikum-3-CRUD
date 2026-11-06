import 'package:dio/dio.dart';
import 'package:ppb_produk_bawaan/models/product_model.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));

  // READ (Fetch All)
  Future<List<Product>> fetchProducts() async {
    final res = await _dio.get('/products');
    return ProductsResponse.fromJson(res.data).products;
  }

  // READ (Search)
  Future<List<Product>> searchProducts(String query) async {
    final res = await _dio.get(
      '/products/search',
      queryParameters: {'q': query},
    );
    return ProductsResponse.fromJson(res.data).products;
  }

  // CREATE
  Future<Product> addProduct(Map<String, dynamic> data) async {
    final res = await _dio.post('/products/add', data: data);
    return Product.fromJson(res.data);
  }

  // UPDATE
  Future<Product> updateProduct(int id, Map<String, dynamic> data) async {
    final res = await _dio.put('/products/$id', data: data);
    return Product.fromJson(res.data);
  }

  // DELETE
  Future<bool> deleteProduct(int id) async {
    final res = await _dio.delete('/products/$id');
    return res.statusCode == 200;
  }
}
