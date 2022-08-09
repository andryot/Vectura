import 'package:flutter/cupertino.dart';

import '../../models/rides/ride.dart';
import '../../style/styles.dart';
import '../../util/functions/date_time_starting.dart';
import '../../util/functions/going_field_parser.dart';
import '../vec_location_row.dart';

class VecEntry extends StatelessWidget {
  final VecturaRide ride;
  const VecEntry({Key? key, required this.ride}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VecLoactionRow(
          from: ride.locFrom.title,
          to: ride.locTo.title,
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Text("Starting route:",
                style: VecStyles.cardStrongTextStyle(context)),
            const SizedBox(
              width: 12,
            ),
            Text(dateTimeStarting(ride.startAt),
                style: VecStyles.cardNormalTextStyle(context)),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Text("Going:", style: VecStyles.cardStrongTextStyle(context)),
            const SizedBox(
              width: 12,
            ),
            Text(goingFieldParser(ride),
                style: VecStyles.cardNormalTextStyle(context)),
          ],
        )
      ],
    );
  }
}
