import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/profile/profile_bloc.dart';
import '../style/colors.dart';
import '../style/images.dart';
import '../style/styles.dart';
import '../util/functions/date_time_starting.dart';
import 'vec_stars_row.dart';

class VecSliverAppBar extends SliverPersistentHeaderDelegate {
  final ProfileState state;
  final double _maxExtent;
  final double _minExtent;
  final Uint8List? _image;
  VecSliverAppBar({
    required this.state,
    required double maxExtent,
    required double minExtent,
    Uint8List? image,
  })  : _maxExtent = maxExtent,
        _minExtent = minExtent,
        _image = image,
        super();

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double visibleMainHeight = max(maxExtent - shrinkOffset, minExtent);
    final double animationVal = scrollAnimationValue(shrinkOffset);
    final double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
        left: 20 * animationVal,
        right: 20 * animationVal,
      ),
      child: SizedBox(
        height: visibleMainHeight,
        width: width,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            // BACKGROUND CONTAINER
            Padding(
              padding: EdgeInsets.only(
                  top: 36 * animationVal, bottom: 23 * animationVal),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20 * animationVal),
                  color: VecColor.resolveColor(
                    context,
                    VecColor.highlightColor,
                  ),
                ),
              ),
            ),

            // AVATAR
            Positioned(
              top: 20 - (4 * animationVal),
              left: ((width) / 2 - 80) * animationVal + 20,
              child: Hero(
                tag: 'avatar',
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 2, color: VecColor.primaryColor(context)),
                    shape: BoxShape.circle,
                    color: VecColor.resolveColor(
                      context,
                      VecColor.highlightColor,
                    ),
                  ),
                  width: 80,
                  height: 80,
                  child: ClipRRect(
                    child: _image == null
                        ? SvgPicture.asset(
                            VecImage.avatar,
                            color: VecColor.primaryColor(context),
                          )
                        : Image.memory(
                            _image!,
                            width: 78,
                            height: 78,
                            fit: BoxFit.cover,
                          ),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
            ),

            // STARS ROW
            Positioned(
              left: ((width) / 2 - 200) * animationVal + 114,
              top: 61 + 44 * animationVal,
              child: VecStarsRow(rating: state.rating),
            ),
            // USER NAME
            Positioned(
              top: 35 + 104 * animationVal,
              child: Container(
                alignment: Alignment(animationVal - 1, 0),
                transform: Matrix4.translationValues(
                  44 - 44 * animationVal,
                  0,
                  0,
                ),
                width: width - 144 + 84 * animationVal,
                child: Text(
                  state.user!.name,
                  maxLines: 1,
                  softWrap: false,
                  style: VecStyles.profileNameAndNumbersTextStyle(context),
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
            // JOINED TEXT
            Positioned(
              top: 166 * animationVal,
              child: Opacity(
                opacity: ((animationVal - 0.7) / (1 - 0.7)).clamp(0, 1),
                child: Text(
                  "Joined ${dateToString(state.user!.createdAt!)}",
                  style: VecStyles.joinedTextStyle(context),
                ),
              ),
            ),
            // RIDES TEXT
            Positioned(
              top: 195 * animationVal,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: ((animationVal - 0.6) / (1 - 0.6)).clamp(0, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Rides:",
                          style: VecStyles.profileRowTextStyle(context),
                        ),
                        Text(
                          state.ridesNumber.toString(),
                          style:
                              VecStyles.profileNameAndNumbersTextStyle(context),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Offers:",
                          style: VecStyles.profileRowTextStyle(context),
                        ),
                        Text(
                          state.offersNumber.toString(),
                          style:
                              VecStyles.profileNameAndNumbersTextStyle(context),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Ratings:",
                          style: VecStyles.profileRowTextStyle(context),
                        ),
                        Text(
                          state.reviews != null
                              ? state.reviews!.length.toString()
                              : "",
                          style:
                              VecStyles.profileNameAndNumbersTextStyle(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double scrollAnimationValue(double shrinkOffset) {
    final double maxScrollAllowed = maxExtent - minExtent;
    return ((maxScrollAllowed - shrinkOffset) / maxScrollAllowed)
        .clamp(0, 1)
        .toDouble();
  }

  @override
  double get maxExtent => _maxExtent;

  @override
  double get minExtent => _minExtent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
