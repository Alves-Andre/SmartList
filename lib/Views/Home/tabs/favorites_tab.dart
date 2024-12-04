import 'package:flutter/material.dart';
import 'package:smartlist/DesignSystem/shared/colors.dart';
import 'package:smartlist/Models/shopping_list.dart';
import 'package:smartlist/Database/database_helper.dart';
import 'package:smartlist/Views/ListDetailsView/list_details_view.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  List<ShoppingList> _favoriteLists = [];

  @override
  void initState() {
    super.initState();
    _refreshFavorites();
  }

  Future<void> _refreshFavorites() async {
    final lists = await DatabaseHelper.instance.getFavoriteLists();
    setState(() {
      _favoriteLists = lists;
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
                'Favoritos',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: normalPrimaryBaseColorLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: _favoriteLists.isEmpty
                  ? Expanded(
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/empty-home.svg',
                                  width: 200,
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Nenhum favorito ainda',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: normalPrimaryBaseColorLight,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Favorite suas listas para encontrá-las\nrapidamente aqui',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: normalSecondaryBaseColorLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _favoriteLists.length,
                      itemBuilder: (context, index) {
                        final list = _favoriteLists[index];
                        return InkWell(
                          onTap: () async {
                            final needsUpdate = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListDetailsView(shoppingList: list),
                              ),
                            );
                            if (needsUpdate == true) {
                              _refreshFavorites();
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
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: darkPurpleBrandColor,
                                    ),
                                    onPressed: () async {
                                      await DatabaseHelper.instance.toggleFavorite(
                                        list.id!,
                                        false,
                                      );
                                      _refreshFavorites();
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
    );
  }
} 