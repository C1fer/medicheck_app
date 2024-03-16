import 'package:flutter/material.dart';
import '../../models/enums.dart';
import '../../styles/app_colors.dart';

class ViewModeButton extends StatefulWidget {
  ViewModeButton({super.key, required this.value, required this.onTap});

  itemsViewMode value;
  Function(itemsViewMode) onTap;

  @override
  State<ViewModeButton> createState() => _ViewModeButtonState();
}

class _ViewModeButtonState extends State<ViewModeButton> {
  itemsViewMode setViewMode() {
    itemsViewMode newMode;
    newMode = widget.value == itemsViewMode.LIST
        ? itemsViewMode.GRID
        : itemsViewMode.LIST;
    setState(() => widget.value = newMode);
    return newMode;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          setViewMode();
          widget.onTap(widget.value);
        },
        icon: Icon(
          widget.value == itemsViewMode.LIST ? Icons.grid_view: Icons.view_agenda_outlined,
        ));
  }
}
