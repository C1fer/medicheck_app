import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  const CustomDropdownButton({super.key, required this.currentVal, required this.onChanged, required this.values});

  final String currentVal;
  final ValueChanged<String> onChanged;
  final List<String> values;

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: widget.currentVal,
        items: [
          for (String val in widget.values)
          DropdownMenuItem(
            value: val,
            child: Text(val),
          ),
        ],
        onChanged: (String? value) {
          if (value != null) {
            widget.onChanged(value);
          }
        }
    );
  }
}
