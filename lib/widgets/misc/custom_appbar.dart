import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../styles/app_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  bool canGoBack;
  bool centerTitle;

  CustomAppBar({super.key, required this.title, this.canGoBack = true, this.centerTitle = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: AppStyles.sectionTextStyle,
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: centerTitle,
      leading:  canGoBack ? GestureDetector(
        child: const Icon(Icons.arrow_back_rounded),
        onTap: () => Navigator.pop(context),
      ) : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
