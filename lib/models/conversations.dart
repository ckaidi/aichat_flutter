import 'package:chat_flutter/models/message_history.dart';
import 'package:json_annotation/json_annotation.dart';

part 'conversations.g.dart';

@JsonSerializable()
class Conversations {
  String? id;
  String? name;
  String? introduction;
  @JsonKey(name: 'created_at')
  int? createdAt;
  @JsonKey(name: 'updated_at')
  int? updatedAt;
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<MessageHistory> messages = List.empty(growable: true);

  Conversations({
    this.id,
    this.name,
    this.introduction,
    this.createdAt,
    this.updatedAt,
  });

  factory Conversations.fromJson(Map<String, dynamic> json) =>
      _$ConversationsFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationsToJson(this);
}
