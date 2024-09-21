import 'package:ecommerse_website/core/common/error.dart';
import 'package:ecommerse_website/features/auth/controller/auth_controller.dart';
import 'package:ecommerse_website/features/auth/screens/center_loader.dart';
import 'package:ecommerse_website/router.dart';
import 'package:ecommerse_website/themes/myThemes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';
import 'model/user_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    print("getData");
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    print(userModel);
    ref.read(userProvider.notifier).update((state) => userModel);
  }
GoRouter getRoute(UserModel? user)=>user==null?loggedOutRoutes:loggedInRoutes;
  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
        data: (data) {
          print("data $data");
          if(data!=null) getData(ref, data);
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: MyTheme.darkModeAppTheme,
            routerConfig: getRoute(userModel),
          );
        },
        error: (error, e) => MaterialApp(home: ErrorText(error: e.toString())),
        loading: () => const CenterLoader()
    );
  }

//   GoRouter getRoute(UserModel? userModel) {
//     if (userModel != null) {
//       return loggedInRoutes;
//     }
//     return loggedOutRoutes;
// // e is stackstrace
//   }
}
