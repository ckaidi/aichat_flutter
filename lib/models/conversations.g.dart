// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conversations _$ConversationsFromJson(Map<String, dynamic> json) =>
    Conversations(
      id: json['id'] as String?,
      name: json['name'] as String?,
      introduction: json['introduction'] as String?,
      createdAt: (json['created_at'] as num?)?.toInt(),
      updatedAt: (json['updated_at'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ConversationsToJson(Conversations instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'introduction': instance.introduction,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
