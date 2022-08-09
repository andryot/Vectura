import 'package:flutter/cupertino.dart';

import '../../models/rides/ride.dart';
import '../../style/styles.dart';
import '../../util/functions/date_time_starting.dart';
import '../vec_location_row.dart';

class VecEntrySearch extends StatelessWidget {
  final VecturaRide ride;
  const VecEntrySearch({Key? key, required this.ride}) : super(key: key);

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
            Text("Offer by:", style: VecStyles.cardStrongTextStyle(context)),
            const SizedBox(
              width: 12,
            ),
            Text(ride.driver!.email.toString(),
                style: VecStyles.cardNormalTextStyle(context)),
          ],
        )
      ],
    );
  }
}
