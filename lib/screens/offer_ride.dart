import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/offer_ride/offer_ride_bloc.dart';
import '../router/routes.dart';
import '../services/backend_service.dart';
import '../style/colors.dart';
import '../style/images.dart';
import '../style/styles.dart';
import '../util/failures/backend_failure.dart';
import '../util/failures/failure.dart';
import '../util/failures/validation_failure.dart';
import '../util/functions/date_time_starting.dart';
import '../widgets/vec_label.dart';
import '../widgets/vec_text_field.dart';
import 'loading_indicator.dart';

class OfferRideScreen extends StatelessWidget {
  const OfferRideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            OfferRideBloc(backendService: BackendService.instance),
        child: const _OfferRideScreen());
  }
}

class _OfferRideScreen extends StatelessWidget {
  const _OfferRideScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OfferRideBloc bloc = BlocProvider.of<OfferRideBloc>(context);
    final DateTime tomorrow = DateTime.now().add(const Duration(days: 1));

    // Used for initially selected date in date picker
    DateTime initialDateTime =
        DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 12);

    final TextEditingController dateController = TextEditingController();

    return BlocConsumer<OfferRideBloc, OfferRideState>(
      listener: (context, state) async {
        if (state.dateTime != null) {
          dateController.text = dateTimeToString(state.dateTime!);
        }
        if (state.failure is ValidationFailure) {
          await showCupertinoDialog(
            barrierDismissible: true,
            context: context,
            builder: (context2) {
              return CupertinoAlertDialog(
                title: const Text("Error"),
                content: Text(getValidationMessage(state.failure!)),
              );
            },
          );
          bloc.resetValidation();
        } else if (state.failure is BackendFailure) {
          showCupertinoDialog(
              barrierDismissible: true,
              context: context,
              builder: (context2) {
                return CupertinoAlertDialog(
                  title: Text(getBackendFailureMessage(state.failure!)),
                  actions: <Widget>[
                    CupertinoDialogAction(
                        isDefaultAction: true,
                        child: const Text("Retry"),
                        onPressed: () {
                          Navigator.of(context2).pop();
                          bloc.retry();
                        })
                  ],
                );
              });
        } else if (state.createSuccessful == true && state.id != null) {
          // Pop and push successfuly created offer
          Navigator.of(context)
              .popAndPushNamed(VecRoute.offerDetails, arguments: state.id);
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                backgroundColor: VecColor.backgroud,
                leading: CupertinoButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: SvgPicture.asset(
                    VecImage.leftArrow,
                    color: CupertinoDynamicColor.resolve(
                        VecColor.primary, context),
                  ),
                ),
                middle: Text(
                  "Offer a ride",
                  style: VecStyles.pageTitleTextStyle(context),
                ),
                trailing: CupertinoButton(
                    child: const Text(
                      "Offer",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    onPressed: () async {
                      bloc.add(CreateOffer());
                    }),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: ListView(
                  children: [
                    // display loading indicator at the top
                    if (state.isLoading) ...[
                      const Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Center(
                          child: LoadingIndicator(
                            radius: 12.0,
                            dotRadius: 3.84,
                          ),
                        ),
                      )
                    ] else ...[
                      const SizedBox()
                    ],
                    const SizedBox(
                      height: 29,
                    ),
                    const VecLabel(text: "From:"),
                    VecTextField(
                      placeholder: "From",
                      onChanged: bloc.fromChanged,
                      keyboardType: TextInputType.streetAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const VecLabel(text: "To:"),
                    VecTextField(
                      placeholder: "To",
                      onChanged: bloc.toChanged,
                      keyboardType: TextInputType.streetAddress,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const VecLabel(text: "Starting at:"),

                    VecTextField(
                      controller: dateController,
                      placeholder: "Date",
                      readOnly: true,
                      onTap: () async {
                        DateTime? selectedDate;
                        if (Platform.isIOS) {
                          selectedDate =
                              await _selectDateIos(context, initialDateTime);
                        } else if (Platform.isAndroid) {
                          selectedDate = await _selectDateAndroid(
                              context, initialDateTime);
                        }
                        if (selectedDate != null) {
                          bloc.dateChanged(selectedDate);
                          dateController.text = dateTimeToString(selectedDate);
                          initialDateTime = selectedDate;
                        } else {
                          // this happens if user just dismisses the picker
                          bloc.dateChanged(initialDateTime);
                          dateController.text =
                              dateTimeToString(initialDateTime);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const VecLabel(text: "Available seats:"),
                    VecTextField(
                      placeholder: "Available seats",
                      onChanged: bloc.availableSeatsChanged,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const VecLabel(text: "Price:"),
                    VecTextField(
                      placeholder: "Price",
                      onChanged: bloc.priceChanged,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const VecLabel(text: "Additional info:"),
                    VecTextField(
                        placeholder: "Additional info",
                        onChanged: bloc.additionalInfoChanged),
                  ],
                ),
              )),
        );
      },
    );
  }

  Future<DateTime?> _selectDateAndroid(
      BuildContext context, DateTime initialDateTime) async {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: DateTime.now(),
      lastDate: initialDateTime.add(
        const Duration(days: 365),
      ),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: brightness == Brightness.dark
              ? ThemeData.dark()
              : ThemeData.light(),
          child: child ?? const Text(""),
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: brightness == Brightness.dark
                ? ThemeData.dark()
                : ThemeData.light(),
            child: child ?? const Text(""),
          );
        },
      );
      if (pickedTime != null) {
        return DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
            pickedTime.hour, pickedTime.minute);
      }
    }
    return null;
  }

  Future<DateTime?> _selectDateIos(
      BuildContext context, DateTime initialDateTime) async {
    DateTime? selectedDate;
    await showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              backgroundColor: VecColor.backgroud,
              minimumDate: DateTime.now(),
              initialDateTime: initialDateTime,
              maximumDate: initialDateTime.add(const Duration(days: 365)),
              mode: CupertinoDatePickerMode.dateAndTime,
              onDateTimeChanged: (date) {
                selectedDate = date;
              },
            ));
      },
    );
    return selectedDate;
  }
}

String getBackendFailureMessage(Failure failure) {
  if (failure is PreconditionFailedBackendFailure) {
    return "You don't have a vehicle added!";
  } else {
    return "Something went wrong. Please try again later.";
  }
}

String getValidationMessage(Failure failure) {
  if (failure is AddressValidationFailure) {
    return "Please enter valid address";
  } else if (failure is DateValidationFailure) {
    return "Please enter valid date";
  } else if (failure is IntegerParsingFailure) {
    return "Please enter valid number of available seats";
  } else if (failure is PriceValidationFailure) {
    return "Please enter a valid price";
  } else {
    return "Unknown error";
  }
}
