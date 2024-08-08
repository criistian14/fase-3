import 'package:fake_store_client/src/domain/domain.dart';

class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.rating,
    this.description,
    this.image,
  });

  factory Product.empty() => const Product(
        id: 0,
        title: '',
        price: 0,
        category: Category(name: ''),
        rating: Rating(
          count: 0,
          rate: 0,
        ),
      );

  final int id;
  final String title;
  final double price;
  final String? description;
  final Category category;
  final String? image;
  final Rating rating;

  @override
  bool operator ==(Object other) {
    return other is Product &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.title == title &&
        other.price == price &&
        other.description == description &&
        other.category == category &&
        other.image == image &&
        other.rating == rating;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Product{'
        'id: $id, title: $title, price: $price, '
        'description: $description, category: $category, image: $image, '
        'rating: $rating'
        '}';
  }
}
