import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/global/global_bloc.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../models/rides/review.dart';
import '../../router/routes.dart';
import '../../services/backend_service.dart';
import '../../services/keychain_service.dart';
import '../../style/colors.dart';
import '../../style/styles.dart';
import '../../util/failures/backend_failure.dart';
import '../../widgets/vec_button.dart';
import '../../widgets/vec_review_card.dart';
import '../../widgets/vec_sliver_app_bar.dart';
import '../loading_indicator.dart';
import '../sign_in.dart';

final GlobalBloc _globalBloc = GlobalBloc.instance;

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        backendService: BackendService.instance,
        globalBloc: _globalBloc,
      ),
      child: const _ProfileTab(),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileBloc bloc = BlocProvider.of<ProfileBloc>(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: VecColor.backgroud,
        middle: Text(
          "Profile",
          style: VecStyles.pageTitleTextStyle(context),
        ),
        trailing: CupertinoButton(
          padding: const EdgeInsets.only(right: 4),
          child: const Text(
            "Edit",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          onPressed: () => Navigator.pushNamed(context, VecRoute.userInfo),
        ),
      ),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: ((context, state) {
          if (state.failure is BackendFailure) {
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
                            bloc.reset();
                          })
                    ],
                  );
                });
          }
        }),
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: LoadingIndicator(
                dotRadius: 8,
                radius: 24,
              ),
            );
          }
          if (state.initialized == false || state.failure != null) {
            return const SizedBox();
          }
          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: VecSliverAppBar(
                      state: state,
                      maxExtent: 282,
                      minExtent: 120,
                      image: _globalBloc.state.profileImage,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      getReviewCards(state.reviews),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 24,
                left: 18,
                right: 18,
                child: VecTextShadowButton.filled(
                  color: VecColor.backgroud,
                  textStyle: VecStyles.buttonTextStyle(context),
                  text: "Log out",
                  onPressed: () async {
                    await KeychainService.instance.clearKeychain();
                    _globalBloc.reset();
                    Navigator.of(context, rootNavigator: true)
                        .pushReplacementNamed(
                      VecRoute.signIn,
                      arguments: const SignInScreenArgs(
                        email: '',
                        password: '',
                      ),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }

  List<Widget> getReviewCards(List<VecturaReview>? reviews) {
    if (reviews == null) return [];
    final List<Widget> reviewCards = [];
    for (VecturaReview review in reviews) {
      reviewCards.add(
        Padding(
          padding: const EdgeInsets.only(left: 48, right: 48, bottom: 12),
          child: VecReviewCard(
            review: review,
          ),
        ),
      );
    }
    return reviewCards;
  }
}
