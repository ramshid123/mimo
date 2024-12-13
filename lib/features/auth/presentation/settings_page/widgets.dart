import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mimo/core/entity/user_entity.dart';
import 'package:mimo/core/enum/login_form_types.dart';
import 'package:mimo/core/global%20states/user%20state/bloc/user_bloc.dart';
import 'package:mimo/core/theme/palette.dart';
import 'package:mimo/core/widgets/common.dart';
import 'package:mimo/features/auth/presentation/settings_page/cubit/profile_pic_cubit.dart';
import 'package:mimo/features/auth/presentation/settings_page/cubit/settings_cubit.dart';

class SettingsPageWidgets {
  static Widget settingsButtons({
    required String title,
    required IconData icon,
  }) {
    return Builder(builder: (context) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(
              icon,
              size: 25,
            ),
            kWidth(20),
            kText(
              text: title,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ],
        ),
      );
    });
  }

  static Widget formField({
    required String hintText,
    required TextEditingController textController,
    required LoginFormType loginFormType,
  }) {
    return Builder(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          kText(
            text: hintText,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color:
                Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5),
          ),
          kHeight(10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withOpacity(0.3),
                  offset: const Offset(0, 0),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: TextFormField(
              controller: textController,
              keyboardType: loginFormType == LoginFormType.email
                  ? TextInputType.emailAddress
                  : loginFormType == LoginFormType.password
                      ? TextInputType.visiblePassword
                      : TextInputType.text,
              cursorColor: ColorConstants.blue,
              obscureText: loginFormType == LoginFormType.password,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                hintText: hintText,
                hintStyle: GoogleFonts.nunito(
                  fontSize: 15,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .color!
                      .withOpacity(0.5),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  static Widget continueButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorConstants.blue,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: kText(
          text: 'Continue',
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  static Future showEditPopup({
    required BuildContext context,
    required UserEntity storedUserData,
  }) async {
    await showDialog(
        context: context,
        // isScrollControlled: true,
        builder: (context) => _EditProfilePopup(
              storedUserData: storedUserData,
            ));
  }
}

class _EditProfilePopup extends StatefulWidget {
  final UserEntity storedUserData;
  const _EditProfilePopup({
    required this.storedUserData,
  });

  @override
  State<_EditProfilePopup> createState() => __EditProfilePopupState();
}

class __EditProfilePopupState extends State<_EditProfilePopup> {
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final descController = TextEditingController();

  @override
  void initState() {
    
    nameController.text = widget.storedUserData.name;
    locationController.text = widget.storedUserData.location;
    descController.text = widget.storedUserData.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Align(
        alignment: Alignment.center,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => context
                        .read<ProfilePicCubit>()
                        .uploadProfilePic(widget.storedUserData.fileId.isEmpty
                            ? null
                            : widget.storedUserData.fileId),
                    child: BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        String picUrl = widget.storedUserData.profilePicUrl;
                        if (state is UserStateUserEntity) {
                          picUrl = state.userEntity.profilePicUrl;
                          log(picUrl);
                        }
                        return Stack(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color,
                              ),
                              child: widget.storedUserData.profilePicUrl
                                          .isEmpty &&
                                      picUrl.isEmpty
                                  ? Icon(
                                      Icons.person_rounded,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      size: 50,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: Image.network(
                                        picUrl,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.4),
                              ),
                              child: Icon(
                                Icons.add_a_photo_rounded,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color!
                                    .withOpacity(0.8),
                                size: 40,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  kHeight(30),
                  SettingsPageWidgets.formField(
                      hintText: 'Name',
                      textController: nameController,
                      loginFormType: LoginFormType.name),
                  kHeight(30),
                  SettingsPageWidgets.formField(
                      hintText: 'Location',
                      textController: locationController,
                      loginFormType: LoginFormType.name),
                  kHeight(30),
                  SettingsPageWidgets.formField(
                      hintText: 'Description',
                      textController: descController,
                      loginFormType: LoginFormType.name),
                  kHeight(30),
                  GestureDetector(
                      onTap: () {
                        context.read<SettingsCubit>().updateUserData(UserEntity(
                              name: nameController.text.isEmpty
                                  ? widget.storedUserData.name
                                  : nameController.text,
                              userId: widget.storedUserData.userId,
                              email: widget.storedUserData.email,
                              profilePicUrl:
                                  widget.storedUserData.profilePicUrl,
                              location: locationController.text.isEmpty
                                  ? widget.storedUserData.location
                                  : locationController.text,
                              description: descController.text.isEmpty
                                  ? widget.storedUserData.description
                                  : descController.text,
                              fileId: widget.storedUserData.fileId,
                            ));
                        Navigator.pop(context);
                      },
                      child: SettingsPageWidgets.continueButton()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
