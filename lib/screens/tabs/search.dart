import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../bloc/search/search_bloc.dart';
import '../../models/rides/ride.dart';
import '../../services/backend_service.dart';
import '../../style/colors.dart';
import '../../style/images.dart';
import '../../style/styles.dart';
import '../../util/functions/date_time_starting.dart';
import '../../widgets/util/vec_card.dart';
import '../loading_indicator.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(backendService: BackendService.instance),
      child: const _SearchTab(),
    );
  }
}

class _SearchTab extends StatelessWidget {
  const _SearchTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SearchBloc bloc = BlocProvider.of<SearchBloc>(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: VecColor.backgroud,
        middle: Text(
          "Search",
          style: VecStyles.pageTitleTextStyle(context),
        ),
      ),
      child: BlocConsumer<SearchBloc, SearchState>(
        listener: (context, state) {
          if (state.failure != null) {
            showCupertinoDialog(
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
                            BlocProvider.of<SearchBloc>(context).refresh();
                          })
                    ],
                  );
                });
          }
        },
        builder: (context, state) {
          if (!state.initialized) {
            return const Center(
              child: LoadingIndicator(
                radius: 25.0,
                dotRadius: 8.0,
              ),
            );
          }
          return CustomScrollView(slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async => await Future.wait(<Future>[
                BlocProvider.of<SearchBloc>(context).refresh(),
                Future.delayed(const Duration(seconds: 1))
              ]),
              builder: (BuildContext context, RefreshIndicatorMode mode,
                  double x, double y, double z) {
                return const Padding(
                  padding: EdgeInsets.only(top: 18.0),
                  child: LoadingIndicator(radius: 12, dotRadius: 3.84),
                );
              },
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 27),
              sliver: PagedSliverList<int, List<VecturaRide>>.separated(
                pagingController: bloc.pagingController,
                builderDelegate: PagedChildBuilderDelegate<List<VecturaRide>>(
                  itemBuilder: (context, item, index) => Column(
                    children: [
                      Text(
                        dateTimeStarting(item[0].startAt).split(' ')[0],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color:
                              VecColor.resolveColor(context, VecColor.primary),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      VecCard(
                        title: "",
                        icon: VecImage.rides,
                        rides: item,
                      ),
                    ],
                  ),
                  newPageProgressIndicatorBuilder: (_) =>
                      const LoadingIndicator(radius: 12, dotRadius: 3.84),
                  noItemsFoundIndicatorBuilder: ((context) => Center(
                        child: Column(
                          children: [
                            Text("No one is offering a ride at this moment.",
                                style: VecStyles.noOffersTextStyle(context)),
                            Text("Take initiative and you offer a ride.",
                                style: VecStyles.noOffersTextStyle(context)),
                          ],
                        ),
                      )),
                ),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 30,
                ),
              ),
            )
          ]);
        },
      ),
    );
  }
}
