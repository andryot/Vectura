import 'package:flutter/cupertino.dart';

import '../models/rides/review.dart';
import '../style/colors.dart';
import '../style/styles.dart';
import 'vec_stars_row.dart';

class VecReviewCard extends StatelessWidget {
  final VecturaReview review;
  const VecReviewCard({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: VecColor.resolveColor(
          context,
          VecColor.highlightColor,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15.0, top: 9.0, bottom: 13, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "By: " + (review.userName ?? "anonymus"),
                  style: VecStyles.cardNormalTextStyle(context),
                ),
                const SizedBox(width: 4.75),
                VecStarsRow(rating: review.stars.toDouble()),
              ],
            ),
            Text(review.comment, style: VecStyles.noOffersTextStyle(context)),
          ],
        ),
      ),
    );
  }
}
