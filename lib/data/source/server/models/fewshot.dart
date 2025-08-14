import 'package:json_annotation/json_annotation.dart';

part 'fewshot.g.dart';

@JsonSerializable()
class FewshotModel {
  FewshotModel(this.uid, this.deviceId, this.cardId, this.imageUrl, this.question, this.answer,
      this.type, this.createTime);

  factory FewshotModel.fromJson(Map<String, dynamic> json) => _$FewshotModelFromJson(json);

  Map<String, dynamic> toJson() => _$FewshotModelToJson(this);

  @JsonKey(required: true, disallowNullValue: true)
  final String uid;

  @JsonKey(required: true, disallowNullValue: true)
  final String deviceId;

  @JsonKey(required: true, disallowNullValue: true)
  final String cardId;

  @JsonKey(required: true, disallowNullValue: true)
  final String imageUrl;

  @JsonKey(required: true, disallowNullValue: true)
  final String question;

  @JsonKey(required: true)
  final String answer;

  @JsonKey(required: true, disallowNullValue: true)
  final String type;

  @JsonKey(required: true, disallowNullValue: true)
  final DateTime createTime;
}
