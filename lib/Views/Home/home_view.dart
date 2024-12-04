import 'package:flutter/material.dart';
import 'package:smartlist/DesignSystem/shared/colors.dart';
import 'package:smartlist/Views/Home/tabs/favorites_tab.dart';
import 'package:smartlist/Views/Home/tabs/history_tab.dart';
import 'package:smartlist/Views/Home/tabs/lists_tab.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    const ListsTab(),     // Tab de listas
    const FavoritesTab(), // Tab de favoritos
    const HistoryTab(),   // Tab de histórico
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightTertiaryBaseColorLight,
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: darkPurpleBrandColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
        ],
      ),
    );
  }
}