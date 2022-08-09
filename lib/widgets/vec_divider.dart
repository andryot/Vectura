import 'package:flutter/cupertino.dart';

import '../style/colors.dart';

class VecDivider extends StatelessWidget {
  final double? padding;
  const VecDivider({Key? key, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding ?? 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                width: 1,
                color: VecColor.resolveColor(
                    context, VecColor.primaryContrastingColor.withAlpha(25))),
          ),
        ),
      ),
    );
  }
}
