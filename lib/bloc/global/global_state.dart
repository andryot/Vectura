part of 'global_bloc.dart';

@immutable
class GlobalState {
  final String? jwtToken;
  final VecturaUser? user;
  final List<VecturaRide>? myRides;
  final List<VecturaRide>? myOffers;
  final Uint8List? profileImage;

  const GlobalState({
    required this.jwtToken,
    required this.user,
    required this.myRides,
    required this.myOffers,
    required this.profileImage,
  });

  const GlobalState.initial()
      : user = null,
        jwtToken = null,
        myOffers = null,
        myRides = null,
        profileImage = null;

  GlobalState copyWith({
    String? jwtToken,
    VecturaUser? user,
    List<VecturaRide>? myRides,
    List<VecturaRide>? myOffers,
    Uint8List? profileImage,
  }) {
    return GlobalState(
      jwtToken: jwtToken ?? this.jwtToken,
      user: user ?? this.user,
      myRides: myRides ?? this.myRides,
      myOffers: myOffers ?? this.myOffers,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
