/// Item of assets/data/products.json (Lab 9.1).
class Product {
  final int id;
  final String name;
  final String category;
  final int price; // VND

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as int,
    name: json['name'] as String,
    category: json['category'] as String,
    price: json['price'] as int,
  );
}
