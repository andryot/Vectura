import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/rides/ride.dart';
import '../../style/colors.dart';
import '../../style/styles.dart';
import '../../util/functions/date_time_starting.dart';
import '../../util/functions/going_field_parser.dart';
import '../vec_location_row.dart';

class VecHistoryCard extends StatelessWidget {
  final VecturaRide ride;
  final String icon;
  final bool isRide;
  const VecHistoryCard(
      {Key? key, required this.ride, required this.icon, required this.isRide})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SvgPicture svgIcon = SvgPicture.asset(
      icon,
      fit: BoxFit.scaleDown,
      width: 24,
      height: 24,
      color: VecColor.resolveColor(context, VecColor.primary),
    );
    return Padding(
      padding: isRide
          ? const EdgeInsets.only(left: 10, right: 85)
          : const EdgeInsets.only(left: 85, right: 10),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: VecColor.resolveColor(context, VecColor.highlightColor),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 13),
            child: Column(
              children: [
                SizedBox(
                  child: Row(children: [
                    svgIcon,
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      dateToString(ride.startAt),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: VecColor.resolveColor(context, VecColor.primary),
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  child: Column(children: [
                    VecLoactionRow(
                      from: ride.locFrom.title,
                      to: ride.locTo.title,
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Text("Going:",
                            style: VecStyles.cardStrongTextStyle(context)),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(goingFieldParser(ride),
                            style: VecStyles.cardNormalTextStyle(context)),
                      ],
                    )
                  ]),
                ),
              ],
            ),
          )),
    );
  }
}
