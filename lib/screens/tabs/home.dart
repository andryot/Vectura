import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/global/global_bloc.dart';
import '../../bloc/home/home_bloc.dart';
import '../../bloc/tab_bar/tab_bar_bloc.dart';
import '../../router/routes.dart';
import '../../style/colors.dart';
import '../../style/images.dart';
import '../../style/styles.dart';
import '../../widgets/util/constants.dart';
import '../../widgets/util/vec_card.dart';
import '../../widgets/vec_button.dart';
import '../loading_indicator.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(globalBloc: GlobalBloc.instance),
      child: const _HomeTab(),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: VecColor.backgroud,
          middle: Text(
            "Home",
            style: VecStyles.pageTitleTextStyle(context),
          ),
          trailing: CupertinoButton(
            padding: const EdgeInsets.only(right: 4),
            child: const Text(
              "Offer a ride",
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(VecRoute.offerRide);
            },
          ),
        ),
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state.isSuccessful == false) {
              showCupertinoDialog(
                  context: context,
                  builder: (context2) {
                    return CupertinoAlertDialog(
                      // TODO handle errors based on value
                      title: const Text("Can't load data"),
                      actions: <Widget>[
                        CupertinoDialogAction(
                            isDefaultAction: true,
                            child: const Text("Retry"),
                            onPressed: () {
                              Navigator.of(context2).pop();
                              BlocProvider.of<HomeBloc>(context).reset();
                            })
                      ],
                    );
                  });
            }
          },
          builder: (context, state) {
            if (!state.initialized && state.isSuccessful == null) {
              return const Center(
                child: LoadingIndicator(
                  radius: 25.0,
                  dotRadius: 8.0,
                ),
              );
            } else if (state.isSuccessful == false) {
              return Container(
                  color: VecColor.resolveColor(context, VecColor.backgroud));
            }
            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    CupertinoSliverRefreshControl(
                      onRefresh: () async => await Future.wait(<Future>[
                        BlocProvider.of<HomeBloc>(context).refresh(),
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
                    // display text if user has no rides and no offers
                    if (state.offers!.isEmpty && state.rides!.isEmpty) ...[
                      SliverFillRemaining(
                        child: Center(
                          child: Text(
                            "You currently have no rides and no offers",
                            style: VecStyles.noOffersTextStyle(context),
                          ),
                        ),
                      ),
                    ] else ...[
                      SliverList(
                        delegate: SliverChildListDelegate([
                          const SizedBox(
                            height: 40,
                          ),
                          if (state.offers!.isNotEmpty) ...[
                            VecCard(
                              title: offersText,
                              icon: VecImage.history,
                              rides: state.offers!,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                          if (state.rides!.isNotEmpty) ...[
                            VecCard(
                              title: ridesText,
                              icon: VecImage.rides,
                              rides: state.rides!,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ]),
                      ),
                    ]
                  ],
                ),
                if (state.offers!.isEmpty && state.rides!.isEmpty) ...[
                  Positioned(
                    bottom: 0,
                    left: 18,
                    right: 18,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: VecTextShadowButton.filled(
                              text: "Offer a ride",
                              color: VecColor.backgroud,
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(VecRoute.offerRide);
                              },
                              textStyle: TextStyle(
                                color: CupertinoDynamicColor.resolve(
                                    VecColor.primary, context),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: VecTextShadowButton.filled(
                              text: "Search for rides",
                              color: VecColor.backgroud,
                              onPressed: () =>
                                  BlocProvider.of<TabBarBloc>(context)
                                      .switchSelectedTab(1),
                              textStyle: TextStyle(
                                color: CupertinoDynamicColor.resolve(
                                    VecColor.primary, context),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        const SizedBox(
                          height: 39,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ));
  }
}
