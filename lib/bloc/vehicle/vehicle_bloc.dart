import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

import '../../models/rides/vehicle.dart';
import '../../services/backend_service.dart';
import '../../util/either.dart';
import '../../util/failures/backend_failure.dart';
import '../../util/failures/failure.dart';
import '../../util/failures/validation_failure.dart';
import '../../util/validator.dart';
import '../global/global_bloc.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final BackendService _backendService;
  final GlobalBloc _globalBloc;
  VehicleBloc({
    required BackendService backendService,
    required GlobalBloc globalBloc,
  })  : _backendService = backendService,
        _globalBloc = globalBloc,
        super(VehicleState.initial()) {
    on<_Initialize>(onInitialize);
    on<_AddVehicle>(onAddVehicle);
    on<_RemoveVehicle>(onRemoveVehicle);
    on<_UpdateVehicle>(onUpdateVehicle);
    on<_ButtonPressed>(onButtonPressed);
    on<_ResetFailure>(onResetFailure);
    on<_ResetSuccess>(onResetSuccess);

    add(_Initialize());
  }

  // public API
  void updateVehicle() => add(_UpdateVehicle());
  void buttonClicked() => add(_ButtonPressed());
  void resetFailure() => add(_ResetFailure());
  void resetSuccess() => add(_ResetSuccess());

  // HANDLERS

  FutureOr<void> onInitialize(
    _Initialize event,
    Emitter<VehicleState> emit,
  ) {
    final VecturaVehicle? vehicle = GlobalBloc.instance.state.user?.vehicle;

    if (vehicle != null) {
      emit(state.copyWith(vehicle: GlobalBloc.instance.state.user!.vehicle!));
      state.controllers[0].text = vehicle.brand;
      state.controllers[1].text = vehicle.model;
      state.controllers[2].text = vehicle.color;
      state.controllers[3].text = vehicle.licensePlate;
    }
  }

  Future<FutureOr<void>> onAddVehicle(
    _AddVehicle event,
    Emitter<VehicleState> emit,
  ) async {
    if (!VecValidator.isValidText(state.controllers[0].text)) {
      emit(state.copyWith(failure: const BrandValidationFailure()));
      return null;
    }

    if (!VecValidator.isValidText(state.controllers[1].text)) {
      emit(state.copyWith(failure: const ModelValidationFailure()));
      return null;
    }

    if (!VecValidator.isValidText(state.controllers[2].text)) {
      emit(state.copyWith(failure: const ColorValidationFailure()));
      return null;
    }

    if (!VecValidator.isValidText(state.controllers[3].text)) {
      emit(state.copyWith(failure: const LicensePlateValidationFailure()));
      return null;
    }

    emit(state.copyWith(isLoading: true));
    final VecturaVehicle vehicle = VecturaVehicle(
      id: null,
      brand: state.controllers[0].text,
      model: state.controllers[1].text,
      color: state.controllers[2].text,
      licensePlate: state.controllers[3].text,
    );

    final Either<BackendFailure, void> voidOrFailure =
        await _backendService.addVehicle(vehicle);

    if (voidOrFailure.isError()) {
      emit(state.copyWith(
        failure: voidOrFailure.error,
        isLoading: false,
      ));
      return null;
    }

    emit(state.copyWith(
      vehicle: vehicle,
      isLoading: false,
      successful: true,
    ));
    _globalBloc.updateVehicle(vehicle);
  }

  FutureOr<void> onRemoveVehicle(
    _RemoveVehicle event,
    Emitter<VehicleState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final Either<BackendFailure, void> voidOrFailure =
        await _backendService.removeVehicle();

    if (voidOrFailure.isError()) {
      emit(state.copyWith(failure: voidOrFailure.error, isLoading: false));
      return null;
    }

    for (TextEditingController controller in state.controllers) {
      controller.text = "";
    }
    emit(state.copyWith(
      vehicle: null,
      isLoading: false,
      override: true,
      successful: true,
    ));
    _globalBloc.updateVehicle(null);
  }

  FutureOr<void> onUpdateVehicle(
    _UpdateVehicle event,
    Emitter<VehicleState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final VecturaVehicle vehicle = VecturaVehicle(
        id: GlobalBloc.instance.state.user!.vehicle!.id,
        brand: state.controllers[0].text,
        model: state.controllers[1].text,
        color: state.controllers[2].text,
        licensePlate: state.controllers[3].text);

    final Either<BackendFailure, void> voidOrFailure =
        await _backendService.updateVehicle(vehicle);

    if (voidOrFailure.isError()) {
      emit(state.copyWith(failure: voidOrFailure.error, isLoading: false));
      return null;
    }

    _globalBloc.updateVehicle(vehicle);
    emit(state.copyWith(vehicle: vehicle, isLoading: false));
  }

  FutureOr<void> onButtonPressed(
    _ButtonPressed event,
    Emitter<VehicleState> emit,
  ) async {
    if (state.vehicle == null) {
      add(_AddVehicle());
    } else {
      add(_RemoveVehicle());
    }
  }

  FutureOr<void> onResetFailure(
    _ResetFailure event,
    Emitter<VehicleState> emit,
  ) {
    emit(state.copyWith(failure: null));
  }

  FutureOr<void> onResetSuccess(
      _ResetSuccess event, Emitter<VehicleState> emit) {
    emit(state.copyWith(successful: null));
  }
}
