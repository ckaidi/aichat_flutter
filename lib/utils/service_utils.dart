import 'package:chat_flutter/models/conversations.dart';
import 'package:chat_flutter/models/message_file.dart';
import 'package:chat_flutter/models/message_history.dart';
import 'package:chat_flutter/utils/config.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class ServiceUtils {
  static final String baseUrl = 'http://192.168.42.14:9000/v1/';
  static final Dio _dio = Dio();
  static final String apiKey = 'app-74Z98SoaD00TYFpwbbzDCduY';
  // 恒建dify
  // static final String apiKey = 'app-0xfFffGoZ5mwBu57eRPtS4qT';

  static Future<(bool, List<Conversations>, String)>
  getConversationsHistory() async {
    try {
      final response = await _dio.get(
        '${baseUrl}conversations',
        queryParameters: {'user': Config.userId, 'limit': 100},
        options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
      );
      if (response.statusCode == 200) {
        final conversations = response.data['data'] as List<dynamic>;
        final result =
            conversations.map((c) => Conversations.fromJson(c)).toList();
        return (true, result, '');
      }
      return (false, List<Conversations>.empty(), '');
    } catch (e) {
      return (false, List<Conversations>.empty(), 'Error $e');
    }
  }

  static Future<(bool, List<MessageHistory>, String)> getConversationsMessages(
    String conversationId,
  ) async {
    try {
      final response = await _dio.get(
        '${baseUrl}messages?conversation_id=$conversationId&&user=${Config.userId}',
        options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
      );
      if (response.statusCode == 200) {
        final history = response.data['data'] as List<dynamic>;
        final result = history.map((c) => MessageHistory.fromJson(c)).toList();
        return (true, result, '');
      }
      return (false, List<MessageHistory>.empty(), '');
    } catch (e) {
      return (false, List<MessageHistory>.empty(), 'Error $e');
    }
  }

  static Future<(bool, MessageFile?, String)> uploadFiles(
    PlatformFile file,
  ) async {
    try {
      // 请求体
      final data = {
        'file':
            file.bytes != null
                ? MultipartFile.fromBytes(file.bytes!, filename: file.name)
                : MultipartFile.fromFileSync(file.path!, filename: file.name),
        'user': Config.userId,
      };
      final response = await _dio.post(
        '${baseUrl}files/upload',
        data: FormData.fromMap(data),
        options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
      );
      if (response.statusCode == 201 || response.statusCode == 201) {
        final fileId = response.data['id'].toString();
        return (
          true,
          MessageFile(
            id: fileId,
            type: Config.getMessageFileType(file.extension!),
            transferMethod: 'local_file',
            uploadFileId: fileId,
          ),
          '',
        );
      }
      return (false, null, '');
    } catch (e) {
      return (false, null, 'Error $e');
    }
  }

  // static Future<(bool, List<MessageHistory>, String)> deleteConversations(
  //   String conversationId,
  // ) async {
  //   try {
  //     final response = await _dio.get(
  //       '${baseUrl}conversations/$conversationId',
  //       options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
  //     );
  //     if (response.statusCode == 200) {
  //       final conversations = response.data['data'] as List<dynamic>;
  //       final result =
  //           conversations.map((c) => Conversations.fromJson(c)).toList();
  //       return (true, result, '');
  //     }
  //     return (false, List<Conversations>.empty(), '');
  //   } catch (e) {
  //     return (false, List<Conversations>.empty(), 'Error $e');
  //   }
  // }
}
