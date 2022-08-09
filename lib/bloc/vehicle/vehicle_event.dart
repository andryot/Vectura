part of 'vehicle_bloc.dart';

@immutable
abstract class VehicleEvent {}

class _Initialize extends VehicleEvent {}

class _AddVehicle extends VehicleEvent {}

class _RemoveVehicle extends VehicleEvent {}

class _UpdateVehicle extends VehicleEvent {}

class _ButtonPressed extends VehicleEvent {}

class _ResetFailure extends VehicleEvent {}

class _ResetSuccess extends VehicleEvent {}
