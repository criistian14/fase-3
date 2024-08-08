import 'package:fake_store_client/src/domain/domain.dart';
import 'package:fake_store_client/src/infrastructure/infrastructure.dart';

class ProductModel {
  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.rating,
    this.description,
    this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: int.tryParse(json['id'].toString()) ?? 0,
        title: json['title']?.toString() ?? '',
        price: double.tryParse(json['price'].toString()) ?? 0,
        description: json['description']?.toString(),
        category: CategoryModel(name: json['category'].toString()),
        image: json['image']?.toString(),
        rating: json['rating'] is Map<String, dynamic>
            ? RatingModel.fromJson(
                json['rating'] as Map<String, dynamic>,
              )
            : RatingModel.empty(),
      );

  final int id;
  final String title;
  final double price;
  final String? description;
  final CategoryModel category;
  final String? image;
  final RatingModel rating;

  Product toEntity() => Product(
        id: id,
        title: title,
        price: price,
        description: description,
        category: category.toEntity(),
        image: image,
        rating: rating.toEntity(),
      );
}
