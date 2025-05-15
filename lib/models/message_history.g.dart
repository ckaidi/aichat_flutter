// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageHistory _$MessageHistoryFromJson(Map<String, dynamic> json) =>
    MessageHistory(
      id: json['id'] as String? ?? '',
      conversationId: json['conversation_id'] as String,
      parentMessageId: json['parent_message_id'] as String? ?? '',
      inputs: json['inputs'] as Map<String, dynamic>? ?? const {},
      query: json['query'] as String,
      answer: json['answer'] as String? ?? '',
      messageFiles:
          (json['message_files'] as List<dynamic>?)
              ?.map(
                (e) =>
                    e == null
                        ? null
                        : MessageFile.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      feedback: json['feedback'],
      retrieverResources:
          json['retriever_resources'] as List<dynamic>? ?? const [],
      createdAt: (json['created_at'] as num?)?.toInt(),
      agentThoughts: json['agent_thoughts'] as List<dynamic>? ?? const [],
      status: json['status'] as String? ?? '',
      error: json['error'],
    );

Map<String, dynamic> _$MessageHistoryToJson(MessageHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversation_id': instance.conversationId,
      'parent_message_id': instance.parentMessageId,
      'inputs': instance.inputs,
      'query': instance.query,
      'answer': instance.answer,
      'message_files': instance.messageFiles,
      'feedback': instance.feedback,
      'retriever_resources': instance.retrieverResources,
      'created_at': instance.createdAt,
      'agent_thoughts': instance.agentThoughts,
      'status': instance.status,
      'error': instance.error,
    };
