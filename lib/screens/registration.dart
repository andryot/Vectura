import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/global/global_bloc.dart';
import '../bloc/register/register_bloc.dart';
import '../router/routes.dart';
import '../services/auth_service.dart';
import '../services/keychain_service.dart';
import '../style/colors.dart';
import '../style/images.dart';
import '../style/styles.dart';
import '../util/failures/backend_failure.dart';
import '../util/failures/validation_failure.dart';
import '../widgets/vec_button.dart';
import '../widgets/vec_text_field.dart';
import 'loading_indicator.dart';
import 'sign_in.dart';

class RegistrationScreenArgs {
  final String email;
  final String password;

  const RegistrationScreenArgs({required this.email, required this.password});
}

class RegistrationScreen extends StatelessWidget {
  final RegistrationScreenArgs args;
  const RegistrationScreen({Key? key, required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (context) => RegisterBloc(
        globalBloc: GlobalBloc.instance,
        keychainService: KeychainService.instance,
        authService: AuthService.instance,
      ),
      child: _RegisterScreen(
        args: args,
      ),
    );
  }
}

class _RegisterScreen extends StatelessWidget {
  final RegistrationScreenArgs args;
  const _RegisterScreen({Key? key, required this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RegisterBloc bloc = BlocProvider.of<RegisterBloc>(context);
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

    return BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
      if (state.isRegistrationSuccessful != null &&
          state.isRegistrationSuccessful!) {
        Navigator.pushNamed(context, VecRoute.root);
        return;
      }
    }, builder: (context, state) {
      final String? errorMessage;

      if (state.failure == null) {
        errorMessage = null;
      } else if (state.failure is EmailValidationFailure) {
        errorMessage = 'Please, enter a valid email';
      } else if (state.failure is ForbiddenBackendFailure) {
        errorMessage = 'Email already in use';
      } else if (state.failure is PasswordValidationFailure) {
        errorMessage = 'Please, enter a valid password';
      } else if (state.failure is PasswordRepeatValidationFailure) {
        errorMessage = 'Passwords don\'t match';
      } else if (state.failure is NameValidationFailure) {
        errorMessage = 'Please, enter a valid name';
      } else if (state.failure is PhoneValidationFailure) {
        errorMessage = 'Please, enter a valid phone number';
      } else if (state.failure is BadRequestBackendFailure) {
        errorMessage = 'No email/password';
      } else {
        errorMessage =
            'Something went wrong on our side. Please try again later.';
      }

      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            CupertinoPageScaffold(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Hero(
                      tag: 'logo',
                      child: SvgPicture.asset(
                        VecImage.logo,
                        color: VecColor.primaryColor(context),
                      ),
                    ),
                    const SizedBox(
                      height: 70,
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
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    VecTextField(
                      placeholder: 'Repeat password',
                      onChanged: bloc.passwordRepeatChanged,
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    VecTextField(
                      placeholder: 'Name',
                      onChanged: bloc.nameChanged,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      obscureText: false,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    VecTextField(
                      placeholder: 'Phone number',
                      onChanged: bloc.phoneChanged,
                      keyboardType: TextInputType.phone,
                      obscureText: false,
                      textInputAction: TextInputAction.done,
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
              ),
            ),
            Positioned(
              bottom: 24,
              left: 20,
              width: MediaQuery.of(context).size.width - 40,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: VecTextShadowButton.filled(
                      text: "Register",
                      textStyle: VecStyles.buttonTextStyle(context),
                      color: VecColor.backgroud,
                      onPressed: bloc.state.isLoading ? null : bloc.register,
                      child: bloc.state.isLoading
                          ? const LoadingIndicator(radius: 12, dotRadius: 3.81)
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
                      text: "Already a user",
                      textStyle: VecStyles.buttonTextStyle(context),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          VecRoute.signIn,
                          arguments: SignInScreenArgs(
                            email: state.email,
                            password: state.password,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
