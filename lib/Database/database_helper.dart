import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:smartlist/Models/shopping_list.dart';
import 'package:smartlist/Models/list_item.dart';
import 'package:smartlist/Models/purchase_history.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    _database = await _initDB('shopping_lists.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE shopping_lists(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        description TEXT NOT NULL,
        isFavorite INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE list_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        listId INTEGER NOT NULL,
        name TEXT NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 1,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (listId) REFERENCES shopping_lists (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE purchase_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        listId INTEGER NOT NULL,
        listName TEXT NOT NULL,
        purchaseDate TEXT NOT NULL,
        totalSpent REAL NOT NULL,
        FOREIGN KEY (listId) REFERENCES shopping_lists (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE purchased_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        purchaseHistoryId INTEGER NOT NULL,
        name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        wasSelected INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (purchaseHistoryId) REFERENCES purchase_history (id)
      )
    ''');
  }

  Future<int> createList(ShoppingList list) async {
    final db = await instance.database;
    return await db.insert('shopping_lists', list.toMap());
  }

  Future<List<ShoppingList>> getLists() async {
    final db = await instance.database;
    final result = await db.query('shopping_lists');
    return result.map((json) => ShoppingList.fromMap(json)).toList();
  }

  Future<void> deleteList(int id) async {
    final db = await instance.database;
    await db.delete(
      'shopping_lists',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<List<ListItem>> getListItems(int listId) async {
    final db = await instance.database;
    final result = await db.query(
      'list_items',
      where: 'listId = ?',
      whereArgs: [listId],
    );
    return result.map((json) => ListItem.fromMap(json)).toList();
  }

  Future<void> toggleItemCompletion(int itemId) async {
    final db = await instance.database;
    final item = await db.query(
      'list_items',
      where: 'id = ?',
      whereArgs: [itemId],
    );
    
    if (item.isNotEmpty) {
      final currentStatus = item.first['isCompleted'] as int? ?? 0;
      await db.update(
        'list_items',
        {'isCompleted': currentStatus == 0 ? 1 : 0},
        where: 'id = ?',
        whereArgs: [itemId],
      );
    }
  }

  Future<int> addListItem(ListItem item) async {
    final db = await instance.database;
    return await db.insert('list_items', item.toMap());
  }

  Future<void> updateList(ShoppingList list) async {
    try {
      final db = await instance.database;
      await db.update(
        'shopping_lists',
        list.toMap(),
        where: 'id = ?',
        whereArgs: [list.id],
      );
      print('Lista atualizada com sucesso: ${list.toMap()}'); // Debug
    } catch (e) {
      print('Erro ao atualizar lista: $e'); // Debug
      throw e;
    }
  }

  Future<ShoppingList?> getList(int id) async {
    final db = await instance.database;
    final results = await db.query(
      'shopping_lists',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (results.isNotEmpty) {
      return ShoppingList.fromMap(results.first);
    }
    return null;
  }

  Future<void> updateListItem(ListItem item) async {
    final db = await instance.database;
    await db.update(
      'list_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteListItem(int id) async {
    final db = await instance.database;
    await db.delete(
      'list_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> savePurchaseHistory(PurchaseHistory history) async {
    final db = await instance.database;
    final historyId = await db.insert('purchase_history', history.toMap());
    
    for (var item in history.items) {
      await db.insert('purchased_items', {
        ...item.toMap(),
        'purchaseHistoryId': historyId,
      });
    }
    
    return historyId;
  }

  Future<List<PurchaseHistory>> getPurchaseHistory() async {
    final db = await instance.database;
    final histories = await db.query('purchase_history');
    final List<PurchaseHistory> result = [];
    
    for (var history in histories) {
      final purchaseHistory = PurchaseHistory.fromMap(history);
      final items = await db.query(
        'purchased_items',
        where: 'purchaseHistoryId = ?',
        whereArgs: [purchaseHistory.id],
      );
      
      purchaseHistory.items.addAll(
        items.map((item) => PurchasedItem.fromMap(item)),
      );
      
      result.add(purchaseHistory);
    }
    
    return result;
  }

  Future<List<ShoppingList>> getFavoriteLists() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'shopping_lists',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );

    return List.generate(maps.length, (i) {
      return ShoppingList.fromMap(maps[i]);
    });
  }

  Future<void> toggleFavorite(int listId, bool isFavorite) async {
    final db = await instance.database;
    await db.update(
      'shopping_lists',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [listId],
    );
  }
} 