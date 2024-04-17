import 'package:flutter/material.dart';
import 'package:medicheck/models/cobertura.dart';
import 'package:medicheck/widgets/cards/feature_card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../cards/coverage_card.dart';
import '../../../models/misc/mock_data.dart';

class WidgetSkeletonList extends StatelessWidget {
  WidgetSkeletonList(
      {super.key,
      required this.widget,
      required this.separator,
      required this.itemCount,
      this.scrollDirection = Axis.vertical,
      this.ignoreContainers = true});

  final Widget widget;
  final Widget separator;
  final int itemCount;
  final Axis scrollDirection;
  final bool ignoreContainers;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, _) => Skeletonizer(child: widget, ignoreContainers: ignoreContainers),
      separatorBuilder: (context, _) => separator,
      itemCount: itemCount,
      scrollDirection: scrollDirection,
    );
  }
}
