import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/global/global_bloc.dart';
import '../bloc/sign_in/sign_in_bloc.dart';
import '../router/routes.dart';
import '../services/auth_service.dart';
import '../services/keychain_service.dart';
import '../services/local_storage_service.dart';
import '../style/colors.dart';
import '../style/images.dart';
import '../style/styles.dart';
import '../util/failures/backend_failure.dart';
import '../util/failures/validation_failure.dart';
import '../widgets/vec_button.dart';
import '../widgets/vec_text_field.dart';
import 'loading_indicator.dart';
import 'registration.dart';

class SignInScreenArgs {
  final String email;
  final String password;

  const SignInScreenArgs({required this.email, required this.password});
}

class SignInScreen extends StatelessWidget {
  final SignInScreenArgs args;
  const SignInScreen({Key? key, required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignInBloc>(
      create: (context) => SignInBloc(
        globalBloc: GlobalBloc.instance,
        keychainService: KeychainService.instance,
        authService: AuthService.instance,
        localStorageService: LocalStorageService.instance,
      ),
      child: _SignInScreen(
        args: args,
      ),
    );
  }
}

class _SignInScreen extends StatelessWidget {
  final SignInScreenArgs args;
  const _SignInScreen({Key? key, required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignInBloc bloc = BlocProvider.of<SignInBloc>(context);
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    if (args.email.isNotEmpty) {
      emailController.text = args.email;
      bloc.emailChanged(args.email);
    }
    if (args.password.isNotEmpty) {
      passwordController.text = args.password;
      bloc.passwordChanged(args.password);
    }

    return BlocConsumer<SignInBloc, SignInState>(listener: (context, state) {
      if (state.signInSuccessful != null && state.signInSuccessful!) {
        Navigator.popAndPushNamed(context, VecRoute.root);
        return;
      }
    }, builder: (context, state) {
      final String? errorMessage;
      if (state.failure == null) {
        errorMessage = null;
      } else if (state.failure is EmailValidationFailure) {
        errorMessage = 'Please, enter a valid email';
      } else if (state.failure is PasswordValidationFailure) {
        errorMessage = 'Please, enter a valid password';
      } else if (state.failure is BadRequestBackendFailure) {
        errorMessage = 'No email/password';
      } else if (state.failure is NotFoundBackendFailure) {
        errorMessage = 'Wrong email/password combination';
      } else {
        errorMessage =
            'Something went wrong on our side. Please try again later.';
      }

      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: CupertinoPageScaffold(
          resizeToAvoidBottomInset: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Hero(
                      tag: 'logo',
                      child: SvgPicture.asset(
                        VecImage.logo,
                        color: VecColor.primaryColor(context),
                      ),
                    ),
                    const SizedBox(
                      height: 207,
                    ),
                    Hero(
                      tag: 'email',
                      child: VecTextField(
                        placeholder: 'Email',
                        onChanged: bloc.emailChanged,
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Hero(
                      tag: 'password',
                      child: VecTextField(
                        placeholder: 'Password',
                        onChanged: bloc.passwordChanged,
                        obscureText: true,
                        controller: passwordController,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    if (errorMessage != null) ...[
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: VecColor.primaryContrastingColor),
                      ),
                    ],
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: VecTextShadowButton.filled(
                        text: "Login",
                        color: VecColor.backgroud,
                        onPressed: bloc.state.isLoading ? null : bloc.signIn,
                        textStyle: VecStyles.buttonTextStyle(context),
                        child: bloc.state.isLoading
                            ? const LoadingIndicator(
                                radius: 12, dotRadius: 3.81)
                            : null,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: VecTextShadowButton.filled(
                        color: VecColor.backgroud,
                        text: "Create new user",
                        textStyle: VecStyles.buttonTextStyle(context),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            VecRoute.registration,
                            arguments: RegistrationScreenArgs(
                              email: state.email,
                              password: state.password,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
