class PurchaseHistory {
  final int? id;
  final int listId;
  final String listName;
  final DateTime purchaseDate;
  final double totalSpent;
  final List<PurchasedItem> items;

  PurchaseHistory({
    this.id,
    required this.listId,
    required this.listName,
    required this.purchaseDate,
    required this.totalSpent,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'listId': listId,
      'listName': listName,
      'purchaseDate': purchaseDate.toIso8601String(),
      'totalSpent': totalSpent,
    };
  }

  factory PurchaseHistory.fromMap(Map<String, dynamic> map) {
    return PurchaseHistory(
      id: map['id'],
      listId: map['listId'],
      listName: map['listName'],
      purchaseDate: DateTime.parse(map['purchaseDate']),
      totalSpent: map['totalSpent'],
      items: [], // Será preenchido separadamente
    );
  }
}

class PurchasedItem {
  final int? id;
  final int purchaseHistoryId;
  final String name;
  final int quantity;
  final bool wasSelected;

  PurchasedItem({
    this.id,
    required this.purchaseHistoryId,
    required this.name,
    required this.quantity,
    required this.wasSelected,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'purchaseHistoryId': purchaseHistoryId,
      'name': name,
      'quantity': quantity,
      'wasSelected': wasSelected ? 1 : 0,
    };
  }

  factory PurchasedItem.fromMap(Map<String, dynamic> map) {
    return PurchasedItem(
      id: map['id'],
      purchaseHistoryId: map['purchaseHistoryId'],
      name: map['name'],
      quantity: map['quantity'],
      wasSelected: map['wasSelected'] == 1,
    );
  }
} 