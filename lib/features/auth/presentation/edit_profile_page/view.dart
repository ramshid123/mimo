import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mimo/core/entity/user_entity.dart';
import 'package:mimo/core/global%20states/user%20state/bloc/user_bloc.dart';
import 'package:mimo/core/theme/palette.dart';
import 'package:mimo/core/utils/show_toast.dart';
import 'package:mimo/core/widgets/common.dart';
import 'package:mimo/features/auth/presentation/edit_profile_page/cubit/edit_profile_cubit.dart';
import 'package:mimo/features/auth/presentation/settings_page/cubit/profile_pic_cubit.dart';
import 'package:mimo/features/auth/presentation/edit_profile_page/widgets.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late ColorConstants theme;

  late UserEntity storedUserData;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();

  final profilePicUrl = ValueNotifier('');

  @override
  void initState() {
    storedUserData =
        (context.read<UserBloc>().state as UserStateUserEntity).userEntity;

    nameController.text = storedUserData.name;
    descriptionController.text = storedUserData.description;
    locationController.text = storedUserData.location;
    profilePicUrl.value = storedUserData.profilePicUrl;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocListener<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileStateDataUpdated) {
          context.read<UserBloc>().add(UserEventUserUpdate(state.user));

          showToastMessage(
              context: context, message: 'Data updated successfully');

          Navigator.pop(context);
        }
        if (state is EditProfileStateFailure) {
          showToastMessage(context: context, message: 'Something went wrong');
        }
      },
      child: BlocListener<ProfilePicCubit, ProfilePicState>(
        listener: (context, state) {
          if (state is ProfilePicStateSuccess) {
            context.read<UserBloc>().add(UserEventUserUpdate(
                storedUserData.copyWith(
                    profilePicUrl:
                        'https://cloud.appwrite.io/v1/storage/buckets/${dotenv.env['PROFILE_PIC_BUCKET_ID']}/files/${state.fileId}/view?project=${dotenv.env['APPWRITE_PROJECT_ID']}',
                    fileId: state.fileId)));
          }
          
        },
        child: BlocBuilder<EditProfileCubit, EditProfileState>(
          builder: (context, state) {
            return PopScope(
              canPop: state is! EditProfileStateLoading,
              child: Scaffold(
                backgroundColor: ColorConstants.blue,
                body: SingleChildScrollView(
                  child: SizedBox(
                    height: size.height,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            kHeight(20),
                            SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: const Icon(
                                          Icons.arrow_back,
                                          size: 25,
                                          color: ColorConstants.blue,
                                        ),
                                      ),
                                    ),
                                    kWidth(20),
                                    kText(
                                      text: 'Personal Information',
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color,
                                      fontSize: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            kHeight(20),
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color!
                                        .withOpacity(0.1),
                                    offset: const Offset(0, 0),
                                    blurRadius: 9,
                                    spreadRadius: 0,
                                  ),
                                ],
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: ColorConstants.blue,
                                size: 70,
                              ),
                            ),
                            kHeight(10),
                            kText(
                              text: 'Edit Profile',
                              fontSize: 15,
                            ),
                            kHeight(30),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(50),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    kHeight(50),
                                    EditProfilePageWidgets.textFormFields(
                                        hintText: 'Full name',
                                        textController: nameController),
                                    kHeight(10),
                                    GestureDetector(
                                      onTap: () {
                                        // context
                                        //     .read<EditProfileCubit>()
                                        //     .editUserData(
                                        //         user: UserEntity(
                                        //       userId: storedUserData.userId,
                                        //       fullName: nameController.text,
                                        //       dob: dob.value,
                                        //       gender: gender.value.toString(),
                                        //       profilePicUrl:
                                        //           storedUserData.profilePicUrl,
                                        //       createdAt: storedUserData.createdAt,
                                        //       email: storedUserData.email,
                                        //       phoneNo: phoneNoController.text,
                                        //       password: storedUserData.password,
                                        //     ));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        (state is EditProfileStateLoading)
                            ? Container(
                                height: size.height,
                                width: size.width,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color!
                                    .withOpacity(0.5),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const CircularProgressIndicator(
                                      color: ColorConstants.blue,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
