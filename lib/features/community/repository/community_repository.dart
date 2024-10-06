import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerse_website/core/constants/firebase_constants.dart';
import 'package:ecommerse_website/core/failure.dart';
import 'package:ecommerse_website/core/providers/firebase_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/type_defs.dart';
import '../../../model/community_model/community_model.dart';

final communityRepositoryProvider = Provider((ref) =>
    CommunityRepository(firebaseFirestore: ref.watch(fireStoreProvider))
);

class CommunityRepository {
  final FirebaseFirestore _firebaseFirestore;
  CommunityRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

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
    final stream=_community.where('members',arrayContains: uid).snapshots();
   return _community.where('members',arrayContains: uid).snapshots().map((event){
    List<Community> communities=[];
    for( var doc in event.docs){
      communities.add(Community.fromJson(doc.data() as Map<String,dynamic>));
    }
    return communities;
    });
  }

  CollectionReference get _community => _firebaseFirestore.collection(FirebaseConstants.communitiesCollection);

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
  Stream<List<Community>> getCommunity(String query){
   return _community.where(
     'name',
     isGreaterThanOrEqualTo: query.isEmpty?0:query,
     isLessThan:query.isEmpty? null: query.substring(0,query.length-1)+String.fromCharCode(query.codeUnitAt(query.length-1)+1)
   ).snapshots().map((event){
     List<Community> communities = [];
     for(var community in event.docs){
       communities.add(Community.fromJson(community.data() as Map<String,dynamic>));
     }
     return communities;
   });
  }
}


