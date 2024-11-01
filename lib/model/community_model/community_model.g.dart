// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommunityImpl _$$CommunityImplFromJson(Map<String, dynamic> json) =>
    _$CommunityImpl(
      ownerId: json['ownerId'] as String?,
      name: json['name'] as String,
      banner: json['banner'] as String,
      avatar: json['avatar'] as String,
      members:
          (json['members'] as List<dynamic>).map((e) => e as String).toList(),
      mods: (json['mods'] as List<dynamic>).map((e) => e as String).toList(),
      id: json['id'] as String,
    );

Map<String, dynamic> _$$CommunityImplToJson(_$CommunityImpl instance) =>
    <String, dynamic>{
      'ownerId': instance.ownerId,
      'name': instance.name,
      'banner': instance.banner,
      'avatar': instance.avatar,
      'members': instance.members,
      'mods': instance.mods,
      'id': instance.id,
    };
