import 'package:flutter/material.dart';
import 'package:smartlist/DesignSystem/shared/colors.dart';
import 'package:smartlist/Models/list_item.dart';
import 'package:smartlist/Models/shopping_list.dart';
import 'package:smartlist/Models/purchase_history.dart';
import 'package:smartlist/DesignSystem/Components/Buttons/ActionButton/action_button.dart';
import 'package:smartlist/DesignSystem/Components/Buttons/ActionButton/action_button_view_model.dart';
import 'package:smartlist/Database/database_helper.dart';
import 'package:smartlist/Views/Modals/add_list_modal.dart';
import 'package:smartlist/Views/Modals/add_item_modal.dart';

class ListDetailsView extends StatefulWidget {
  final ShoppingList shoppingList;

  const ListDetailsView({
    super.key,
    required this.shoppingList,
  });

  @override
  State<ListDetailsView> createState() => _ListDetailsViewState();
}

class _ListDetailsViewState extends State<ListDetailsView> {
  late ShoppingList _currentList;
  List<ListItem> _items = [];
  bool _isShoppingMode = false;
  Map<int, bool> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    _currentList = widget.shoppingList;
    _refreshList();
  }

  Future<void> _refreshList() async {
    final updatedList = await DatabaseHelper.instance.getList(_currentList.id!);
    final items = await DatabaseHelper.instance.getListItems(_currentList.id!);
    if (updatedList != null) {
      setState(() {
        _currentList = updatedList;
        _items = items;
      });
    }
  }

  Widget _buildItemList() {
    if (_isShoppingMode) {
      return ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return CheckboxListTile(
            title: Text(item.name),
            subtitle: Text('Quantidade: ${item.quantity}'),
            value: _selectedItems[item.id] ?? false,
            onChanged: (bool? value) {
              setState(() {
                _selectedItems[item.id!] = value ?? false;
              });
            },
          );
        },
      );
    } else {
      return ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text('Quantidade: ${item.quantity}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: normalErrorSystemColor),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirmar exclusão'),
                        content: const Text('Deseja realmente excluir este item?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Excluir'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await DatabaseHelper.instance.deleteListItem(item.id!);
                      _refreshList();
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Future<void> _finishShopping() async {
    final controller = TextEditingController();
    final totalSpent = await showDialog<double>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Finalizar Compra'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Qual foi o valor total gasto?'),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                prefixText: 'R\$ ',
                hintText: '0.00',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              Navigator.pop(context, value);
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (totalSpent != null) {
      final history = PurchaseHistory(
        listId: _currentList.id!,
        listName: _currentList.name,
        purchaseDate: DateTime.now(),
        totalSpent: totalSpent,
        items: _items.map((item) => PurchasedItem(
          purchaseHistoryId: 0,
          name: item.name,
          quantity: item.quantity,
          wasSelected: _selectedItems[item.id] ?? false,
        )).toList(),
      );

      try {
        await DatabaseHelper.instance.savePurchaseHistory(history);
        
        if (mounted) {
          // Mostra mensagem de sucesso
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Compra finalizada com sucesso!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          
          // Retorna para a tela anterior
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro ao salvar a compra'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightTertiaryBaseColorLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: normalPrimaryBaseColorLight),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: normalPrimaryBaseColorLight),
            onSelected: (value) async {
              if (value == 'edit') {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) => AddListModal(
                    editingList: _currentList,
                  ),
                );
                if (result == true) {
                  await _refreshList();
                }
              } else if (value == 'delete') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirmar exclusão'),
                    content: const Text('Deseja realmente excluir esta lista?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          'Excluir',
                          style: TextStyle(color: normalErrorSystemColor),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await DatabaseHelper.instance.deleteList(_currentList.id!);
                  if (mounted) {
                    Navigator.pop(context, true);
                  }
                }
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: normalPurpleBrandColor),
                    SizedBox(width: 8),
                    Text('Editar'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: normalErrorSystemColor),
                    SizedBox(width: 8),
                    Text('Excluir'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _currentList.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: normalPrimaryBaseColorLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _isShoppingMode ? _finishShopping : () {
                        setState(() {
                          _isShoppingMode = true;
                        });
                      },
                      child: Text(_isShoppingMode ? 'Finalizar Compra' : 'Iniciar Compra'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Descrição',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: normalPrimaryBaseColorLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentList.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: normalSecondaryBaseColorLight,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: _buildItemList(),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ActionButton.instantiate(
          viewModel: ActionButtonViewModel(
            size: ActionButtonSize.large,
            style: ActionButtonStyle.secondary,
            text: 'Adicionar novo item',
            onPressed: _isShoppingMode 
              ? (() {}) // Função vazia em vez de null
              : () {
                  showDialog<bool>(
                    context: context,
                    builder: (context) => AddItemModal(listId: _currentList.id!),
                  ).then((result) {
                    if (result == true) {
                      _refreshList();
                    }
                  });
                },
          ),
        ),
      ),
    );
  }
} 