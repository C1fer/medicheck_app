import 'package:flutter/material.dart' hide showModalBottomSheet;
import '../../../styles/app_colors.dart';
import '../../popups/dialog/show_custom_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
      onTap: () => showCustomDialog(context, widget.dialogContent, dismissible: true),
      child: const Icon(
        Icons.tune,
        color: AppColors.lightGray,
      ),
    );
  }
}
