import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../bloc/global/global_bloc.dart';
import '../bloc/offer_details/offer_details_bloc.dart';
import '../models/rides/passenger.dart';
import '../services/backend_service.dart';
import '../style/colors.dart';
import '../style/constants.dart';
import '../style/images.dart';
import '../style/styles.dart';
import '../util/failures/backend_failure.dart';
import '../util/failures/failure.dart';
import '../util/functions/date_time_starting.dart';
import '../util/functions/vehicle_string_parser.dart';
import '../widgets/vec_animated_divider.dart';
import '../widgets/vec_button.dart';
import '../widgets/vec_expanded_widget.dart';
import '../widgets/vec_label.dart';
import '../widgets/vec_list_tile.dart';
import '../widgets/vec_person_details.dart';
import 'loading_indicator.dart';

class OfferDetailsScreen extends StatelessWidget {
  final Object? rideId;
  const OfferDetailsScreen({Key? key, required this.rideId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (rideId == null) {
      return const CupertinoAlertDialog(
        title: Text("Generic error"),
      );
    }
    return BlocProvider<OfferDetailsBloc>(
      create: (context) => OfferDetailsBloc(
          rideId: rideId.toString(),
          backendService: BackendService.instance,
          globalBloc: GlobalBloc.instance),
      child: _OfferDetailsScreen(),
    );
  }
}

class _OfferDetailsScreen extends StatelessWidget {
  _OfferDetailsScreen({Key? key}) : super(key: key);

