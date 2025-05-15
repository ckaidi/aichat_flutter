import 'package:json_annotation/json_annotation.dart';

part 'message_file.g.dart';

@JsonSerializable()
class MessageFile {
  final String id;
  final String? filename;
  final String? type;
  final String? url;
  @JsonKey(name: 'mime_type')
  final String? mimeType;
  final int? size;
  @JsonKey(name: 'transfer_method')
  final String? transferMethod;
  @JsonKey(name: 'belongs_to')
  final String? belongsTo;
  @JsonKey(name: 'upload_file_id')
  final String? uploadFileId;

  MessageFile({
    this.id = '',
    this.filename,
    this.type = '',
    this.url = '',
    this.mimeType,
    this.size,
    this.transferMethod,
    this.belongsTo,
    this.uploadFileId,
  });

  factory MessageFile.fromJson(Map<String, dynamic> json) =>
      _$MessageFileFromJson(json);

  Map<String, dynamic> toJson() => _$MessageFileToJson(this);
}
