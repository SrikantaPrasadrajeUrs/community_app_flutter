import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerse_website/core/constants/firebase_constants.dart';
import 'package:ecommerse_website/core/failure.dart';
import 'package:ecommerse_website/core/providers/firebase_provider.dart';
import 'package:ecommerse_website/core/type_defs.dart';
import 'package:ecommerse_website/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final userRepositoryProvider = Provider<UserProfileRepository>((ref)=>UserProfileRepository(firebaseFireStore: ref.read(fireStoreProvider)));

class UserProfileRepository{
  final FirebaseFirestore _firebaseFirestore;
  const UserProfileRepository({required FirebaseFirestore firebaseFireStore}):_firebaseFirestore=firebaseFireStore;

  CollectionReference get _users =>_firebaseFirestore.collection(FirebaseConstants.usersCollection);

  FutureVoid updateUser(UserModel userModel)async{
    try{
      return right(_users.doc(userModel.uid).update(userModel.toMap()));
    }catch(e){
      return left(Failure(e.toString()));
    }
  }
}