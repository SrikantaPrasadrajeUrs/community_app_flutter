import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerse_website/core/constants/constants.dart';
import 'package:ecommerse_website/core/constants/firebase_constants.dart';
import 'package:ecommerse_website/core/failure.dart';
import 'package:ecommerse_website/core/providers/firebase_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/type_defs.dart';
import '../../../model/user_model.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
      firebaseFirestore: ref.read(fireStoreProvider),
      auth: ref.read(authProvider),
      googleSignIn: ref.read(googleSignInProvider)),
);

class AuthRepository {
  // Used to store in DB
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  AuthRepository(
      {required FirebaseFirestore firebaseFirestore,
      required FirebaseAuth auth,
      required GoogleSignIn googleSignIn})
      : _auth = auth,
        _firestore = firebaseFirestore,
        _googleSignIn = googleSignIn;
  // to create a collection in firebase cloud
  CollectionReference get _user =>
      _firestore.collection(FirebaseConstants.usersCollection);

  // here user represents a user account
  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle(bool isFromLogin) async {
    try {

      // handles sign in with google account
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print(googleUser?.displayName);
      //generates access token and id wrt to account
      final googleAuth = (await googleUser?.authentication);
      // credential contains user info
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      /// to retain user info we will check if user is new user or not
      late UserModel userModel;
      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user?.displayName ?? '',
          profilePic: userCredential.user?.photoURL ?? '',
          banner: Constants.bannerDefault,
          uid: userCredential.user?.uid??"",
          isAuthenticated: true,
          awards: [],
          karma: 0,
        );
        await _user.doc(userModel.uid).set(userModel.toMap());
      } else {
        print("reloading user");
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    }catch (e) {
      log("Error while sign-in:",error: e);
      return left(Failure(e.toString()));
    }
  }

  //  Firebase Cloud Firestore's strength lies in its real-time capabilities. It updates clients whenever data changes on the server.
  // @return type is Stream because we may get modified user data from firebase.
  Stream<UserModel> getUserData(String uid) {
    // retrives user from collection using uid which will contain data in the form of Map
    return _user
        .doc(uid)
        .snapshots()
        .map((data) => UserModel.fromMap(data.data() as Map<String, dynamic>));
  }

  Future<void> logout()async{
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
