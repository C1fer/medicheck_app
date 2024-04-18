import 'package:flutter/material.dart';
import 'package:medicheck/styles/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomDropdownButton extends StatefulWidget {
  CustomDropdownButton(
      {super.key,
      required this.value,
      required this.onChanged,
      required this.entries,
      this.hintText,
      this.isNullable = false,
      this.isExpanded = false,
      this.underlined = false,
      this.decoration,
      this.optionsBorderRadius = 24.0});

  String? value;
  final ValueChanged<String?> onChanged;
  final List<DropdownMenuItem<String>> entries;
  final String? hintText;
  final bool isNullable;
  final bool isExpanded;
  final bool underlined;
  final Decoration? decoration;
  double optionsBorderRadius;

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      decoration: widget.decoration ?? BoxDecoration(
          border: Border.all(width: 1, color: AppColors.lightGray),
          borderRadius: BorderRadius.circular(24.0)),
      child: DropdownButton<String?>(
        isExpanded: widget.isExpanded,
        hint: widget.hintText != null ? Text(widget.hintText!) : null,
        value: widget.value,
        items: [
          if (widget.isNullable)
            DropdownMenuItem(
              value: null,
              child: Text(AppLocalizations.of(context).select_an_option),
            ),
          ...widget.entries,
        ],
        onChanged: (String? value) {
          setState(() => widget.value = value);
          widget.onChanged(value);
        },
        style: const TextStyle(fontSize: 16.0, color: Colors.black),
        underline: widget.underlined ? null : const SizedBox() ,
        borderRadius: BorderRadius.circular(widget.optionsBorderRadius),
      ),
    );
  }
}
