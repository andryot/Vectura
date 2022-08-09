import 'package:flutter/cupertino.dart';

import 'vec_divider.dart';

class VecAnimatedDivider extends StatelessWidget {
  final double? padding;
  final bool faded;
  final Duration? duration;

  const VecAnimatedDivider(
      {Key? key, this.padding, required this.faded, this.duration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: faded ? 0.0 : 1.0,
      duration: duration ?? const Duration(milliseconds: 400),
      child: VecDivider(
        padding: padding ?? 0,
      ),
    );
  }
}
