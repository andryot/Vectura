part of 'vehicle_bloc.dart';

@immutable
class VehicleState {
  final bool isLoading;
  final VecturaVehicle? vehicle;
  final Failure? failure;
  final List<TextEditingController> controllers;
  final bool? successful;

  const VehicleState({
    required this.isLoading,
    this.vehicle,
    this.failure,
    this.successful,
    required this.controllers,
  });

  VehicleState.initial()
      : isLoading = false,
        vehicle = null,
        failure = null,
        successful = null,
        controllers = [
          TextEditingController(),
          TextEditingController(),
          TextEditingController(),
          TextEditingController(),
        ];

  VehicleState copyWith({
    bool? isLoading,
    VecturaVehicle? vehicle,
    Failure? failure,
    List<TextEditingController>? controllers,
    bool? override,
    bool? successful,
  }) {
    return VehicleState(
      isLoading: isLoading ?? this.isLoading,
      vehicle: (override == true) ? vehicle : vehicle ?? this.vehicle,
      failure: failure,
      controllers: controllers ?? this.controllers,
      successful: successful,
    );
  }
}
