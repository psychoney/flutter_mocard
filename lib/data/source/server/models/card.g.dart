// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerCardModel _$ServerCardModelFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'title',
      'id',
      'imageUrl',
      'description',
      'role',
      'demo',
      'type',
      'color'
    ],
    disallowNullValues: const [
      'title',
      'id',
      'imageUrl',
      'description',
      'role',
      'demo',
      'type',
      'color'
    ],
  );
  return ServerCardModel(
    json['title'] as String,
    json['id'] as String,
    json['imageUrl'] as String,
    json['description'] as String,
    (json['role'] as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .toList(),
    (json['demo'] as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .toList(),
    json['type'] as String,
    json['color'] as String,
  );
}

Map<String, dynamic> _$ServerCardModelToJson(ServerCardModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'role': instance.role,
      'demo': instance.demo,
      'type': instance.type,
      'color': instance.color,
    };
