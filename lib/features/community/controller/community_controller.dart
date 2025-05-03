import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/repository/community_repository.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

// ignore: non_constant_identifier_names
final UserCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(CommunityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

// ignore: non_constant_identifier_names
final CommunityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
      final communityRepository = ref.watch(CommunityRepositoryProvider);
      final storageRepository = ref.watch(storageRepositoryProvider);
      return CommunityController(
        communityRepository: communityRepository,
        storageRepository: storageRepository,
        ref: ref,
      );
    });

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  final communityController = ref.watch(CommunityControllerProvider.notifier);
  return communityController.getCommunity(name);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  CommunityController({
    required CommunityRepository communityRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  }) : _communityRepository = communityRepository,
       _storageRepository = storageRepository,
       _ref = ref,
       super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );

    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold(
      (l) {
        showSnackBar(context, l.message);
      },
      (r) {
        showSnackBar(context, 'Community created successfully');
        Routemaster.of(context).pop();
      },
    );
  }

  Stream<Community> getCommunity(String name) {
    return _communityRepository.getCommunity(name);
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  void editCommunity({
    required Community community,
    required File? bannerFile,
    required File? profileFile,
    required BuildContext context,
  }) async {
    state = true;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'communities/profile',
        id: community.name,
        file: profileFile,
      );
      res.fold(
        (l) {
          showSnackBar(context, l.message);
        },
        (r) {
          community.copyWith(avatar: r);
        },
      );
    }
    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'communities/banner',
        id: community.name,
        file: bannerFile,
      );
      res.fold(
        (l) {
          showSnackBar(context, l.message);
        },
        (r) {
          community.copyWith(banner: r);
        },
      );
    }
    final res = await _communityRepository.editCommunity(community);
    state = false;

    res.fold(
      (l) {
        showSnackBar(context, l.message);
      },
      (r) {
        showSnackBar(context, 'Community updated successfully');
        Routemaster.of(context).pop();
      },
    );
  }
}
