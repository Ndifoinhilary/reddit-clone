import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screen/login_screen.dart';
import 'package:reddit_clone/home/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';

final logOutRouter = RouteMap(routes: {
  '/': (_) => const MaterialPage(child : LoginScreen()),
});


final loggedInRouter = RouteMap(routes: {
  '/': (_) => const MaterialPage(child : HomeScreen()),
});
