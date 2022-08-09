import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../style/colors.dart';
import '../style/images.dart';
import '../style/styles.dart';
import 'vec_button.dart';

class VecPersonDetails extends StatelessWidget {
  final String email;
  final String phone;
  const VecPersonDetails({Key? key, required this.email, required this.phone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) => CupertinoActionSheet(
                title: const Text('Select way of contact'),
                actions: <CupertinoActionSheetAction>[
                  CupertinoActionSheetAction(
                    child: const Text('Send email'),
                    onPressed: () async {
                      if (await canLaunch("mailto:$email")) {
                        await launch("mailto:$email");
                      }
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: const Text('Call'),
                    onPressed: () async {
                      if (await canLaunch("tel:$phone")) {
                        await launch("tel:$phone");
                      }
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "email: " + email,
                style: VecStyles.cardStrongTextStyle(context),
              ),
              Text(
                "phone number: " + phone,
                style: VecStyles.cardStrongTextStyle(context),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15.75,
        ),
        VecButton(
            onPressed: () async {
              if (await canLaunch("tel:$phone")) {
                await launch("tel:$phone");
              }
              // TODO handle exception
            },
            child: SvgPicture.asset(
              VecImage.phone,
              color: VecColor.primaryColor(context),
            ))
      ],
    );
  }
}
