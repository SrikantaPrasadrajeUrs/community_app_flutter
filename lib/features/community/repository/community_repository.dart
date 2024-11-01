import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerse_website/core/constants/firebase_constants.dart';
import 'package:ecommerse_website/core/failure.dart';
import 'package:ecommerse_website/core/providers/firebase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/type_defs.dart';
import '../../../model/community_model/community_model.dart';

final communityRepositoryProvider = Provider((ref) =>
    CommunityRepository(firebaseFireStore: ref.watch(fireStoreProvider))
);

class CommunityRepository {
  final FirebaseFirestore _firebaseFireStore;
  CommunityRepository({required FirebaseFirestore firebaseFireStore})
      : _firebaseFireStore = firebaseFireStore;

  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _community.doc(community.name).get();
      if (communityDoc.exists) {
        throw 'Community with the same name already exists!';
      }
      return right(_community.doc(community.name).set(community.toJson()));
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
  Stream<List<Community>> getUserCommunities(String uid){
   return _community.where('members',arrayContains: uid).snapshots().map((event){
    List<Community> communities=[];
    for( var doc in event.docs){
      communities.add(Community.fromJson(doc.data() as Map<String,dynamic>));
    }
    return communities;
    });
  }

  CollectionReference get _community => _firebaseFireStore.collection(FirebaseConstants.communitiesCollection);

  Stream<Community> getCommunityByName(String name){
    return _community.doc(name).snapshots().map((event)=>Community.fromJson(event.data() as Map<String,dynamic>));
  }

  FutureVoid editCommunity(Community community)async{
    try{
     return right(_community.doc(community.name).update(community.toJson()));
    }on FirebaseException catch(e){
      throw e.toString();
    }
    catch(e){
      return left(Failure(e.toString()));
    }
  }
  Stream<List<Community>> getCommunitiesByName(String query){
   return _community.where('name').snapshots().map((event){
     List<Community> communities = [];
     for(var community in event.docs){
       communities.add(Community.fromJson(community.data() as Map<String,dynamic>));
     }
     return communities;
   });
  }

  FutureVoid updateCommunityMembership(String communityName,String userId,{bool join = true})async{
    try{
      return right(_community.doc(communityName).update({
        "members":join?FieldValue.arrayUnion([userId]):FieldValue.arrayRemove([userId])
      }));
    } catch(e,stackTrace){
      log("while updating community membership",stackTrace: stackTrace);
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deleteCommunity(String communityName)async{
    try{
      return right(_community.doc(communityName).delete());
    }catch(e,stackTrace){
      return left(Failure(e.toString()));
    }
  }

  FutureVoid updateCommunityMods(List<String> mods,String communityName)async{
    try{
      return right(_community.doc(communityName).update({
        "mods":mods
      }));
    }catch (e){
      return left(Failure(e.toString()));
    }
  }
}


