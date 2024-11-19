import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerse_website/core/constants/firebase_constants.dart';
import 'package:ecommerse_website/core/failure.dart';
import 'package:ecommerse_website/core/providers/firebase_provider.dart';
import 'package:ecommerse_website/core/type_defs.dart';
import 'package:ecommerse_website/model/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final postRepositoryProvider = Provider((ref) =>
    PostRepository(firebaseFireStore: ref.read(fireStoreProvider))
);

class PostRepository {
  final FirebaseFirestore _firebaseFireStore;
  PostRepository({required FirebaseFirestore firebaseFireStore})
      : _firebaseFireStore = firebaseFireStore;
  CollectionReference get _post => _firebaseFireStore.collection(FirebaseConstants.postsCollection);

  FutureVoid addPost(PostModel post)async{
    try{
      return right(_post.doc(post.id).set(post.toJson()));
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

}


