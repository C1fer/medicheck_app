import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../generated/assets.dart';
import '../styles/app_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Heading extends StatefulWidget {
  const Heading({super.key, required this.msg});

  final String msg;

  @override
  State<Heading> createState() => _HeadingState();
}

class _HeadingState extends State<Heading> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
            child: SvgPicture.asset(
              Assets.iconsArrowLeft,
              height: 24.0,
              width: 24.0,
              color: Colors.black,
            ),
            onTap: () => Navigator.pop(context)),
        Expanded(
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  widget.msg,
                  style: AppStyles.sectionTextStyle,
                )))
      ],
    );
  }
}
