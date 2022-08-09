import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../style/colors.dart';
import '../style/styles.dart';

class VecListTile extends StatelessWidget {
  final String title;
  final String image;
  final bool expanded;

  final Function()? onTap;

  const VecListTile(
      {Key? key,
      required this.title,
      required this.image,
      required this.expanded,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: VecColor.resolveColor(context, VecColor.highlightColor),
        height: 60,
        child: Center(
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  title,
                  style: VecStyles.listTileTextStyle(context),
                ),
              ),
              AnimatedRotation(
                turns: expanded ? math.pi / 13 : 0,
                duration: const Duration(milliseconds: 400),
                child: SvgPicture.asset(
                  image,
                  color: VecColor.primaryColor(context),
                ),
              ),
              const SizedBox(
                width: 29.75,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
