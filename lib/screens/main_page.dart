import 'package:flutter/material.dart';
import 'package:medicheck/screens/home/products/product_search.dart';
import 'package:medicheck/screens/home/home.dart';
import 'package:medicheck/screens/home/settings/settings.dart';
import 'package:medicheck/styles/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final locale = AppLocalizations.of(context);
    return BottomNavigationBar(
      useLegacyColorScheme: false,
      elevation: 15,
      items:  <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: const Icon(Icons.home), label: locale.home_tab),
        BottomNavigationBarItem(icon: const Icon(Icons.search), label: locale.search_tab),
        BottomNavigationBarItem(icon: const Icon(Icons.person), label: locale.account_tab),
      ],
      onTap: (idx) => onTabSelected(idx),
      selectedItemColor: AppColors.jadeGreen,
      currentIndex: _currentIdx,
      showUnselectedLabels: false,
    );
  }
}
