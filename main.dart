import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:ppb_produk_bawaan/models/product_model.dart';
import 'package:ppb_produk_bawaan/providers/product_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductProvider()..loadProducts(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Katalog Pastel CRUD',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F4EF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4E09B),
          primary: const Color(0xFFA9C2A6),
          secondary: const Color(0xFFF6C3C5),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF1E3D3),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFF4A4E69)),
          titleTextStyle: TextStyle(
            color: Color(0xFF4A4E69),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showProductForm(BuildContext context, {Product? product}) {
    final titleController = TextEditingController(text: product?.title ?? '');
    final priceController = TextEditingController(
      text: product?.price.toString() ?? '',
    );
    final descController = TextEditingController(
      text: product?.description ?? '',
    );
    final imageController = TextEditingController(
      text: product?.thumbnail ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFFFDF9),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                product == null ? 'Tambah Produk Baru' : 'Edit Produk',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A4E69),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  filled: true,
                  fillColor: const Color(0xFFF7F4EF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Harga (\$)',
                  filled: true,
                  fillColor: const Color(0xFFF7F4EF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              if (product == null) ...[
                const SizedBox(height: 10),
                TextField(
                  controller: imageController,
                  decoration: InputDecoration(
                    labelText: 'URL Gambar (opsional)',
                    hintText: 'https://example.com/image.jpg',
                    filled: true,
                    fillColor: const Color(0xFFF7F4EF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              TextField(
                controller: descController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Produk',
                  filled: true,
                  fillColor: const Color(0xFFF7F4EF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA9C2A6),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    final title = titleController.text;
                    final price = double.tryParse(priceController.text) ?? 0.0;
                    final desc = descController.text;
                    final imgUrl = imageController.text;

                    if (title.isNotEmpty && price > 0) {
                      final provider = Provider.of<ProductProvider>(
                        context,
                        listen: false,
                      );
                      if (product == null) {
                        provider.addProduct(title, price, desc, imgUrl);
                      } else {
                        provider.updateProduct(product.id, title, price);
                      }
                      Navigator.pop(ctx);
                    }
                  },
                  child: Text(
                    product == null ? 'Simpan Produk' : 'Perbarui Produk',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Katalog Produk')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFA9C2A6),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tambah Produk',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () => _showProductForm(context),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (val) => provider.search(val),
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF4A4E69)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFA9C2A6)),
                  )
                : provider.products.isEmpty
                ? const Center(child: Text('Tidak ada produk ditemukan'))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: provider.products.length,
                    itemBuilder: (context, index) {
                      final p = provider.products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(product: p),
                            ),
                          );
                        },
                        child: Card(
                          color: const Color(0xFFFFFDF9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(15),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: p.thumbnail,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    placeholder: (c, u) => const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFFA9C2A6),
                                      ),
                                    ),
                                    errorWidget: (c, u, e) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4A4E69),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$${p.price}',
                                          style: const TextStyle(
                                            color: Color(0xFF9A7B9A),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () => _showProductForm(
                                                context,
                                                product: p,
                                              ),
                                              child: const Icon(
                                                Icons.edit,
                                                size: 18,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            InkWell(
                                              onTap: () {
                                                provider.deleteProduct(p.id);
                                              },
                                              child: const Icon(
                                                Icons.delete,
                                                size: 18,
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Product product;
  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () {
              Provider.of<ProductProvider>(
                context,
                listen: false,
              ).deleteProduct(product.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: product.thumbnail,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A4E69),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Brand: ${product.brand.isEmpty ? 'Katalog Store' : product.brand}',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                Text(' ${product.rating}'),
                const Spacer(),
                Text(
                  '\$${product.price}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9A7B9A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Deskripsi:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A4E69),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6C757D),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
