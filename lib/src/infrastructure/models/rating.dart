import 'package:fake_store_client/src/domain/domain.dart';

class RatingModel {
  const RatingModel({
    required this.rate,
    required this.count,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) => RatingModel(
        rate: double.tryParse(json['rate'].toString()) ?? 0,
        count: int.tryParse(json['count'].toString()) ?? 0,
      );

  factory RatingModel.empty() => const RatingModel(
        rate: 0,
        count: 0,
      );

  final double rate;
  final int count;

  Rating toEntity() => Rating(
        rate: rate,
        count: count,
      );
}
