import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartlist/DesignSystem/Components/Buttons/ActionButton/action_button.dart';
import 'package:smartlist/DesignSystem/Components/Buttons/ActionButton/action_button_view_model.dart';
import 'package:smartlist/DesignSystem/shared/colors.dart';
import 'package:smartlist/Models/shopping_list.dart';
import 'package:smartlist/Database/database_helper.dart';
import 'package:smartlist/Views/Modals/add_list_modal.dart';
import 'package:smartlist/Views/ListDetailsView/list_details_view.dart';

class ListsTab extends StatefulWidget {
  const ListsTab({super.key});

  @override
  State<ListsTab> createState() => _ListsTabState();
}

class _ListsTabState extends State<ListsTab> {
  List<ShoppingList> _lists = [];

  @override
  void initState() {
    super.initState();
    _refreshLists();
  }

  Future<void> _refreshLists() async {
    final lists = await DatabaseHelper.instance.getLists();
    setState(() {
      _lists = lists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightTertiaryBaseColorLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Minhas Listas',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: normalPrimaryBaseColorLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: _lists.isEmpty
                  ? const _EmptyStateContent()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _lists.length,
                      itemBuilder: (context, index) {
                        final list = _lists[index];
                        return InkWell(
                          onTap: () async {
                            final needsUpdate = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListDetailsView(shoppingList: list),
                              ),
                            );
                            if (needsUpdate == true) {
                              _refreshLists();
                            }
                          },
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 2,
                            shadowColor: normalPurpleBrandColor.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(
                                color: normalPurpleBrandColor,
                                width: 1,
                              ),
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: darkPurpleBrandColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.format_list_numbered,
                                      color: darkPurpleBrandColor,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          list.name,
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: normalPrimaryBaseColorLight,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.local_offer_outlined,
                                              size: 16,
                                              color: normalSecondaryBaseColorLight,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              list.category,
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: normalSecondaryBaseColorLight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      list.isFavorite ? Icons.favorite : Icons.favorite_outline,
                                      color: darkPurpleBrandColor,
                                    ),
                                    onPressed: () async {
                                      await DatabaseHelper.instance.toggleFavorite(
                                        list.id!,
                                        !list.isFavorite,
                                      );
                                      _refreshLists();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: 
        ActionButton.instantiate(viewModel: 
          ActionButtonViewModel(
            size: ActionButtonSize.large,
            style: ActionButtonStyle.primary,
            text: '',
            icon: Icons.add,
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => const AddListModal(),
              );
              if (result == true) {
                _refreshLists();
              }
            },
          )
      ),
    );
  }
}

class _EmptyStateContent extends StatelessWidget {
  const _EmptyStateContent();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/empty-home.svg',
              width: 200,
            ),
            const SizedBox(height: 24),
            Text(
              'Começe criando uma lista',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: normalPrimaryBaseColorLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sua lista inteligente será mostrada aqui,\ncomece criando uma nova lista',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: normalSecondaryBaseColorLight,
              ),
            ),
            const SizedBox(height: 40),
            SvgPicture.asset(
              'assets/images/Hand-drawn arrow.svg',
              width: 100,
            ),
          ],
        ),
      ),
    );
  }
} 