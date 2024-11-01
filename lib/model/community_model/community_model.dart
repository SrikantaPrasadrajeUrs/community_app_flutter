import 'package:freezed_annotation/freezed_annotation.dart';
part 'community_model.freezed.dart';
part 'community_model.g.dart';


@Freezed()
class Community with _$Community{

  factory Community({
    required String? ownerId,
   required String name,
    required String banner,
    required String avatar,
    required List<String> members,
    required List<String> mods,
    required String id,
  })=_Community;

  factory Community.fromJson(Map<String,dynamic> json)=>_$CommunityFromJson(json);
}
