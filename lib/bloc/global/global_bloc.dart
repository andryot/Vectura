import 'dart:async';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../models/rides/ride.dart';
import '../../models/rides/vehicle.dart';
import '../../models/user/user.dart';
import '../../util/logger.dart';

part 'global_state.dart';

class GlobalBloc {
  static GlobalBloc? _instance;
  static GlobalBloc get instance => _instance!;

  Stream<void> get globalRidesStream => _globalRides.stream;

  Stream<void> get globalOffersStream => _globalOffers.stream;

  Stream<void> get globalProfileImageStream => _globalProfileImage.stream;

  Stream<void> get globalUserStream => _globalUser.stream;

  final Logger _logger;

  GlobalState _state;
  GlobalState get state => _state;

  GlobalBloc._({required Logger logger})
      : _logger = logger,
        _state = const GlobalState.initial(),
        _globalRides = StreamController<void>.broadcast(),
        _globalOffers = StreamController<void>.broadcast(),
        _globalProfileImage = StreamController<void>.broadcast(),
        _globalUser = StreamController<void>.broadcast();

  factory GlobalBloc({required Logger logger}) {
    if (_instance != null) {
      throw StateError('GlobalBloc already created!');
    }

    _instance = GlobalBloc._(logger: logger);
    return _instance!;
  }

  final StreamController<void> _globalRides;
  final StreamController<void> _globalOffers;
  final StreamController<void> _globalProfileImage;
  final StreamController<void> _globalUser;

  void updateJwtToken(String jwtToken) {
    _state = _state.copyWith(jwtToken: jwtToken);
    _logger.info('GlobalBloc.updateJwtToken', 'jwt token updated');
  }

  void updateUser(VecturaUser user) {
    _state = _state.copyWith(user: user);
    _globalUser.add(null);
    _logger.info('GlobalBloc.updateUser', 'user updated');
  }

  void updateVehicle(VecturaVehicle? vehicle) {
    _state = _state.copyWith(
        user: state.user!.copyWith(vehicle: vehicle, override: true));
    _logger.info('GlobalBloc.updateVehicle', 'vehicle updated');
  }

  void reset() {
    _state = const GlobalState.initial();
    _logger.info('GlobalBloc.reset', 'state reset');
  }

  void updateUserRidesAndOffers(
      List<VecturaRide> rides, List<VecturaRide> offers) {
    _state = _state.copyWith(myRides: rides, myOffers: offers);
    _logger.info(
      'GlobalBloc.updateUserRidesAndOffers',
      'ridesAndOffers updated',
    );
  }

  void removeRide(String rideId) {
    if (_state.myRides == null) return;

    for (int i = 0; i < _state.myRides!.length; i++) {
      if (rideId == _state.myRides![i].id) {
        _state.myRides!.removeAt(i);
        break;
      }
    }
    _globalOffers.add(null);
    _logger.info('GlobalBloc.removeRide', 'Ride removed');
  }

  void removeOffer(String rideId) {
    if (_state.myOffers == null) return;

    for (int i = 0; i < _state.myOffers!.length; i++) {
      if (rideId == _state.myOffers![i].id) {
        _state.myOffers!.removeAt(i);
        break;
      }
    }
    _globalOffers.add(null);
    _logger.info('GlobalBloc.removeOffer', 'Offer removed');
  }

  void addOffer(VecturaRide offer) {
    if (_state.myOffers == null) {
      _state = _state.copyWith(myOffers: [offer]);
    } else {
      _state.myOffers!.add(offer);
    }

    _globalOffers.add(null);
    _logger.info('GlobalBloc.addOffer', 'offers updated');
  }

  void addRide(VecturaRide ride) {
    if (_state.myRides == null) {
      _state = _state.copyWith(myRides: [ride]);
    } else {
      _state.myRides!.add(ride);
    }

    _globalRides.add(null);
    _logger.info('GlobalBloc.addRide', 'rides updated');
  }

  void saveProfileImage(Uint8List? image) {
    if (image == null) return;
    _state = _state.copyWith(profileImage: image);
    _globalProfileImage.add(null);
    _logger.info('GlobalBloc.saveProfileImage', 'profile image saved');
  }
}
