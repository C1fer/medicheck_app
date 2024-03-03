import 'package:flutter/material.dart';
import 'package:medicheck/styles/app_colors.dart';

class CustomDropdownButton extends StatefulWidget {
  const CustomDropdownButton({super.key, required this.currentVal, required this.onChanged, required this.entries, this.hintText});

  final String currentVal;
  final ValueChanged<String> onChanged;
  final List<DropdownMenuItem<String>> entries;
  final String? hintText;

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      decoration: BoxDecoration(border: Border.all(width: 1, color: AppColors.lightGray), borderRadius: BorderRadius.circular(24.0)),
      child: DropdownButton(
        hint: widget.hintText != null ? Text(widget.hintText!) : null,
          value: widget.currentVal,
          items: widget.entries,
          onChanged: (String? value) {
            if (value != null) {
              widget.onChanged(value);
            }
          },
        style: const TextStyle(fontSize: 16.0, color: Colors.black),
        underline: const SizedBox(),
        borderRadius: BorderRadius.circular(24.0),
      ),
    );
  }
}