  final Completer<GoogleMapController> _controller = Completer();
  @override
  Widget build(BuildContext context) {
    final OfferDetailsBloc bloc = BlocProvider.of<OfferDetailsBloc>(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: VecColor.backgroud,
        leading: CupertinoButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: SvgPicture.asset(
            VecImage.leftArrow,
            color: CupertinoDynamicColor.resolve(VecColor.primary, context),
          ),
        ),
        middle: Text(
          "Ride details",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: CupertinoDynamicColor.resolve(VecColor.primary, context)),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: BlocConsumer<OfferDetailsBloc, OfferDetailsState>(
          listener: (context, state) {
            if (state.completed == true) {
              Navigator.of(context).pop();
            } else if (state.failure != null) {
              showCupertinoDialog(
                  context: context,
                  builder: (context2) => CupertinoAlertDialog(
                        title: const Text("Error"),
                        content: Text(getBackendFailureMessage(state.failure)),
                        actions: <Widget>[
                          CupertinoDialogAction(
                              isDestructiveAction: true,
                              isDefaultAction: true,
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.of(context2).pop();
                              }),
                        ],
                      ));
            }
          },
          builder: (context, state) {
            if (state.isLoading == true || state.isLoading == null) {
              return const Center(
                  child: LoadingIndicator(radius: 24, dotRadius: 8));
            }
            return Stack(children: [
              ListView(children: [
                const SizedBox(
                  height: 60,
                ),
                VecListTile(
                    onTap: () => bloc.clicked(0),
                    expanded: state.isExpandedList[0],
                    title: "Route",
                    image: VecImage.rightArrow),
                VecExpandedSection(
                    expand: state.isExpandedList[0],
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      width: double.infinity,
                      color: VecColor.resolveColor(context, VecColor.backgroud),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const VecLabel(
                              text: "From:",
                              padding: EdgeInsets.only(bottom: 2),
                            ),
                            Text(
                              state.ride!.locFrom.title,
                              style: VecStyles.cardStrongTextStyle(context),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const VecLabel(
                              text: "To:",
                              padding: EdgeInsets.only(bottom: 2),
                            ),
                            Text(
                              state.ride!.locTo.title,
                              style: VecStyles.cardStrongTextStyle(context),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // TODO implement google maps based on actual values
                            SizedBox(
                              height: 137,
                              child: GoogleMap(
                                gestureRecognizers: {
                                  Factory<OneSequenceGestureRecognizer>(
                                    () => EagerGestureRecognizer(),
                                  ),
                                },
                                mapType: MapType.normal,
                                initialCameraPosition: const CameraPosition(
                                  // Dunajska 22
                                  target: LatLng(
                                      46.06217597874376, 14.50911562772126),
                                  zoom: 10.4746,
                                ),
                                markers: <Marker>{
                                  const Marker(
                                      markerId: MarkerId("id-1"),
                                      position: LatLng(
                                          46.08217597874376, 14.50911562772126),
                                      infoWindow:
                                          InfoWindow(title: "Starting point")),
                                  const Marker(
                                      markerId: MarkerId("id-2"),
                                      position: LatLng(
                                          46.02217597874376, 14.50911562772126),
                                      infoWindow:
                                          InfoWindow(title: "Ending point")),
                                },
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                              ),
                            ),
                          ]),
                    )),
                VecAnimatedDivider(faded: state.isExpandedList[0]),
                VecListTile(
                    onTap: () => bloc.clicked(1),
                    expanded: state.isExpandedList[1],
                    title: "Travel information",
                    image: VecImage.rightArrow),
                VecExpandedSection(
                    expand: state.isExpandedList[1],
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      width: double.infinity,
                      color: VecColor.resolveColor(context, VecColor.backgroud),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const VecLabel(
                              text: "Start at:",
                              padding: EdgeInsets.only(bottom: 2),
                            ),
                            Text(
                              dateTimeToString(state.ride!.startAt),
                              style: VecStyles.cardStrongTextStyle(context),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const VecLabel(
                              text: "Price:",
                              padding: EdgeInsets.only(bottom: 2),
                            ),
                            Text(
                              state.ride!.price,
                              style: VecStyles.cardStrongTextStyle(context),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const VecLabel(
                              text: "Number of seats:",
                              padding: EdgeInsets.only(bottom: 2),
                            ),
                            Text(
                              state.ride!.maxPassengers.toString(),
                              style: VecStyles.cardStrongTextStyle(context),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (state.ride!.note != null) ...[
                              const VecLabel(
                                text: "Notes:",
                                padding: EdgeInsets.only(bottom: 2),
                              ),
                              Text(
                                state.ride!.note!,
                                style: VecStyles.cardStrongTextStyle(context),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ]),
                    )),
                VecAnimatedDivider(faded: state.isExpandedList[1]),
                VecListTile(
                    onTap: () => bloc.clicked(2),
                    title: "Ride information",
                    expanded: state.isExpandedList[2],
                    image: VecImage.rightArrow),
                VecExpandedSection(
                    expand: state.isExpandedList[2],
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      width: double.infinity,
                      color: VecColor.resolveColor(context, VecColor.backgroud),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const VecLabel(
                              text: "Seats taken:",
                              padding: EdgeInsets.only(bottom: 2),
                            ),
                            Text(
                              state.ride!.passengers.length.toString() +
                                  "/" +
                                  state.ride!.maxPassengers.toString(),
                              style: VecStyles.cardStrongTextStyle(context),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const VecLabel(
                              text: "Vehicle:",
                              padding: EdgeInsets.only(bottom: 2),
                            ),
                            Text(
                              parseVehicleString(state.ride!.driver!.vehicle!),
                              style: VecStyles.cardStrongTextStyle(context),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const VecLabel(
                              text: "Number of seats:",
                              padding: EdgeInsets.only(bottom: 2),
                            ),
                            Text(
                              state.ride!.maxPassengers.toString(),
                              style: VecStyles.cardStrongTextStyle(context),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const VecLabel(
                              text: "Driver info:",
                              padding: EdgeInsets.only(bottom: 2),
                            ),
                            VecPersonDetails(
                                email: state.ride!.driver!.email,
                                phone: state.ride!.driver!.phone),
                            const SizedBox(
                              height: 10,
                            ),
                            if (state.viewingAs ==
                                    OfferDetailsViewingAs.driver &&
                                state.ride!.passengers.isNotEmpty) ...[
                              const VecLabel(
                                text: "Passengers:",
                                padding: EdgeInsets.only(bottom: 6),
                              ),
                              for (VecturaPassenger passenger
                                  in state.ride!.passengers) ...[
                                VecPersonDetails(
                                  email: passenger.email,
                                  phone: passenger.phone,
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                              ]
                            ]
                          ]),
                    )),
                const SizedBox(
                  height: buttonHeight,
                )
              ]),
              Positioned(
                bottom: 10,
                left: 18,
                right: 18,
                child: VecTextShadowButton.filled(
                  color: VecColor.backgroud,
                  textStyle: VecStyles.buttonTextStyle(context),
                  onPressed: () {
                    showCupertinoDialog<void>(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                        title: const Text('Alert'),
                        content: Text(getDialogMessage(state.viewingAs)),
                        actions: <CupertinoDialogAction>[
                          CupertinoDialogAction(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoDialogAction(
                            child: const Text('Yes'),
                            isDestructiveAction: true,
                            onPressed: () {
                              bloc.buttonClicked();
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    );
                  },
                  text: (state.viewingAs == OfferDetailsViewingAs.viewer)
                      ? "Join this ride"
                      : "Cancel this ride",
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }

  String getDialogMessage(OfferDetailsViewingAs? viewingAs) {
    if (viewingAs == OfferDetailsViewingAs.viewer) {
      return "Are you sure you want to join this ride?";
    } else if (viewingAs == OfferDetailsViewingAs.driver) {
      return "Are you sure you want to cancel this ride?";
    } else {
      return "Are you sure you want to unjoin this ride?";
    }
  }

  String getBackendFailureMessage(Failure? failure) {
    if (failure is UnknownBackendFailure) {
      return "An unknown error occurred.";
    } else if (failure is PreconditionFailedBackendFailure) {
      return "The ride is already full.";
    } else {
      return "An error occurred. Please try again.";
    }
  }
}
