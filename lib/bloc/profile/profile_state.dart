part of 'profile_bloc.dart';

@immutable
class ProfileState {
  final bool isLoading;
  final bool initialized;
  final List<VecturaReview>? reviews;
  final VecturaUser? user;
  final Failure? failure;
  final int ridesNumber;
  final int offersNumber;
  final double rating;

  const ProfileState({
    required this.isLoading,
    required this.initialized,
    required this.reviews,
    required this.user,
    required this.failure,
    required this.ridesNumber,
    required this.offersNumber,
    required this.rating,
  });

  const ProfileState.initial()
      : isLoading = false,
        initialized = false,
        reviews = null,
        user = null,
        failure = null,
        ridesNumber = 0,
        offersNumber = 0,
        rating = 0.0;

  ProfileState copyWith({
    bool? isLoading,
    bool? initialized,
    List<VecturaReview>? reviews,
    VecturaUser? user,
    Failure? failure,
    int? ridesNumber,
    int? offersNumber,
    double? rating,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      initialized: initialized ?? this.initialized,
      reviews: reviews ?? this.reviews,
      user: user ?? this.user,
      failure: failure,
      ridesNumber: ridesNumber ?? this.ridesNumber,
      offersNumber: offersNumber ?? this.offersNumber,
      rating: rating ?? this.rating,
    );
  }
}
