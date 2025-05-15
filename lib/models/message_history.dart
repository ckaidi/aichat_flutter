import 'package:chat_flutter/models/message_file.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_history.g.dart';

@JsonSerializable()
class MessageHistory {
  final String id;
  @JsonKey(name: 'conversation_id')
  final String conversationId;
  @JsonKey(name: 'parent_message_id')
  final String? parentMessageId;
  final Map<String, dynamic> inputs;
  String query;
  String answer;
  @JsonKey(name: 'message_files')
  final List<MessageFile?> messageFiles;
  final dynamic feedback;
  @JsonKey(name: 'retriever_resources')
  final List<dynamic> retrieverResources;
  @JsonKey(name: 'created_at')
  final int? createdAt;
  @JsonKey(name: 'agent_thoughts')
  final List<dynamic> agentThoughts;
  final String status;
  final dynamic error;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? isThinkingExpanded = true;

  MessageHistory({
    this.id = '',
    required this.conversationId,
    this.parentMessageId = '',
    this.inputs = const {},
    required this.query,
    this.answer = '',
    this.messageFiles = const [],
    this.feedback,
    this.retrieverResources = const [],
    this.createdAt,
    this.agentThoughts = const [],
    this.status = '',
    this.error,
  });

  factory MessageHistory.fromJson(Map<String, dynamic> json) =>
      _$MessageHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$MessageHistoryToJson(this);

  bool isDeepThink() {
    return answer.startsWith('<details');
  }

  bool isThinking() {
    final result = answer.contains('</details>');
    return !result;
  }

  String getMessages() {
    if (isDeepThink()) {
      final arrays = answer.split('</details>');
      if (arrays.length < 2) return '';
      return arrays[1].trim();
    }
    return answer.trim();
  }

  String getThinks() {
    final regex = RegExp(r'<details[^>]*>(.*?)</details>', dotAll: true);
    final match = regex.firstMatch(answer);
    if (match != null) {
      final result = match.group(1);
      return result
              ?.replaceAll('<summary> Thinking... </summary>', '')
              .trim() ??
          '';
    }
    return '';
  }
}
