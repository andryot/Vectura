import '../../models/rides/vehicle.dart';

String parseVehicleString(VecturaVehicle vehicle) {
  return vehicle.color +
      " " +
      vehicle.brand +
      " " +
      vehicle.model +
      " " +
      vehicle.licensePlate;
}
