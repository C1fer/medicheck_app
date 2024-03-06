import 'package:flutter/material.dart';

Future<void> showCustomDialog(
    BuildContext context, Function(BuildContext context) builder,
    {bool? dismissible, double? width, double? height}) async {
  return await showDialog<void>(
    context: context,
    barrierDismissible: dismissible ?? false,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
          builder: (context, setState) => Dialog(
                alignment: Alignment.center,
                surfaceTintColor: Colors.white,
                backgroundColor: Colors.white,
                child: Container(
                  width: width ?? 325,
                  height: height ?? 400,
                  padding: const EdgeInsets.all(32.0),
                  child: builder(dialogContext),
                ),
              )
      );
    },
  );
}
