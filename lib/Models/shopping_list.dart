class ShoppingList {
  final int? id;
  final String name;
  final String category;
  final String description;
  final bool isFavorite;

  ShoppingList({
    this.id,
    required this.name,
    required this.category,
    required this.description,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'description': description,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory ShoppingList.fromMap(Map<String, dynamic> map) {
    return ShoppingList(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      description: map['description'],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  ShoppingList copyWith({
    int? id,
    String? name,
    String? category,
    String? description,
    bool? isFavorite,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
} 