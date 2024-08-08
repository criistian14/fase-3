import 'package:fake_store_client/src/domain/domain.dart';

class CategoryModel {
  const CategoryModel({
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        name: json['name'].toString(),
      );

  factory CategoryModel.empty() => const CategoryModel(name: 'empty');

  final String name;

  Category toEntity() => Category(
        name: name,
      );
}
