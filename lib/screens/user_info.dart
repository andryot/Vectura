import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/global/global_bloc.dart';
import '../bloc/user_info/user_info_bloc.dart';
import '../router/routes.dart';
import '../services/auth_service.dart';
import '../services/image_picker_service.dart';
import '../services/local_storage_service.dart';
import '../style/colors.dart';
import '../style/images.dart';
import '../style/styles.dart';
import '../util/failures/validation_failure.dart';
import '../widgets/vec_button.dart';
import '../widgets/vec_label.dart';
import '../widgets/vec_text_field.dart';
import 'loading_indicator.dart';

class UserInfoScreen extends StatelessWidget {
  final ImagePickerService _imagePickerService;
  final LocalStorageService _localStorageService;
  final GlobalBloc _globalBloc;
  const UserInfoScreen({
    Key? key,
    required ImagePickerService imagePickerService,
    required LocalStorageService localStorageService,
    required GlobalBloc globalBloc,
  })  : _imagePickerService = imagePickerService,
        _localStorageService = localStorageService,
        _globalBloc = globalBloc,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserInfoBloc(
        globalBloc: GlobalBloc.instance,
        authService: AuthService.instance,
      ),
      child: _UserInfoScreen(
        imagePickerService: _imagePickerService,
        localStorageService: _localStorageService,
        globalBloc: _globalBloc,
      ),
    );
  }
}

class _UserInfoScreen extends StatelessWidget {
  final ImagePickerService _imagePickerService;
  final LocalStorageService _localStorageService;
  final GlobalBloc _globalBloc;

  const _UserInfoScreen({
    Key? key,
    required ImagePickerService imagePickerService,
    required LocalStorageService localStorageService,
    required GlobalBloc globalBloc,
  })  : _imagePickerService = imagePickerService,
        _localStorageService = localStorageService,
        _globalBloc = globalBloc,
        super(key: key);

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
            "User info",
            style: VecStyles.pageTitleTextStyle(context),
          ),
        ),
        child: BlocConsumer<UserInfoBloc, UserInfoState>(
          listener: (context, state) async {
            if (state.failure != null) {
              String errorMessage = "An error occurred";
              if (state.failure is ValidationFailure) {
                if (state.failure is EmailValidationFailure) {
                  errorMessage = "Please enter a valid email";
                } else if (state.failure is NameValidationFailure) {
                  errorMessage = "Please enter a valid name";
                } else if (state.failure is PhoneValidationFailure) {
                  errorMessage = "Please enter a valid phone number";
                }
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
                            BlocProvider.of<UserInfoBloc>(context)
                                .resetFailure();
                            Navigator.of(context2).pop();
                          },
                        ),
                      ],
                    );
                  });
            } else if (state.successful == true) {
              await showCupertinoDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context2) {
                    return CupertinoAlertDialog(
                      title: const Text("Success"),
                      content: const Text(
                          "Your information has been successfully updated"),
                      actions: [
                        CupertinoButton(
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.of(context2).pop();
                          },
                        ),
                      ],
                    );
                  });
              BlocProvider.of<UserInfoBloc>(context).resetSuccess();
            }
          },
          builder: (context, state) {
            final UserInfoBloc bloc = BlocProvider.of<UserInfoBloc>(context);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 29,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final XFile? image = await _imagePickerService
                                .pickImageFromGallery();

                            if (image != null) {
                              await _localStorageService.saveProfileImage(
                                  image, _globalBloc.state.user!.id);
                              _globalBloc
                                  .saveProfileImage(await image.readAsBytes());
                              bloc.imageChanged();
                            }
                          },
                          child: Center(
                            child: Hero(
                              tag: 'avatar',
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2,
                                      color: VecColor.primaryColor(context)),
                                  shape: BoxShape.circle,
                                  color: VecColor.resolveColor(
                                    context,
                                    VecColor.highlightColor,
                                  ),
                                ),
                                width: 80,
                                height: 80,
                                child: ClipRRect(
                                  child: _globalBloc.state.profileImage == null
                                      ? SvgPicture.asset(
                                          VecImage.avatar,
                                          color: VecColor.primaryColor(context),
                                        )
                                      : Image.memory(
                                          _globalBloc.state.profileImage!,
                                          width: 78,
                                          height: 78,
                                          fit: BoxFit.cover,
                                        ),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const VecLabel(text: "Email:"),
                        VecTextField(
                          placeholder: "Email",
                          controller: bloc.controllers[0],
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const VecLabel(text: "Name:"),
                        VecTextField(
                          placeholder: "Name",
                          controller: bloc.controllers[1],
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const VecLabel(text: "Phone:"),
                        VecTextField(
                          placeholder: "Phone",
                          controller: bloc.controllers[2],
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: VecButton(
                            child: const Text("Change password"),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(VecRoute.changePassword);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: VecTextShadowButton.filled(
                            color: VecColor.backgroud,
                            textStyle: VecStyles.buttonTextStyle(context),
                            onPressed: bloc.state.isLoading
                                ? null
                                : () => bloc.buttonClicked(),
                            child: bloc.state.isLoading
                                ? const LoadingIndicator(
                                    radius: 12, dotRadius: 3.81)
                                : null,
                            text: "Update your info",
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: VecTextShadowButton.filled(
                            color: VecColor.backgroud,
                            textStyle: VecStyles.buttonTextStyle(context),
                            onPressed: () {
                              Navigator.of(context).pushNamed(VecRoute.vehicle);
                            },
                            text: "Edit vehicle",
                          ),
                        ),
                      ],
                    ),
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
