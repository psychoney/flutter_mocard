import 'package:json_annotation/json_annotation.dart';

part 'card.g.dart';

@JsonSerializable()
class ServerCardModel {
  ServerCardModel(this.title, this.id, this.imageUrl, this.description, this.role, this.demo,
      this.type, this.color);

  factory ServerCardModel.fromJson(Map<String, dynamic> json) => _$ServerCardModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServerCardModelToJson(this);

  @JsonKey(required: true, disallowNullValue: true)
  final String title;

  @JsonKey(required: true, disallowNullValue: true)
  final String id;

  @JsonKey(required: true, disallowNullValue: true)
  final String imageUrl;

  @JsonKey(required: true, disallowNullValue: true)
  final String description;

  @JsonKey(required: true, disallowNullValue: true)
  final List<Map<String, dynamic>> role;

  @JsonKey(required: true, disallowNullValue: true)
  final List<Map<String, dynamic>> demo;

  @JsonKey(required: true, disallowNullValue: true)
  final String type;

  @JsonKey(required: true, disallowNullValue: true)
  final String color;
}
