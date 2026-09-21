import 'dart:async';

import 'package:lab3/product.dart';

class ProductRepo {
  final List<Product> _products = [];

  final StreamController<Product> _controller = StreamController<Product>.broadcast();

  Future<List<Product>> getAll() async{
    await Future.delayed(const Duration(seconds: 1));
    return List.unmodifiable(_products);
  }

  Stream<Product> liveAdded() => _controller.stream;

  void add(Product p){
    _products.add(p);
    _controller.add(p);
  }

  void dispose() => _controller.close();
}