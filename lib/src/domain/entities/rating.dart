class Rating {
  const Rating({
    required this.rate,
    required this.count,
  });

  final double rate;
  final int count;

  @override
  bool operator ==(Object other) {
    return other is Rating &&
        other.runtimeType == runtimeType &&
        other.rate == rate &&
        other.count == count;
  }

  @override
  int get hashCode => rate.hashCode;

  @override
  String toString() {
    return 'Rating{rate: $rate, count: $count}';
  }
}
