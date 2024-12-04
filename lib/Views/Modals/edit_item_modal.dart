import 'package:flutter/material.dart';
import 'package:smartlist/Models/list_item.dart';
import 'package:smartlist/Database/database_helper.dart';

class EditItemModal extends StatefulWidget {
  final ListItem item;

  const EditItemModal({super.key, required this.item});

  @override
  State<EditItemModal> createState() => _EditItemModalState();
}

class _EditItemModalState extends State<EditItemModal> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _quantityController = TextEditingController(text: widget.item.quantity.toString());
  }

  Future<void> _saveChanges() async {
    final updatedItem = ListItem(
      id: widget.item.id,
      listId: widget.item.listId,
      name: _nameController.text,
      quantity: int.parse(_quantityController.text),
      isCompleted: widget.item.isCompleted,
      wasSelected: widget.item.wasSelected,
    );

    await DatabaseHelper.instance.updateListItem(updatedItem);
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome do item'),
            ),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantidade'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
} 