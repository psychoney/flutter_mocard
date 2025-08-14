// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fewshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FewshotModel _$FewshotModelFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'uid',
      'deviceId',
      'cardId',
      'imageUrl',
      'question',
      'answer',
      'type',
      'createTime'
    ],
    disallowNullValues: const [
      'uid',
      'deviceId',
      'cardId',
      'imageUrl',
      'question',
      'type',
      'createTime'
    ],
  );
  return FewshotModel(
    json['uid'] as String,
    json['deviceId'] as String,
    json['cardId'] as String,
    json['imageUrl'] as String,
    json['question'] as String,
    json['answer'] as String? ?? '',
    json['type'] as String,
    DateTime.parse(json['createTime'] as String),
  );
}

Map<String, dynamic> _$FewshotModelToJson(FewshotModel instance) => <String, dynamic>{
      'uid': instance.uid,
      'deviceId': instance.deviceId,
      'cardId': instance.cardId,
      'imageUrl': instance.imageUrl,
      'question': instance.question,
      'answer': instance.answer,
      'type': instance.type,
      'createTime': instance.createTime.toIso8601String(),
    };
