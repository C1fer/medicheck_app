import 'package:flutter/material.dart';

class DocumentTypeDropdown extends StatefulWidget {
  String docType;

  DocumentTypeDropdown({super.key, required this.docType});

  @override
  State<DocumentTypeDropdown> createState() => _DocumentTypeDropdownState();
}

class _DocumentTypeDropdownState extends State<DocumentTypeDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: widget.docType,
        items: [
          DropdownMenuItem(
            child: Text('Cédula'),
            value: 'CEDULA',
          ),
          DropdownMenuItem(
            child: Text('NSS'),
            value: 'NSS',
          ),
          DropdownMenuItem(
            child: Text('Contrato'),
            value: 'CONTRATO',
          )
        ],
        onChanged: (String? value) {
          if (value != null) {
            setState(() => widget.docType = value);
          }
        }
    );
  }
}
