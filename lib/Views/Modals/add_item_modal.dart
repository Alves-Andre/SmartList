import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartlist/DesignSystem/shared/colors.dart';
import 'package:smartlist/Models/list_item.dart';
import 'package:smartlist/Database/database_helper.dart';
import 'package:smartlist/DesignSystem/Components/Buttons/ActionButton/action_button.dart';
import 'package:smartlist/DesignSystem/Components/Buttons/ActionButton/action_button_view_model.dart';

class AddItemModal extends StatefulWidget {
  final int listId;

  const AddItemModal({
    super.key,
    required this.listId,
  });

  @override
  State<AddItemModal> createState() => _AddItemModalState();
}

class _AddItemModalState extends State<AddItemModal> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();

  Future<void> _saveItem() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um nome para o item')),
      );
      return;
    }

    final quantity = int.tryParse(_quantityController.text) ?? 1;

    final item = ListItem(
      listId: widget.listId,
      name: _nameController.text,
      quantity: quantity,
    );

    try {
      await DatabaseHelper.instance.addListItem(item);
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao adicionar item')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add New Item',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: normalPrimaryBaseColorLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Item name',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: normalPrimaryBaseColorLight,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter item name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Quantity',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: normalPrimaryBaseColorLight,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Enter quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ActionButton.instantiate(
                  viewModel: ActionButtonViewModel(
                    size: ActionButtonSize.medium,
                    style: ActionButtonStyle.primary,
                    text: 'Save',
                    onPressed: _saveItem,
                  ),
                ),
              ),
            ],
          ),
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