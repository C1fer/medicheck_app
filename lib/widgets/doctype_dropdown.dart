import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DocumentTypeDropdown extends StatefulWidget {
  final String docType;
  final ValueChanged<String> onChanged;

  const DocumentTypeDropdown({super.key, required this.docType, required this.onChanged});

  @override
  State<DocumentTypeDropdown> createState() => _DocumentTypeDropdownState();
}

class _DocumentTypeDropdownState extends State<DocumentTypeDropdown> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return DropdownButton(
        borderRadius: BorderRadius.circular(24.0),
        value: widget.docType,
        items: [
          DropdownMenuItem(
            value: 'CEDULA',
            child: Text(locale.national_id_card_abbrv),
          ),
          DropdownMenuItem(
            value: 'NSS',
            child: Text(locale.ssn_abbrv),
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
