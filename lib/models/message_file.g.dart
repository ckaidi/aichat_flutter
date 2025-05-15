// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageFile _$MessageFileFromJson(Map<String, dynamic> json) => MessageFile(
  id: json['id'] as String? ?? '',
  filename: json['filename'] as String,
  type: json['type'] as String? ?? '',
  url: json['url'] as String? ?? '',
  mimeType: json['mime_type'] as String?,
  size: (json['size'] as num?)?.toInt(),
  transferMethod: json['transfer_method'] as String?,
  belongsTo: json['belongs_to'] as String?,
  uploadFileId: json['upload_file_id'] as String?,
);

Map<String, dynamic> _$MessageFileToJson(MessageFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'filename': instance.filename,
      'type': instance.type,
      'url': instance.url,
      'mime_type': instance.mimeType,
      'size': instance.size,
      'transfer_method': instance.transferMethod,
      'belongs_to': instance.belongsTo,
      'upload_file_id': instance.uploadFileId,
    };
