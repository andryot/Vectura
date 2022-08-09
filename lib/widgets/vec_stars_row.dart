import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../style/colors.dart';
import '../style/images.dart';
import 'vec_partially_filed_icon.dart';

class VecStarsRow extends StatelessWidget {
  final double rating;
  const VecStarsRow({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (int i = 0; i < rating.floor(); i++) ...[
            SvgPicture.asset(
              VecImage.starFull,
              width: 24,
              height: 24,
              fit: BoxFit.scaleDown,
            ),
          ],
          if (rating < 5.0 && rating.floor() != rating)
            VecPartiallyFilledIcon(
              innerIcon: VecImage.starFull,
              outerIcon: VecImage.starEmpty,
              size: 24,
              color: VecColor.yellow,
              stop: rating - rating.floor(),
            ),
          for (int i = rating.ceil(); i < 5; i++) ...[
            SvgPicture.asset(
              VecImage.starEmpty,
              width: 24,
              height: 24,
              fit: BoxFit.scaleDown,
            ),
          ],
        ],
      ),
    );
  }
}
