import 'package:flutter/material.dart';
import 'package:medicheck/styles/app_decorations.dart';

Widget StepCounter(int idx, int currStep) {
  return idx == currStep
      ? Container(
          width: 16,
          height: 8,
          decoration: AppDecorations.stepCounterDecoration,
        )
      : Opacity(
          opacity: 0.30,
          child: Container(
            width: 16,
            height: 8,
            decoration: AppDecorations.stepCounterDecoration,
          ),
        );
}
