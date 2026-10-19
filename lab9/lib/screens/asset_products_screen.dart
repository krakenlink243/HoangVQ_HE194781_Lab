import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/product.dart';

/// Lab 9.1 – Read JSON from assets/data/products.json and show it in a list.
class AssetProductsScreen extends StatefulWidget {
  const AssetProductsScreen({super.key});

  @override
  State<AssetProductsScreen> createState() => _AssetProductsScreenState();
}

class _AssetProductsScreenState extends State<AssetProductsScreen> {
  late final Future<List<Product>> _productsFuture = _loadProducts();

  Future<List<Product>> _loadProducts() async {
    // Step 3: load the raw file content (async).
    final raw = await rootBundle.loadString('assets/data/products.json');
    // Step 4: decode String → List<dynamic> → List<Product>.
    final List<dynamic> data = jsonDecode(raw) as List<dynamic>;
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  String _formatPrice(int vnd) {
    // 1250000 → 1.250.000 ₫
    final digits = vnd.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
    }
    return '$buffer ₫';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('9.1 – Products (assets)')),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Could not load JSON: ${snapshot.error}'),
            );
          }
          final products = snapshot.data!;
          // Step 5: display the data.
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            itemBuilder: (context, i) {
              final p = products[i];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text('${p.id}')),
                  title: Text(p.name),
                  subtitle: Text(p.category),
                  trailing: Text(
                    _formatPrice(p.price),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
