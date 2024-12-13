
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mimo/core/entity/user_entity.dart';
import 'package:mimo/core/global%20states/user%20state/bloc/user_bloc.dart';
import 'package:mimo/core/utils/show_toast.dart';
import 'package:mimo/core/widgets/common.dart';
import 'package:mimo/features/auth/presentation/auth_page/login_page.dart';
import 'package:mimo/features/auth/presentation/settings_page/cubit/profile_pic_cubit.dart';
import 'package:mimo/features/auth/presentation/settings_page/cubit/settings_cubit.dart';
import 'package:mimo/features/auth/presentation/settings_page/widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late UserEntity userEntity;
  // final userEntity = UserEntity(
  //   userId: 'ramshid',
  //   name: 'Ramsheed',
  //   email: 'ramshid@gmai.com',
  //   profilePicUrl: '',
  //   location: 'Pathimangalam, Kunnamangalam',
  //   description:
  //       'Hi! My name is Ramsheed. I\'m a community manager from Rabat, Morocco',
  // );

  @override
  void initState() {
    userEntity =
        (context.read<UserBloc>().state as UserStateUserEntity).userEntity;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.sizeOf(context);
    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state is SettingsStateFailure) {
          showToastMessage(context: context, message: 'Logout failed');
        } else if (state is SettingsStateLogoutSuccess) {
          showToastMessage(context: context, message: 'Logging out');
          Future.delayed(const Duration(seconds: 1), () async {
            if (context.mounted) {
              await Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (_) => false);
            }
          });
        } else if (state is SettingsStateUserUpdated) {
          showToastMessage(context: context, message: 'User\'s data updated');
          context.read<UserBloc>().add(UserEventUserUpdate(state.user));
          userEntity = (context.read<UserBloc>().state as UserStateUserEntity)
              .userEntity;
        }
      },
      child: BlocListener<ProfilePicCubit, ProfilePicState>(
        listener: (context, state) {
          if (state is ProfilePicStateSuccess) {
            final updatedUser = userEntity.copyWith(
              fileId: state.fileId,
              profilePicUrl:
                  'https://cloud.appwrite.io/v1/storage/buckets/${dotenv.env['PROFILE_PIC_BUCKET_ID']}/files/${state.fileId}/view?project=${dotenv.env['APPWRITE_PROJECT_ID']}&${DateTime.now().millisecondsSinceEpoch}',
            );

            context.read<SettingsCubit>().updateUserData(updatedUser);

            context.read<UserBloc>().add(UserEventUserUpdate(updatedUser));
            userEntity = (context.read<UserBloc>().state as UserStateUserEntity)
                .userEntity;
          }
          
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: kText(
              text: 'Settings',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          body: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              if (state is SettingsStateUserUpdated) {
                userEntity = state.user;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      kHeight(20),
                      Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            child: userEntity.profilePicUrl.isEmpty
                                ? Icon(
                                    Icons.person_rounded,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    size: 50,
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
                                    child: Image.network(
                                      userEntity.profilePicUrl,
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          kWidth(10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                kText(
                                  text: userEntity.name,
                                  fontWeight: FontWeight.bold,
                                  maxLines: 2,
                                ),
                                kText(
                                  text: userEntity.location,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async =>
                                await SettingsPageWidgets.showEditPopup(
                              context: context,
                              storedUserData: userEntity,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 20,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      kHeight(30),
                      kText(
                        text: userEntity.description,
                        fontWeight: FontWeight.w500,
                        maxLines: 20,
                      ),
                      kHeight(50),
                      SettingsPageWidgets.settingsButtons(
                        title: 'Notifications',
                        icon: Icons.notifications,
                      ),
                      SettingsPageWidgets.settingsButtons(
                        title: 'General',
                        icon: Icons.settings,
                      ),
                      SettingsPageWidgets.settingsButtons(
                        title: 'Account',
                        icon: Icons.person,
                      ),
                      SettingsPageWidgets.settingsButtons(
                        title: 'About',
                        icon: Icons.info,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.read<SettingsCubit>().logout();
                        },
                        child: SettingsPageWidgets.settingsButtons(
                          title: 'Logout',
                          icon: Icons.logout,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// autoplay,  background play, language,

// notification,  theme, Privacy, Support,

//  Payment methods
