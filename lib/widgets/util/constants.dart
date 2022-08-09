import 'package:flutter/cupertino.dart';

import '../../screens/tabs/history.dart';
import '../../screens/tabs/home.dart';
import '../../screens/tabs/profile.dart';
import '../../screens/tabs/search.dart';

List<Widget> pageList = const [
  HomeTab(),
  SearchTab(),
  HistoryTab(),
  ProfileTab()
];

final List<GlobalKey<NavigatorState>> keys = [
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>()
];

const String offersText = "My offers:";
const String ridesText = "My rides:";
