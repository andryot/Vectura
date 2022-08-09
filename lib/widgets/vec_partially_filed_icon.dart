import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../style/colors.dart';

class VecPartiallyFilledIcon extends StatelessWidget {
  final String innerIcon;
  final String? outerIcon;
  final double size;
  final Color color;
  final double stop;

  const VecPartiallyFilledIcon({
    Key? key,
    required this.innerIcon,
    this.outerIcon,
    required this.size,
    required this.color,
    required this.stop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (Rect rect) {
            return LinearGradient(
              stops: [0, stop, stop],
              colors: [color, color, color.withOpacity(0)],
            ).createShader(rect);
          },
          child: SvgPicture.asset(
            innerIcon,
            width: size,
            height: size,
            fit: BoxFit.scaleDown,
            color: VecColor.resolveColor(context, color),
          ),
        ),
        if (outerIcon != null)
          SvgPicture.asset(
            outerIcon!,
            width: size,
            height: size,
            fit: BoxFit.scaleDown,
            color: VecColor.resolveColor(context, color),
          ),
      ],
    );
  }
}
