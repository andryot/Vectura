import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../bloc/global/global_bloc.dart';
import '../../bloc/history/history_bloc.dart';
import '../../models/rides/ride.dart';
import '../../router/routes.dart';
import '../../services/backend_service.dart';
import '../../style/colors.dart';
import '../../style/images.dart';
import '../../style/styles.dart';
import '../../widgets/util/vec_history_card.dart';
import '../../widgets/vec_animated_text.dart';
import '../loading_indicator.dart';

const Duration animationDuration = Duration(milliseconds: 300);

class HistoryTab extends StatelessWidget {
  const HistoryTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // height of card and empty space (84 + 20)
    final int pageSize = (MediaQuery.of(context).size.height -
            WidgetsBinding.instance!.window.padding.top) ~/
        104;
    return BlocProvider<HistoryBloc>(
      create: (context) => HistoryBloc(
        backendService: BackendService.instance,
        pageSize: pageSize,
      ),
      child: _HistoryTab(
        globalBloc: GlobalBloc.instance,
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  final GlobalBloc _globalBloc;

  const _HistoryTab({
    Key? key,
    required GlobalBloc globalBloc,
  })  : _globalBloc = globalBloc,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final HistoryBloc bloc = BlocProvider.of<HistoryBloc>(context);
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: VecColor.backgroud,
          middle: Text(
            "History",
            style: VecStyles.pageTitleTextStyle(context),
          ),
          automaticallyImplyLeading: false,
        ),
        child: BlocConsumer<HistoryBloc, HistoryState>(
          listener: (context, state) {
            if (state.failure != null) {
              showCupertinoDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context2) {
                    return CupertinoAlertDialog(
                      title: const Text("Can't load data"),
                      actions: <Widget>[
                        CupertinoDialogAction(
                            isDefaultAction: true,
                            child: const Text("Retry"),
                            onPressed: () {
                              Navigator.of(context2).pop();
                              BlocProvider.of<HistoryBloc>(context).retry();
                            })
                      ],
                    );
                  });
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: _VecSegmentedControl(bloc: bloc),
                  ),
                ),
                Flexible(
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: bloc.scrollController,
                    slivers: [
                      CupertinoSliverRefreshControl(
                        onRefresh: () async =>
                            await BlocProvider.of<HistoryBloc>(context)
                                .refresh(state.selected),
                        builder: (context, mode, _, __, ___) {
                          return const LoadingIndicator(
                              radius: 12, dotRadius: 3.84);
                        },
                      ),
                      // display text if user has no rides and no offers
                      _VecSegmentedPage(
                        pagingController:
                            bloc.pagingControllers[state.selected],
                        globalBloc: _globalBloc,
                        historyState: state,
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ));
  }
}

class _VecSegmentedControl extends StatelessWidget {
  final HistoryBloc bloc;
  const _VecSegmentedControl({Key? key, required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HistoryState state = bloc.state;
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => bloc.selectSegment(0),
              child: VecAnimatedText(
                  text: "Rides",
                  beginColor: VecColor.resolveColor(context, VecColor.strong),
                  endColor: VecColor.resolveColor(context, VecColor.primary),
                  fontWeight: FontWeight.w500,
                  key: state.keys[0],
                  duration: animationDuration),
            ),
            const SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () => bloc.selectSegment(1),
              child: VecAnimatedText(
                  text: "My offers",
                  beginColor: VecColor.resolveColor(context, VecColor.strong),
                  endColor: VecColor.resolveColor(context, VecColor.strong),
                  key: state.keys[1],
                  duration: animationDuration),
            ),
            const SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () => bloc.selectSegment(2),
              child: VecAnimatedText(
                  text: "All",
                  beginColor: VecColor.resolveColor(context, VecColor.strong),
                  endColor: VecColor.resolveColor(context, VecColor.strong),
                  key: state.keys[2],
                  duration: animationDuration),
            ),
          ],
        ),
        SizedBox(
          height: 1,
          width: getWidthSum(state.sizeList),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: animationDuration,
                left: getPositionLeft(state.sizeList, state.selected),
                child: AnimatedContainer(
                  duration: animationDuration,
                  width: state.sizeList[state.selected].width,
                  color: VecColor.primaryColor(context),
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double getPositionLeft(List<Size> sizeList, int selected) {
    double left = 0;
    for (int i = 0; i < sizeList.length; i++) {
      if (i != selected) {
        left += (20 + sizeList[i].width);
      } else {
        break;
      }
    }
    return left;
  }

  double getWidthSum(List<Size> sizeList) {
    double sum = 0;
    for (Size size in sizeList) {
      sum += (20 + size.width);
    }
    return sum - 20;
  }
}

class _VecSegmentedPage extends StatelessWidget {
  final PagingController<int, VecturaRide> pagingController;
  final GlobalBloc _globalBloc;
  final HistoryState _historyState;
  const _VecSegmentedPage({
    Key? key,
    required this.pagingController,
    required GlobalBloc globalBloc,
    required HistoryState historyState,
  })  : _globalBloc = globalBloc,
        _historyState = historyState,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return PagedSliverList<int, VecturaRide>.separated(
      separatorBuilder: (context, index) => const SizedBox(
        height: 20,
      ),
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<VecturaRide>(
        firstPageErrorIndicatorBuilder: (context) {
          return const SizedBox();
        },
        noItemsFoundIndicatorBuilder: ((context) => Center(
            child: Text(_noItemsToShowText(_historyState),
                style: VecStyles.noOffersTextStyle(context)))),
        firstPageProgressIndicatorBuilder: (_) =>
            const LoadingIndicator(radius: 24, dotRadius: 8),
        itemBuilder: (context, item, index) => GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(VecRoute.offerDetails, arguments: item.id),
          child: VecHistoryCard(
            isRide: item.driver != _globalBloc.state.user!,
            icon: item.driver != _globalBloc.state.user!
                ? VecImage.rides
                : VecImage.history,
            ride: item,
          ),
        ),
        newPageProgressIndicatorBuilder: (_) =>
            const LoadingIndicator(radius: 12, dotRadius: 3.84),
      ),
    );
  }

  String _noItemsToShowText(HistoryState state) {
    return (state.selected == 0)
        ? "You currently have no rides history"
        : (state.selected == 1)
            ? "You currently have no offer history"
            : "You currently have no rides and no offers history";
  }
}
