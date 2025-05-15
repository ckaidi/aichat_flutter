import 'package:chat_flutter/models/conversations.dart';
import 'package:chat_flutter/models/message_file.dart';
import 'package:chat_flutter/models/message_history.dart';
import 'package:chat_flutter/utils/config.dart';
import 'package:chat_flutter/utils/dio_service.dart';
import 'package:chat_flutter/utils/service_utils.dart';
import 'package:chat_flutter/widgets/conversation_body.dart';
import 'package:chat_flutter/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:chat_flutter/widgets/file_body.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeepSeek Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ChatHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  // 上传的文件列表
  List<PlatformFile> _uploadedFiles = [];
  // 按钮状态
  bool _isDeepThinkingActive = false;
  bool _isWebSearchActive = false;

  // hover状态
  bool _isDeepThinkingHovered = false;
  bool _isWebSearchHovered = false;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Conversations _selectedConversation = Conversations();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: AppDrawer(
        onItemSelected: (conversation) {
          // 关闭抽屉
          if (mounted) {
            setState(() {
              _selectedConversation = conversation;
            });
          } else {
            _selectedConversation = conversation;
          }
          Navigator.pop(context);
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _selectedConversation.name ?? '新对话',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.black),
            onPressed: _createNewChat,
          ),
        ],
      ),
      body: Column(
        children: [
          // 主体内容区域
          Expanded(
            child: ConversationBody(
              regenerate: _resend,
              conversations: _selectedConversation,
              scrollController: _scrollController,
            ),
          ),
          // 底部输入区域
          Container(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 8,
              top: 8,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFEEEEEE), width: 1),
              ),
            ),
            child: Column(
              children: [
                // 上传的文件显示区域
                if (_uploadedFiles.isNotEmpty)
                  SizedBox(
                    height:
                        ((_uploadedFiles.length.toDouble() / 2).ceil()) * 60,
                    child: MasonryGridView.count(
                      cacheExtent: 2160,
                      crossAxisCount: 2,
                      itemCount: _uploadedFiles.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FileBody(
                          filename: _uploadedFiles[index].name,
                          fileExtension: _uploadedFiles[index].extension,
                          fileSize: _uploadedFiles[index].size,
                          onRemove: () {
                            setState(() {
                              _uploadedFiles.removeAt(index);
                            });
                          },
                        );
                      },
                    ),
                  ),
                // 消息输入框
                Container(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 8,
                    top: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: '给DeepSeek发送消息',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                          textInputAction: TextInputAction.newline,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // 底部按钮区域
                Row(
                  children: [
                    // 深度思考按钮
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter:
                          (_) => setState(() => _isDeepThinkingHovered = true),
                      onExit:
                          (_) => setState(() => _isDeepThinkingHovered = false),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isDeepThinkingActive = !_isDeepThinkingActive;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                _isDeepThinkingActive
                                    ? _isDeepThinkingHovered
                                        ? const Color(
                                          0xFF5B7EF9,
                                        ).withValues(alpha: .3)
                                        : const Color(
                                          0xFF5B7EF9,
                                        ).withValues(alpha: .2)
                                    : _isDeepThinkingHovered
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.string(
                                '<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M2.656 17.344c-1.016-1.015-1.15-2.75-.313-4.925.325-.825.73-1.617 1.205-2.365L3.582 10l-.033-.054c-.5-.799-.91-1.596-1.206-2.365-.836-2.175-.703-3.91.313-4.926.56-.56 1.364-.86 2.335-.86 1.425 0 3.168.636 4.957 1.756l.053.034.053-.034c1.79-1.12 3.532-1.757 4.957-1.757.972 0 1.776.3 2.335.86 1.014 1.015 1.148 2.752.312 4.926a13.892 13.892 0 0 1-1.206 2.365l-.034.054.034.053c.5.8.91 1.596 1.205 2.365.837 2.175.704 3.911-.311 4.926-.56.56-1.364.861-2.335.861-1.425 0-3.168-.637-4.957-1.757L10 16.415l-.053.033c-1.79 1.12-3.532 1.757-4.957 1.757-.972 0-1.776-.3-2.335-.86zm13.631-4.399c-.187-.488-.429-.988-.71-1.492l-.075-.132-.092.12a22.075 22.075 0 0 1-3.968 3.968l-.12.093.132.074c1.308.734 2.559 1.162 3.556 1.162.563 0 1.006-.138 1.298-.43.3-.3.436-.774.428-1.346-.008-.575-.159-1.264-.449-2.017zm-6.345 1.65l.058.042.058-.042a19.881 19.881 0 0 0 4.551-4.537l.043-.058-.043-.058a20.123 20.123 0 0 0-2.093-2.458 19.732 19.732 0 0 0-2.458-2.08L10 5.364l-.058.042A19.883 19.883 0 0 0 5.39 9.942L5.348 10l.042.059c.631.874 1.332 1.695 2.094 2.457a19.74 19.74 0 0 0 2.458 2.08zm6.366-10.902c-.293-.293-.736-.431-1.298-.431-.998 0-2.248.429-3.556 1.163l-.132.074.12.092a21.938 21.938 0 0 1 3.968 3.968l.092.12.074-.132c.282-.504.524-1.004.711-1.492.29-.753.442-1.442.45-2.017.007-.572-.129-1.045-.429-1.345zM3.712 7.055c.202.514.44 1.013.712 1.493l.074.13.092-.119a21.94 21.94 0 0 1 3.968-3.968l.12-.092-.132-.074C7.238 3.69 5.987 3.262 4.99 3.262c-.563 0-1.006.138-1.298.43-.3.301-.436.774-.428 1.346.007.575.159 1.264.448 2.017zm0 5.89c-.29.753-.44 1.442-.448 2.017-.008.572.127 1.045.428 1.345.293.293.736.431 1.298.431.997 0 2.247-.428 3.556-1.162l.131-.074-.12-.093a21.94 21.94 0 0 1-3.967-3.968l-.093-.12-.074.132a11.712 11.712 0 0 0-.71 1.492z" fill="currentColor" stroke="currentColor" stroke-width=".1"></path><path d="M10.706 11.704A1.843 1.843 0 0 1 8.155 10a1.845 1.845 0 1 1 2.551 1.704z" fill="currentColor" stroke="currentColor" stroke-width=".2"></path></svg>',
                                width: 20,
                                height: 20,
                                color:
                                    _isDeepThinkingActive
                                        ? const Color(0xFF5B7EF9)
                                        : Colors.black,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '深度思考 (R1)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      _isDeepThinkingActive
                                          ? const Color(0xFF5B7EF9)
                                          : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 联网搜索按钮
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter:
                          (_) => setState(() => _isWebSearchHovered = true),
                      onExit:
                          (_) => setState(() => _isWebSearchHovered = false),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isWebSearchActive = !_isWebSearchActive;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                _isWebSearchActive
                                    ? _isWebSearchHovered
                                        ? const Color(
                                          0xFF5B7EF9,
                                        ).withValues(alpha: .3)
                                        : const Color(
                                          0xFF5B7EF9,
                                        ).withValues(alpha: .2)
                                    : _isWebSearchHovered
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.string(
                                '<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg"><circle cx="10" cy="10" r="9" stroke="currentColor" stroke-width="1.8"></circle><path d="M10 1c1.657 0 3 4.03 3 9s-1.343 9-3 9M10 19c-1.657 0-3-4.03-3-9s1.343-9 3-9M1 10h18" stroke="currentColor" stroke-width="1.8"></path></svg>',
                                width: 20,
                                height: 20,
                                color:
                                    _isWebSearchActive
                                        ? const Color(0xFF5B7EF9)
                                        : Colors.black,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '联网搜索',
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      _isWebSearchActive
                                          ? const Color(0xFF5B7EF9)
                                          : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // 添加按钮
                    IconButton(
                      icon: SvgPicture.string(
                        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 14 20" fill="none"><path d="M7 20c-1.856-.002-3.635-.7-4.947-1.94C.74 16.819.003 15.137 0 13.383V4.828a4.536 4.536 0 0 1 .365-1.843 4.75 4.75 0 0 1 1.087-1.567A5.065 5.065 0 0 1 3.096.368a5.293 5.293 0 0 1 3.888 0c.616.244 1.174.6 1.643 1.05.469.45.839.982 1.088 1.567.25.586.373 1.212.364 1.843v8.555a2.837 2.837 0 0 1-.92 2.027A3.174 3.174 0 0 1 7 16.245c-.807 0-1.582-.3-2.158-.835a2.837 2.837 0 0 1-.92-2.027v-6.22a1.119 1.119 0 1 1 2.237 0v6.22a.777.777 0 0 0 .256.547.868.868 0 0 0 .585.224c.219 0 .429-.08.586-.224a.777.777 0 0 0 .256-.546V4.828A2.522 2.522 0 0 0 7.643 3.8a2.64 2.64 0 0 0-.604-.876 2.816 2.816 0 0 0-.915-.587 2.943 2.943 0 0 0-2.168 0 2.816 2.816 0 0 0-.916.587 2.64 2.64 0 0 0-.604.876 2.522 2.522 0 0 0-.198 1.028v8.555c0 1.194.501 2.339 1.394 3.183A4.906 4.906 0 0 0 7 17.885a4.906 4.906 0 0 0 3.367-1.319 4.382 4.382 0 0 0 1.395-3.183v-6.22a1.119 1.119 0 0 1 2.237 0v6.22c-.002 1.754-.74 3.436-2.052 4.677C10.635 19.3 8.856 19.998 7 20z" fill="currentColor"></path></svg>',
                        width: 23,
                        height: 23,
                      ),
                      padding: EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      onPressed: _uploadFile,
                    ),
                    const SizedBox(width: 8),
                    // 发送按钮
                    IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xff4d6bfe),
                        ),
                      ),
                      onPressed: _sendMessage,
                      icon: const Icon(Icons.arrow_upward, color: Colors.white),
                    ),
                    // Container(
                    //   width: 36,
                    //   height: 36,
                    //   decoration: const BoxDecoration(
                    //     color: Color(0xFF5B7EF9),
                    //     shape: BoxShape.circle,
                    //   ),
                    //   child: const Icon(Icons.arrow_upward, color: Colors.white),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void callback(bool done, Map<String, dynamic> response) {
    try {
      if (done) {
        print('');
      }
      if (!response.containsKey('answer')) {
        return;
      }
      if (response['answer'] != null) {
        _selectedConversation.id ??= response['conversation_id'].toString();
        setState(() {
          // 更新最后一条AI消息
          if (_selectedConversation.messages.isNotEmpty) {
            if (mounted) {
              setState(() {
                _selectedConversation.messages.last.answer +=
                    response['answer'].toString();
              });
            } else {
              _selectedConversation.messages.last.answer +=
                  response['answer'].toString();
            }
          }

          // 滚动到底部
          Future.delayed(const Duration(milliseconds: 100), () {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        });
      }
    } catch (e) {
      print('处理响应错误: $e');
    }
  }

  Future<void> _resend(MessageHistory message) async {
    setState(() {
      final newMsg = MessageHistory(
        conversationId: _selectedConversation.id ?? '',
        query: message.query,
        messageFiles: message.messageFiles,
      );
      _selectedConversation.messages.add(newMsg);
      _messageController.clear();
      _uploadedFiles.clear(); // 清空已上传的文件
    });
    // 滚动到底部
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
    DioService(callback: callback).curlEquivalentExample(
      message.conversationId,
      _isDeepThinkingActive,
      _isWebSearchActive,
      message.query,
      message.messageFiles.map((x) {
        return x!;
      }).toList(),
    );
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty && _uploadedFiles.isEmpty) return;

    String query = message;
    final filesId = List<MessageFile>.empty(growable: true);
    // 如果有上传的文件，读取文件内容并添加到消息中
    if (_uploadedFiles.isNotEmpty) {
      try {
        for (final file in _uploadedFiles) {
          final (flag, messageFile, msg) = await ServiceUtils.uploadFiles(file);
          if (flag && messageFile != null) {
            filesId.add(messageFile);
          }
        }
      } catch (e) {
        // print('读取文件错误: $e');
        // ScaffoldMessenger.of(
        //   context,
        // ).showSnackBar(const SnackBar(content: Text('读取文件失败')));
        // return;
      }
    }

    setState(() {
      final newMsg = MessageHistory(
        conversationId: _selectedConversation.id ?? '',
        query: query,
        messageFiles: filesId,
      );
      _selectedConversation.messages.add(newMsg);
      _messageController.clear();
      _uploadedFiles.clear(); // 清空已上传的文件
    });
    // 滚动到底部
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
    DioService(callback: callback).curlEquivalentExample(
      _selectedConversation.id,
      _isDeepThinkingActive,
      _isWebSearchActive,
      message,
      filesId,
    );
  }

  void _createNewChat() {
    if (mounted) {
      setState(() {
        _selectedConversation = Conversations();
      });
    } else {
      _selectedConversation = Conversations();
    }
  }

  Future<void> _uploadFile() async {
    try {
      // 1. 使用文件选择器选择文件
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: Config.allowExtensions,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _uploadedFiles = result.files;
        });
      }
    } catch (e) {
      print('文件上传错误: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('文件上传失败')));
      }
    }
  }
}
