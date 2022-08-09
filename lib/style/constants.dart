import 'package:flutter/cupertino.dart';

import 'colors.dart';

const BorderRadius kBorderRadius = BorderRadius.all(Radius.circular(12.0));
const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(20.0));
const double buttonHeight = 54.0;
const double textFieldHeight = 54.0;

const BoxShadow buttonBoxShadow = BoxShadow(
  color: Color.fromRGBO(0, 0, 0, 0.25),
  blurRadius: 4,
  spreadRadius: 0,
  offset: Offset(0, 4),
);

const BoxShadow cardBoxShadow = BoxShadow(
  color: Color.fromRGBO(0, 0, 0, 0.25),
  blurRadius: 4,
  spreadRadius: 0,
  offset: Offset(1, 2),
);

const TextStyle buttonTextStyle = TextStyle(
  color: VecColor.primary,
  fontSize: 18,
  fontWeight: FontWeight.w600,
);
