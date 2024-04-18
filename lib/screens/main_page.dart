import 'package:flutter/material.dart';
import 'package:medicheck/screens/home/products/product_search.dart';
import 'package:medicheck/screens/home/home.dart';
import 'package:medicheck/screens/home/settings/settings.dart';
import 'package:medicheck/styles/app_colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  static const String id = "main_page";
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _pages = [const Home(), const ProductSearch(), const SettingsPage()];
  int _currentIdx = 0;

  Future<void> onTabSelected(int selectedIndex) async {
    setState(() => _currentIdx = selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(),
      body: IndexedStack(
        index: _currentIdx,
        children: _pages,
      ),
    );
  }

  Widget NavBar() {
    return BottomNavigationBar(
      useLegacyColorScheme: false,
      elevation: 15,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
      ],
      onTap: (idx) => onTabSelected(idx),
      selectedItemColor: AppColors.jadeGreen,
      currentIndex: _currentIdx,
      showUnselectedLabels: false,
    );
  }
}
