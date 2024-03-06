import 'package:flutter/material.dart';

import '../../../models/debouncer.dart';
import '../../../styles/app_colors.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String?> onChanged;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final _searchDebouncer = Debouncer(milliseconds: 200);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchDebouncer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: widget.controller,
      onChanged: (String? val) =>
          _searchDebouncer.run(() => widget.onChanged(val)),
      hintText: widget.hintText,
      backgroundColor: const MaterialStatePropertyAll<Color>(Color(0xFFF9FAFB)),
      leading: const Icon(
        Icons.search,
        size: 20,
        weight: 1,
        color: AppColors.deepLightGray,
      ),
      padding: const MaterialStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 16.0)),
      hintStyle: const MaterialStatePropertyAll<TextStyle>(
          TextStyle(color: AppColors.deepLightGray, fontSize: 16)),
      side: const MaterialStatePropertyAll<BorderSide>(
        BorderSide(width: 1, color: Color(0xFFE5E7EB)),
      ),
      elevation: const MaterialStatePropertyAll<double?>(0.0),
    );
  }
}
