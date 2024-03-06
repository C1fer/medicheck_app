import 'package:flutter/material.dart';
import '../../../styles/app_colors.dart';
import '../../popups/dialog/show_custom_dialog.dart';

class FilterButton extends StatefulWidget {
  const FilterButton({super.key, required this.dialogContent});
  final Widget dialogContent;

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showCustomDialog(context, (context) => widget.dialogContent, dismissible: true),
      child: const Icon(
        Icons.filter_alt_outlined,
        color: AppColors.lightGray,
      ),
    );
  }
}
