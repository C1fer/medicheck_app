import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LangTest extends StatefulWidget {
  const LangTest({super.key});

  static const String id = "test";

  @override
  State<LangTest> createState() => _LangTestState();
}

class _LangTestState extends State<LangTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(AppLocalizations.of(context).helloWorld),
    );
  }
}
