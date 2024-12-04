class ListItem {
  final int? id;
  final int listId;
  final String name;
  final int quantity;
  final bool isCompleted;
  final bool wasSelected;

  ListItem({
    this.id,
    required this.listId,
    required this.name,
    required this.quantity,
    this.isCompleted = false,
    this.wasSelected = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'listId': listId,
      'name': name,
      'quantity': quantity,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory ListItem.fromMap(Map<String, dynamic> map) {
    return ListItem(
      id: map['id'],
      listId: map['listId'],
      name: map['name'],
      quantity: map['quantity'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
} 