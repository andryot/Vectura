import '../../models/rides/ride.dart';

String goingFieldParser(VecturaRide ride) {
  int seatsLeft = ride.maxPassengers - ride.passengers.length;
  String returnString = "";

  if (ride.passengers.length == 1) {
    returnString = ride.passengers.first.email + " ";
  }

  return returnString +
      seatsLeft.toString() +
      " seat" +
      (seatsLeft != 1 ? "s" : "") +
      " left";
}
