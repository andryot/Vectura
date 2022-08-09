import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../router/routes.dart';
import '../../widgets/util/constants.dart';

part 'tab_bar_event.dart';
part 'tab_bar_state.dart';

class TabBarBloc extends Bloc<_TabBarEvent, TabBarState>
    with WidgetsBindingObserver {
  late final CupertinoTabController controller;
  TabBarBloc() : super(const TabBarState(0)) {
    time = DateTime.now();
    WidgetsBinding.instance!.addObserver(this);

    controller = CupertinoTabController(
      initialIndex: 0,
    );

    on<_TabBarUpdateEvent>(_onTabBarUpdateEvent);

    on<_ResumedEvent>(_onResumed);
  }

  late DateTime time;

  FutureOr<void> _onResumed(
    _ResumedEvent event,
    Emitter<TabBarState> emit,
  ) async {
    // reload home tab if 15 minutes has passed since last reload and if home tab is currently selected
    if (state.index == 0 && homeTabNeedsRefresh()) {
      time = DateTime.now();
      add(_TabBarUpdateEvent(0));
      Navigator.popUntil(
          keys[0].currentContext!, ModalRoute.withName(VecRoute.root));

      Navigator.pushNamed(keys[0].currentContext!, VecRoute.tabNames[0]);
    }
  }

  FutureOr<void> _onTabBarUpdateEvent(
      _TabBarUpdateEvent event, Emitter<TabBarState> emit) {
    emit(TabBarState(event.index));
  }

  // reload if 15 minutes have passed since last reload
  bool homeTabNeedsRefresh() {
    return DateTime.now().millisecondsSinceEpoch - time.millisecondsSinceEpoch >
        900000;
  }

  void checkIndex(int index) {
    if (state.index == index || (index == 0 && homeTabNeedsRefresh())) {
      Navigator.popUntil(
          keys[index].currentContext!, ModalRoute.withName(VecRoute.root));

      Navigator.pushNamed(
          keys[index].currentContext!, VecRoute.tabNames[index]);
    } else {
      add(_TabBarUpdateEvent(index));
    }
  }

  void switchSelectedTab(int index) {
    add(_TabBarUpdateEvent(index));
    controller.index = index;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      add(_ResumedEvent());
    }
  }
}
