import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/rides/ride.dart';
import '../../router/routes.dart';
import '../../style/colors.dart';
import '../../style/constants.dart';
import '../vec_divider.dart';
import 'vec_entry.dart';
import 'vec_entry_search.dart';

class VecCard extends StatelessWidget {
  final String title;
  final String icon;
  final List<VecturaRide> rides;
  const VecCard(
      {Key? key, required this.title, required this.icon, required this.rides})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              decoration: BoxDecoration(
                color: VecColor.resolveColor(context, VecColor.highlightColor),
                borderRadius: cardBorderRadius,
                boxShadow: const [cardBoxShadow],
              ),
              width: double.infinity,

              // L I S T   O F   O F F E R S
              child: Padding(
                padding: EdgeInsets.only(
                    left: 40.0,
                    right: 20.0,
                    top: (title.isNotEmpty ? 29.2 : 20.0),
                    bottom: (title.isNotEmpty ? 10.0 : 20.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => Navigator.of(context).pushNamed(
                          VecRoute.offerDetails,
                          arguments: rides.first.id),
                      child: title.isNotEmpty
                          ? VecEntry(ride: rides.first)
                          : VecEntrySearch(ride: rides.first),
                    ),
                    // Moment of silence for .enumerate() :/
                    for (int i = 1; i < rides.length; i++)
                      Column(
                        children: [
                          const VecDivider(),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => Navigator.of(context).pushNamed(
                                VecRoute.offerDetails,
                                arguments: rides[i].id),
                            child: title.isNotEmpty
                                ? VecEntry(ride: rides[i])
                                : VecEntrySearch(ride: rides[i]),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          // E L I P S E
          if (title.isNotEmpty) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color:
                      VecColor.resolveColor(context, VecColor.highlightColor),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Container(
                height: 34.81,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: cardBorderRadius,
                ),
                child: Stack(children: [
                  Positioned(
                    left: 8,
                    top: 2,
                    bottom: 8.81,
                    width: 24,
                    child: SvgPicture.asset(
                      icon,
                      fit: BoxFit.scaleDown,
                      color: VecColor.resolveColor(context, VecColor.primary),
                    ),
                  ),
                  Positioned(
                    top: 7.0,
                    bottom: 13.81,
                    left: 41,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: VecColor.resolveColor(context, VecColor.primary),
                      ),
                    ),
                  )
                ]),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
