import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/change_password/change_password_bloc.dart';
import '../services/auth_service.dart';
import '../style/colors.dart';
import '../style/images.dart';
import '../style/styles.dart';
import '../util/failures/backend_failure.dart';
import '../util/failures/validation_failure.dart';
import '../widgets/vec_label.dart';
import '../widgets/vec_text_field.dart';
import 'loading_indicator.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChangePasswordBloc(authService: AuthService.instance),
      child: const _ChangePasswordScreen(),
    );
  }
}

class _ChangePasswordScreen extends StatelessWidget {
  const _ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (previous, current) =>
          previous.isButtonEnabled != current.isButtonEnabled,
      builder: (context, state) {
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
                    color: CupertinoDynamicColor.resolve(
                        VecColor.primary, context),
                  ),
                ),
                middle: Text(
                  "Change password",
                  style: VecStyles.pageTitleTextStyle(context),
                ),
                trailing: _SaveButton(
                  isEnabled: state.isButtonEnabled,
                )),
            child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
              listener: (context, state) {
                if (state.failure != null) {
                  String errorMessage = "An error occurred";
                  if (state.failure is ValidationFailure) {
                    errorMessage = "Please enter valid password";
                  } else if (state.failure is BackendFailure) {
                    errorMessage =
                        "Something went wrong, please try again later";
                  }

                  showCupertinoDialog(
                    context: context,
                    builder: (context2) {
                      return CupertinoAlertDialog(
                        title: const Text("Error"),
                        content: Text(errorMessage),
                        actions: [
                          CupertinoButton(
                            child: const Text("OK"),
                            onPressed: () {
                              BlocProvider.of<ChangePasswordBloc>(context)
                                  .resetFailure();
                              Navigator.of(context2).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else if (state.isSuccess == true) {
                  showCupertinoDialog(
                    context: context,
                    builder: (context2) {
                      return CupertinoAlertDialog(
                        title: const Text("Success"),
                        content: const Text(
                            "Your password was successfully changed"),
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
                  BlocProvider.of<ChangePasswordBloc>(context).resetSuccess();
                }
              },
              builder: (context, state) {
                final ChangePasswordBloc bloc =
                    BlocProvider.of<ChangePasswordBloc>(context);
                if (state.isLoading == true) {
                  return const Center(
                    child: LoadingIndicator(
                      dotRadius: 3.84,
                      radius: 12,
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 29,
                      ),
                      const VecLabel(text: "New password:"),
                      VecTextField(
                        placeholder: "New password",
                        controller: bloc.controllers[0],
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const VecLabel(text: "Repeat new password:"),
                      VecTextField(
                        placeholder: "Repeat new password",
                        controller: bloc.controllers[1],
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _SaveButton extends StatelessWidget {
  final bool isEnabled;
  const _SaveButton({Key? key, required this.isEnabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        padding: const EdgeInsets.only(right: 4),
        child:
            const Text("Save", style: TextStyle(fontWeight: FontWeight.w700)),
        onPressed: isEnabled
            ? () => BlocProvider.of<ChangePasswordBloc>(context).save()
            : null);
  }
}
