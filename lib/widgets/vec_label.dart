import 'package:flutter/cupertino.dart';

import '../style/styles.dart';

class VecLabel extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry? padding;
  const VecLabel({Key? key, required this.text, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(left: 8, bottom: 4),
      child: Text(
        text,
        style: VecStyles.cardNormalTextStyle(context),
      ),
    );
  }
}
