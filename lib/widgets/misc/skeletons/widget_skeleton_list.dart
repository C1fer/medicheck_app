import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
      itemBuilder: (context, _) => Skeletonizer(ignoreContainers: ignoreContainers, child: widget),
      separatorBuilder: (context, _) => separator,
      itemCount: itemCount,
      scrollDirection: scrollDirection,
    );
  }
}
