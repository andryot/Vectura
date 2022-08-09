import 'package:flutter/cupertino.dart';

import '../style/colors.dart';
import '../style/constants.dart';

class VecButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? color;

  const VecButton({
    Key? key,
    required this.child,
    this.onPressed,
  })  : color = null,
        super(key: key);

  const VecButton.filled({
    Key? key,
    required this.child,
    this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: child,
      onPressed: onPressed,
      color: color,
      disabledColor:
          (color ?? CupertinoTheme.of(context).primaryColor).withOpacity(0.4),
    );
  }
}

class VecTextShadowButton extends VecButton {
  VecTextShadowButton({
    Key? key,
    required String text,
    VoidCallback? onPressed,
  }) : super(
          key: key,
          child: Text(text),
          onPressed: onPressed,
        );

  VecTextShadowButton.filled({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    Color? color,
    TextStyle? textStyle,
    Widget? child,
  }) : super.filled(
          key: key,
          child: child ??
              Text(
                text,
                style: textStyle ?? const TextStyle(color: VecColor.primary),
              ),
          onPressed: onPressed,
          color: color,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: buttonHeight,
      decoration: const BoxDecoration(
          boxShadow: [buttonBoxShadow], borderRadius: kBorderRadius),
      child: CupertinoButton(
        child: child,
        onPressed: onPressed,
        color: color,
        disabledColor:
            (color ?? CupertinoTheme.of(context).primaryColor).withOpacity(0.4),
      ),
    );
  }
}
