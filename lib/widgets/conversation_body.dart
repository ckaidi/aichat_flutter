import 'package:chat_flutter/models/conversations.dart';
import 'package:chat_flutter/models/message_history.dart';
import 'package:chat_flutter/utils/service_utils.dart';
import 'package:chat_flutter/widgets/welcome.dart';
import 'package:flutter/material.dart';
import 'package:chat_flutter/widgets/message_body.dart';

class ConversationBody extends StatefulWidget {
  final Conversations conversations;
  final ScrollController scrollController;
  final Function(MessageHistory) regenerate;

  const ConversationBody({
    super.key,
    required this.conversations,
    required this.scrollController,
    required this.regenerate,
  });

  @override
  State<ConversationBody> createState() => _ConversationBodyState();
}

class _ConversationBodyState extends State<ConversationBody> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      if (widget.conversations.id == null) {
        return;
      }
      // 模拟加载数据的延迟
      final (flag, messages, msg) = await ServiceUtils.getConversationsMessages(
        widget.conversations.id!,
      );
      if (flag) {
        if (mounted) {
          setState(() {
            widget.conversations.messages = messages;
          });
        }
      }
    } catch (e) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.conversations.id != null &&
        widget.conversations.messages.isEmpty) {
      _loadMessages();
    }
    return widget.conversations.id == null
        ? const Welcome()
        : isLoading
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 显示一个圆形进度指示器
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5B7EF9)),
              ),
              const SizedBox(height: 16),
              // 显示加载文字
              Text(
                '加载中...',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        )
        : ListView.builder(
          controller: widget.scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: widget.conversations.messages.length,
          itemBuilder: (context, index) {
            final message = widget.conversations.messages[index];
            return MessageBody(
              message: message,
              regenerate: widget.regenerate,
              expandedToggle: () {
                if (mounted) {
                  setState(() {
                    if (message.isThinkingExpanded == null) {
                      message.isThinkingExpanded = true;
                      return;
                    }
                    message.isThinkingExpanded = !message.isThinkingExpanded!;
                  });
                }
              },
            );
          },
        );
  }
}
