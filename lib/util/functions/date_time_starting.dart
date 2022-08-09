import 'dart:io';

import 'package:intl/intl.dart';

String dateTimeStarting(DateTime dateTime) {
  DateTime today = DateTime.now();
  String dayMonth = 'd.M';
  if (Platform.localeName == 'en_US') {
    dayMonth = 'M.d';
  }
  if (dateTime.year != today.year) {
    return DateFormat('$dayMonth.yyyy').format(dateTime) +
        " at " +
        DateFormat('h:mm a').format(dateTime);
  }

  int dayDiff = DateTime(dateTime.year, dateTime.month, dateTime.day)
      .difference(DateTime(today.year, today.month, today.day))
      .inDays;
  if (dayDiff == 0) {
    return "Today at " + DateFormat('h:mm a').format(dateTime);
  } else if (dayDiff == 1) {
    return "Tommorow at " + DateFormat('h:mm a').format(dateTime);
  }
  return DateFormat(dayMonth).format(dateTime) +
      " at " +
      DateFormat('h:mm a').format(dateTime);
}

String dateTimeToString(DateTime dateTime) {
  String dayMonth = 'd.M';
  if (Platform.localeName == 'en_US') {
    dayMonth = 'M.d';
  }
  return DateFormat('$dayMonth.yyyy').format(dateTime) +
      " at " +
      DateFormat('h:mm a').format(dateTime);
}

String dateToString(DateTime dateTime) {
  String dayMonth = 'd.M';
  if (Platform.localeName == 'en_US') {
    dayMonth = 'M.d';
  }
  return DateFormat('$dayMonth.yyyy').format(dateTime);
}
