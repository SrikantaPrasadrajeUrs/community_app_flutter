import 'package:ecommerse_website/features/auth/screens/login_screen.dart';
import 'package:ecommerse_website/features/community/screens/community_screen.dart';
import 'package:ecommerse_website/features/community/screens/mod_tools_screen.dart';
import 'package:ecommerse_website/features/home/screens/home_page.dart';
import 'package:go_router/go_router.dart';

import 'features/community/screens/create_community.dart';

final loggedOutRoutes = GoRouter(routes: [
  GoRoute(
      path: '/',
        builder:(context,state)=> const LoginScreen(),)
]);
final loggedInRoutes = GoRouter(
initialLocation: "/home",
    routes: [
      GoRoute(
        path: '/home',
        builder:(context,state)=> const HomePage(),),
  GoRoute(
    path: '/create-community',
    builder:(context,state)=> const CreateCommunity(),),
  GoRoute(
    path: '/r/:name',
    builder: (context,state)=> CommunityScreen(
      name: state.pathParameters['name'],
    ),
  ),
  GoRoute(
    path: "/mod-tools",
    builder:(context,state)=> const ModToolScreen(),
  ),
]);
