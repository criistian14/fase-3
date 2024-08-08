class Category {
  const Category({
    required this.name,
  });

  final String name;

  @override
  bool operator ==(Object other) {
    return other is Category &&
        other.runtimeType == runtimeType &&
        other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return 'Category{name: $name}';
  }
}
