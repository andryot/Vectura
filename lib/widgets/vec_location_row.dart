import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../style/colors.dart';
import '../style/images.dart';
import '../style/styles.dart';

class VecLoactionRow extends StatelessWidget {
  final String from;
  final String to;
  const VecLoactionRow({Key? key, required this.from, required this.to})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          from,
          style: VecStyles.cardStrongTextStyle(context),
        ),
        const SizedBox(
          width: 22.75,
        ),
        SvgPicture.asset(
          VecImage.rightArrow,
          color: VecColor.resolveColor(context, VecColor.strong),
        ),
        const SizedBox(
          width: 21.75,
        ),
        Text(
          to,
          style: VecStyles.cardStrongTextStyle(context),
        ),
      ],
    );
  }
}
