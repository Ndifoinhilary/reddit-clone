import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/theme/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen(this.name, {super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFIle;
  File? profileFIle;

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFIle = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        profileFIle = File(res.files.first.path!);
      });
    }
  }

  void saveCommunity(Community community) {
    ref
        .read(CommunityControllerProvider.notifier)
        .editCommunity(
          community: community,
          bannerFile: bannerFIle,
          profileFile: profileFIle,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(CommunityControllerProvider);
    return ref
        .watch(getCommunityByNameProvider(widget.name))
        .when(
          data:
              (community) => Scaffold(
                appBar: AppBar(
                  title: const Text('Edit Community'),
                  actions: [
                    TextButton(
                      onPressed: () => saveCommunity(community),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                body:
                    isLoading
                        ? Loader()
                        : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 200,
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: selectBannerImage,
                                      child: DottedBorder(
                                        radius: const Radius.circular(10),
                                        dashPattern: const [10, 4],
                                        strokeCap: StrokeCap.round,
                                        color:
                                            Pallete
                                                .darkModeAppTheme
                                                .textTheme
                                                .bodyLarge!
                                                .color!,
                                        child: Container(
                                          height: 150,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child:
                                              bannerFIle != null
                                                  ? Image.file(bannerFIle!)
                                                  : community.banner.isEmpty ||
                                                      community.banner ==
                                                          Constants
                                                              .bannerDefault
                                                  ? Center(
                                                    child: Icon(
                                                      Icons.camera_alt_outlined,
                                                      size: 40,
                                                    ),
                                                  )
                                                  : Image.network(
                                                    community.banner,
                                                  ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 20,
                                      left: 20,

                                      child: GestureDetector(
                                        onTap: selectProfileImage,
                                        child:
                                            profileFIle != null
                                                ? CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage: FileImage(
                                                    profileFIle!,
                                                  ),
                                                )
                                                : CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage: NetworkImage(
                                                    community.avatar,
                                                  ),
                                                ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
              ),
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }
}
