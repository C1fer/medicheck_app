import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WidgetSkeletonGrid extends StatelessWidget {
  WidgetSkeletonGrid(
      {super.key,
      required this.widget,
      required this.itemCount,
      this.scrollDirection = Axis.vertical,
      this.ignoreContainers = true,
      this.gridDelegate = _defaultGrid,
      this.shrinkWrap = true});

  static const _defaultGrid = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, // Example: 2 columns
    crossAxisSpacing: 8, // Add spacing between columns
    mainAxisSpacing: 8, // Add spacing between rows
  );

  final SliverGridDelegate gridDelegate;
  final Widget widget;
  final int itemCount;
  final Axis scrollDirection;
  final bool ignoreContainers;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: gridDelegate,
      itemBuilder: (context, _) =>
          Skeletonizer(ignoreContainers: ignoreContainers, child: widget),
      scrollDirection: scrollDirection,
      itemCount: itemCount,
      shrinkWrap: shrinkWrap,
    );
  }
}
