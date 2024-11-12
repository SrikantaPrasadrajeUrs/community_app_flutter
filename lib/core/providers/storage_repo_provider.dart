import 'dart:io';
import 'package:ecommerse_website/core/failure.dart';
import 'package:ecommerse_website/core/providers/firebase_provider.dart';
import 'package:ecommerse_website/core/type_defs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final storageRepoProvider = Provider((ref)=>StorageRepo(firebaseStorage: ref.read(storageProvider)));

class StorageRepo{
final FirebaseStorage _firebaseStorage;

StorageRepo({required FirebaseStorage firebaseStorage}):_firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile({required String path, required String name,required File? file })async{
    try{
    final ref = _firebaseStorage.ref(path).child(name);
    UploadTask uploadTask = ref.putFile(file!);
    var snapshot = await uploadTask;
    return right(await snapshot.ref.getDownloadURL());
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

}