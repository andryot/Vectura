import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/rides/review.dart';
import '../../models/user/user.dart';
import '../../services/backend_service.dart';
import '../../util/either.dart';
import '../../util/failures/backend_failure.dart';
import '../../util/failures/failure.dart';
import '../global/global_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final BackendService _backendService;
  final GlobalBloc _globalBloc;
  late final StreamSubscription _profileImageSubscription;
  late final StreamSubscription _userSubscription;

  ProfileBloc({
    required BackendService backendService,
    required GlobalBloc globalBloc,
  })  : _backendService = backendService,
        _globalBloc = globalBloc,
        super(const ProfileState.initial()) {
    on<_Initialize>(_onInitialize);
    on<_ReloadProfileImage>(_onReloadProfileImage);
    on<_ReloadUser>(_onReloadUser);
    on<_Reset>(_onReset);

    _profileImageSubscription = _globalBloc.globalProfileImageStream
        .listen((_) => add(const _ReloadProfileImage()));

    _userSubscription =
        _globalBloc.globalUserStream.listen((_) => add(const _ReloadUser()));

    add(const _Initialize());
  }

  @override
  Future<void> close() async {
    await _profileImageSubscription.cancel();
    await _userSubscription.cancel();
    return super.close();
  }

  // PUBLIC API
  void reset() async => add(_Reset());

  // HANDLERS

  FutureOr<void> _onInitialize(
    _Initialize event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final Either<BackendFailure, List<VecturaReview>> reviewsOrFailure =
        await _backendService.getReviewsForUser(_globalBloc.state.user!.id);

    if (reviewsOrFailure.isError()) {
      emit(
        state.copyWith(
          isLoading: false,
          failure: reviewsOrFailure.error,
          initialized: true,
        ),
      );
      return;
    }

    int ratingSum = 0;
    for (VecturaReview review in reviewsOrFailure.value) {
      ratingSum += review.stars;
    }

    final double avgRating = reviewsOrFailure.value.isEmpty
        ? 0
        : ratingSum / reviewsOrFailure.value.length;

    emit(
      state.copyWith(
        isLoading: false,
        reviews: reviewsOrFailure.value,
        initialized: true,
        user: _globalBloc.state.user,
        ridesNumber: _globalBloc.state.myRides!.length,
        offersNumber: _globalBloc.state.myOffers!.length,
        rating: avgRating,
      ),
    );
  }

  FutureOr<void> _onReloadProfileImage(
    _ReloadProfileImage event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith());
  }

  FutureOr<void> _onReloadUser(
    _ReloadUser event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(user: _globalBloc.state.user));
  }

  FutureOr<void> _onReset(
    _Reset event,
    Emitter<ProfileState> emit,
  ) {
    emit(const ProfileState.initial());
    add(const _Initialize());
  }
}
