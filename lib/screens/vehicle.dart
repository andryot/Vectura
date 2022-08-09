import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/global/global_bloc.dart';
import '../bloc/vehicle/vehicle_bloc.dart';
import '../services/backend_service.dart';
import '../style/colors.dart';
import '../style/images.dart';
import '../style/styles.dart';
import '../util/failures/validation_failure.dart';
import '../widgets/vec_button.dart';
import '../widgets/vec_label.dart';
import '../widgets/vec_text_field.dart';
import 'loading_indicator.dart';

class VehicleScreen extends StatelessWidget {
  const VehicleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => VehicleBloc(
            backendService: BackendService.instance,
            globalBloc: GlobalBloc.instance),
        child: const _VehicleScreen());
  }
}

class _VehicleScreen extends StatelessWidget {
  const _VehicleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
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
            "Vehicle",
            style: VecStyles.pageTitleTextStyle(context),
          ),
        ),
        child: BlocConsumer<VehicleBloc, VehicleState>(
          listener: (context, state) async {
            if (state.failure != null) {
              String errorMessage = "An error occurred";
              if (state.failure is ValidationFailure) {
                if (state.failure is BrandValidationFailure) {
                  errorMessage = "Please enter a valid brand";
                } else if (state.failure is ModelValidationFailure) {
                  errorMessage = "Please enter a valid model";
                } else if (state.failure is ColorValidationFailure) {
                  errorMessage = "Please enter a valid color";
                } else if (state.failure is LicensePlateValidationFailure) {
                  errorMessage = "Please enter a valid license plate";
                }
              }

              await showCupertinoDialog(
                context: context,
                builder: (context2) {
                  return CupertinoAlertDialog(
                    title: const Text("Error"),
                    content: Text(errorMessage),
                    actions: [
                      CupertinoButton(
                        child: const Text("OK"),
                        onPressed: () {
                          BlocProvider.of<VehicleBloc>(context).resetFailure();
                          Navigator.of(context2).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            } else if (state.successful == true) {
              await showCupertinoDialog(
                context: context,
                builder: (context2) {
                  return CupertinoAlertDialog(
                    title: const Text("Success"),
                    content: Text(state.vehicle != null
                        ? "Your vehicle was successfully added"
                        : "Your vehicle was successfully removed"),
                    actions: [
                      CupertinoButton(
                        child: const Text("OK"),
                        onPressed: () {
                          Navigator.of(context2).pop();
                        },
                      ),
                    ],
                  );
                },
              );
              BlocProvider.of<VehicleBloc>(context).resetSuccess();
            }
          },
          builder: (context, state) {
            final VehicleBloc bloc = BlocProvider.of<VehicleBloc>(context);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VecLabel(text: "Brand:"),
                      VecTextField(
                        placeholder: "Brand",
                        controller: bloc.state.controllers[0],
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const VecLabel(text: "Model:"),
                      VecTextField(
                        placeholder: "Model",
                        controller: bloc.state.controllers[1],
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const VecLabel(text: "Color:"),
                      VecTextField(
                        placeholder: "Color",
                        controller: bloc.state.controllers[2],
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const VecLabel(text: "License plate:"),
                      VecTextField(
                        placeholder: "License plate",
                        controller: bloc.state.controllers[3],
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 29,
                  ),
                  const Spacer(),
                  if (state.vehicle != null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: VecTextShadowButton.filled(
                        color: VecColor.backgroud,
                        textStyle: VecStyles.buttonTextStyle(context),
                        onPressed: () {
                          bloc.updateVehicle();
                        },
                        text: "Update vehicle",
                        child: bloc.state.isLoading
                            ? const LoadingIndicator(
                                radius: 12, dotRadius: 3.81)
                            : null,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: VecTextShadowButton.filled(
                      color: VecColor.backgroud,
                      textStyle: VecStyles.buttonTextStyle(context),
                      onPressed: () {
                        if (state.vehicle == null) {
                          bloc.buttonClicked();
                          return;
                        }
                        showCupertinoDialog<void>(
                          context: context,
                          builder: (BuildContext context) =>
                              CupertinoAlertDialog(
                            title: const Text('Alert'),
                            content: const Text(
                                'Are you sure you want to delete the vehicle?'),
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
                      text: (state.vehicle == null)
                          ? "Add vehicle"
                          : "Remove vehicle",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
