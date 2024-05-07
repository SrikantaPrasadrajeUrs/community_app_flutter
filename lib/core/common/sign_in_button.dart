
import 'package:ecommerse_website/core/constants/constants.dart';
import 'package:ecommerse_website/themes/my_text_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/controller/auth_controller.dart';

class SignInBtn extends ConsumerWidget {
  final bool isFromLogin;
  const SignInBtn({this.isFromLogin=true,super.key});
 
  void signInWithGoogle(WidgetRef ref,BuildContext context){
    ref.read(authControllerProvider.notifier).signInWithGoogle(context,isFromLogin);
    context.push("/home");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      icon: Image.asset(
        Constants.googlePath,
        width: 50,
      ),
      onPressed: (){
        signInWithGoogle(ref,context);
      },
      label: Text(
        'Continue with google',
        style: MyTextThemes.mediumWhite.copyWith(fontSize: 17),
      ),
    );
  }
}
