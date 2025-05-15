import 'dart:convert';
import 'dart:js' as js;
import 'package:chat_flutter/models/message_file.dart';
import 'package:chat_flutter/utils/config.dart';
import 'package:chat_flutter/utils/service_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Dio请求示例类
class DioService {
  final Function(bool, Map<String, dynamic>) callback;

  DioService({required this.callback});

  /// 使用curl命令等效的Dio代码示例
  Future<void> curlEquivalentExample(
    String? conversationId,
    bool isDeepThinking,
    bool isSearch,
    String query,
    List<MessageFile> files,
  ) async {
    if (kIsWeb) {
      await _postIt(conversationId, query, isDeepThinking, isSearch, files);
    } else {
      await _nativeDioRequest(
        conversationId,
        query,
        isDeepThinking,
        isSearch,
        files,
      );
    }
  }

  /// 原生平台使用Dio实现
  Future<void> _nativeDioRequest(
    String? conversationId,
    String query,
    bool isDeepThinking,
    bool isSearch,
    List<MessageFile> files,
  ) async {
    // 请求URL
    final url = '${ServiceUtils.baseUrl}chat-messages';

    // 请求头
    final headers = {
      'Authorization': 'Bearer ${ServiceUtils.apiKey}',
      'Content-Type': 'application/json',
    };

    // 请求体
    final data = {
      'inputs': {
        'sikao': isDeepThinking ? "打开深度思考" : '关闭深度思考',
        'lianwang': isSearch ? "打开联网搜索" : '关闭联网搜索',
      },
      'query': query,
      'response_mode': 'streaming',
      'conversation_id': conversationId,
      'user': Config.userId,
      'auto_generate_name': true,
      'files': [
        {
          'type': 'image',
          'transfer_method': 'local_file',
          'upload_file_id': 'https://cloud.dify.ai/logo/logo-site.png',
        },
      ],
    };

    try {
      final dio = Dio();

      // 发送流式POST请求
      final response = await dio.post(
        url,
        options: Options(headers: headers, responseType: ResponseType.stream),
        data: data,
        // onReceiveProgress: (received, total) {
        //   if (total != -1) {
        //     print('已接收: $received  $total');
        //   }
        // },
      );

      // 创建流控制器
      final stream = response.data.stream as Stream;
      await for (final chunk in stream) {
        print('接收到数据块');
      }

      print('流式请求完成');
    } catch (e) {
      print('请求失败: $e');
    }
  }

  void onReceive(bool done, List<int>? bytes) {
    if (done) {
      callback(done, {});
    }
    if (bytes != null) {
      // 将字节数组转换为字符串
      String jsonString = String.fromCharCodes(bytes);
      // 解析JSON字符串
      try {
        final datas = jsonString.split('\n\n');
        for (var data in datas) {
          if (data.isEmpty) {
            continue;
          }
          if (data.startsWith('data: ')) {
            data = data.split('data: ')[1];
            Map<String, dynamic> jsonData = jsonDecode(data);
            callback(done, jsonData);
          }
        }
      } catch (e) {
        print('JSON解析失败: $e');
      }
    }
  }

  Future<void> _postIt(
    String? conversationId,
    String query,
    bool isDeepThinking,
    bool isSearch,
    List<MessageFile> files,
  ) async {
    String fileType='';
    String fileId='';
    if(files.isNotEmpty){
      fileType=files.last.type??"custom";
      fileId=files.last.uploadFileId??"";
    }
    try {
      js.context['onReceive'] = onReceive;
      js.context.callMethod("solution", [
        Config.userId,
        conversationId,
        isDeepThinking,
        isSearch,
        query,
        fileType,
        fileId
      ]);
    } catch (e) {
      print('请求失败: $e');
    }
  }
}
