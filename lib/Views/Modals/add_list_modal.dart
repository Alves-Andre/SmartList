import 'package:flutter/material.dart';
import 'package:smartlist/Models/shopping_list.dart';
import 'package:smartlist/Database/database_helper.dart';
import 'package:smartlist/DesignSystem/shared/colors.dart';

class AddListModal extends StatefulWidget {
  final ShoppingList? editingList;

  const AddListModal({
    super.key,
    this.editingList,
  });

  @override
  State<AddListModal> createState() => _AddListModalState();
}

class _AddListModalState extends State<AddListModal> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    if (widget.editingList != null) {
      _nameController.text = widget.editingList!.name;
      _descriptionController.text = widget.editingList!.description;
      selectedCategory = widget.editingList!.category;
    }
  }

  Future<void> _saveList() async {
    if (_nameController.text.isEmpty || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha os campos obrigatórios')),
      );
      return;
    }

    final list = ShoppingList(
      id: widget.editingList?.id,
      name: _nameController.text,
      category: selectedCategory!,
      description: _descriptionController.text,
      isFavorite: widget.editingList?.isFavorite ?? false,
    );

    try {
      if (widget.editingList != null) {
        await DatabaseHelper.instance.updateList(list);
      } else {
        await DatabaseHelper.instance.createList(list);
      }
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao salvar lista')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pega o tamanho da tela
    final screenWidth = MediaQuery.of(context).size.width;
    // Define a largura do modal baseado no tamanho da tela
    final modalWidth = screenWidth > 600 ? 400.0 : screenWidth * 0.9;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: modalWidth, // Define a largura do modal
          constraints: const BoxConstraints(
            maxWidth: 400, // Largura máxima
            minWidth: 280, // Largura mínima
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.editingList != null ? 'Edit List' : 'Add New List',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: normalPrimaryBaseColorLight,
                          fontWeight: FontWeight.w600,
                        ),
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
                  'List name',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: normalPrimaryBaseColorLight,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter list name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Category',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: normalPrimaryBaseColorLight,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  decoration: InputDecoration(
                    hintText: 'Select category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  items: <String>[
                    'Mercado',
                    'Receita',
                    'Alimento',
                    'Hortifruti',
                    'Congelados',
                    'Limpeza',
                    'Higiene',
                    'Outros'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Description (optional)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: normalPrimaryBaseColorLight,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Enter description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveList,
                    child: Text(widget.editingList != null ? 'Save Changes' : 'Create List'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
} 