import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:uuid/uuid.dart';

class Config {
  static List<String> documentExtensions = [
    'TXT',
    'MD',
    'MARKDOWN',
    'PDF',
    'HTML',
    'XLSX',
    'XLS',
    'DOCX',
    'CSV',
    'EML',
    'MSG',
    'PPTX',
    'PPT',
    'XML',
    'EPUB',
  ];

  static List<String> imageExtensions = [
    'JPG',
    'JPEG',
    'PNG',
    'GIF',
    'WEBP',
    'SVG',
  ];
  
  static List<String> allowExtensions = [
    'TXT',
    'MD',
    'MARKDOWN',
    'PDF',
    'HTML',
    'XLSX',
    'XLS',
    'DOCX',
    'CSV',
    'EML',
    'MSG',
    'PPTX',
    'PPT',
    'XML',
    'EPUB',
    'JPG',
    'JPEG',
    'PNG',
    'GIF',
    'WEBP',
    'SVG',
  ];

  static String get userId {
    if (kIsWeb) {
      // 检查cookie中是否有userid
      String cookies = html.document.cookie ?? '';
      final userIdMatch = RegExp(r'userid=([^;]+)').firstMatch(cookies);

      if (userIdMatch == null) {
        // 生成新的userid并设置cookie
        cookies = 'user_${Uuid().v4()}';
        html.document.cookie =
            'userid=$cookies; path=/; expires=Fri, 31 Dec 9999 23:59:59 GMT';
      }
      return cookies;
    }
    return 'user_${Uuid().v4()}';
  }

  static String getMessageFileType(String extension) {
    if (imageExtensions.contains(extension.toUpperCase())) {
      return 'image';
    }
    if (documentExtensions.contains(extension.toUpperCase())) {
      return 'document';
    }
    return 'custom';
  }
}
