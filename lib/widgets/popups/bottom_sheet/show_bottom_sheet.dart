import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<void> showRoundedModalBottomSheet(BuildContext context, Widget content, {bool enableDrag = false, bool isDismissible = true}) async {
  return await showMaterialModalBottomSheet<void>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      context: context,
      expand: false,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (context) => content);
}

Future<void> showRoundedBarBottomSheet(BuildContext context, Widget content, {bool enableDrag = true, bool isDismissible = false}) async {
  return await showBarModalBottomSheet<void>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      context: context,
      expand: false,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (context) => content);
}

