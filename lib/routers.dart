import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screen/login_screen.dart';
import 'package:reddit_clone/features/community/screens/community_screen.dart';
import 'package:reddit_clone/features/community/screens/create_community_screen.dart';
import 'package:reddit_clone/features/community/screens/edit_community_screen.dart';
import 'package:reddit_clone/features/community/screens/mod_tools_screen.dart';
import 'package:reddit_clone/home/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';

final logOutRouter = RouteMap(
  routes: {'/': (_) => const MaterialPage(child: LoginScreen())},
);

final loggedInRouter = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: HomeScreen()),
    '/create-community':
        (_) => const MaterialPage(child: CreateCommunityScreen()),
    '/r/:name': (routeData) {
      final name = routeData.pathParameters['name']!;
      return MaterialPage(child: CommunityScreen(name));
    },
    '/mod-tools/:name': (routeData) {
      final name = routeData.pathParameters['name']!;
      return MaterialPage(child: ModToolsScreen(name: name));
    },
    '/edit-community/:name': (routeData) {
      final name = routeData.pathParameters['name']!;
      return MaterialPage(child: EditCommunityScreen(name));
    },
  },
);
