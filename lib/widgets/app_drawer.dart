import 'package:chat_flutter/utils/service_utils.dart';
import 'package:flutter/material.dart';
import 'package:chat_flutter/models/conversations.dart';

class AppDrawer extends StatefulWidget {
  final Function(Conversations) onItemSelected;

  const AppDrawer({super.key, required this.onItemSelected});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final List<Conversations> _conversations = List<Conversations>.empty(
    growable: true,
  );

  // // 首次打开抽屉的回调函数
  Future<void> _loadConversations() async {
    // 在这里添加首次打开抽屉时需要执行的代码
    final (flag, conversations, msg) =
        await ServiceUtils.getConversationsHistory();
    if (flag) {
      if (mounted) {
        setState(() {
          _conversations.clear();
          _conversations.addAll(conversations);
        });
      } else {
        _conversations.clear();
        _conversations.addAll(conversations);
      }
    } else {}
  }

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Map<String, List<Conversations>> groupConversationsByDate() {
    final Map<String, List<Conversations>> groupedConversations = {};
    for (final conversation in _conversations) {
      if (isToday(conversation)) {
        if (groupedConversations['今天'] == null) {
          groupedConversations['今天'] = [conversation];
        } else {
          groupedConversations['今天']!.add(conversation);
        }
      } else if (isYesterday(conversation)) {
        if (groupedConversations['昨天'] == null) {
          groupedConversations['昨天'] = [conversation];
        } else {
          groupedConversations['昨天']!.add(conversation);
        }
      } else if (isWithin7Days(conversation)) {
        if (groupedConversations['7天内'] == null) {
          groupedConversations['7天内'] = [conversation];
        } else {
          groupedConversations['7天内']!.add(conversation);
        }
      } else if (isWithin30Days(conversation)) {
        if (groupedConversations['30天内'] == null) {
          groupedConversations['30天内'] = [conversation];
        } else {
          groupedConversations['30天内']!.add(conversation);
        }
      } else {
        final key = getYearMonth(conversation);
        if (groupedConversations[key] == null) {
          groupedConversations[key] = [conversation];
        } else {
          groupedConversations[key]!.add(conversation);
        }
      }
    }
    return groupedConversations;
  }

  bool isWithin7Days(Conversations conversation) {
    if (isToday(conversation) || isYesterday(conversation)) return false;
    DateTime? dt;
    if (conversation.updatedAt != null) {
      dt = DateTime.fromMillisecondsSinceEpoch(conversation.updatedAt! * 1000);
    }
    if (dt == null && conversation.createdAt != null) {
      dt = DateTime.fromMillisecondsSinceEpoch(conversation.createdAt! * 1000);
    }
    if (dt == null) return false;
    final now = DateTime.now();
    return now.difference(dt).inDays <= 7;
  }

  bool isWithin30Days(Conversations conversation) {
    if (isToday(conversation) ||
        isYesterday(conversation) ||
        isWithin7Days(conversation)) {
      return false;
    }
    DateTime? dt;
    if (conversation.updatedAt != null) {
      dt = DateTime.fromMillisecondsSinceEpoch(conversation.updatedAt! * 1000);
    }
    if (dt == null && conversation.createdAt != null) {
      dt = DateTime.fromMillisecondsSinceEpoch(conversation.createdAt! * 1000);
    }
    if (dt == null) return false;
    final now = DateTime.now();
    return now.difference(dt).inDays <= 30;
  }

  bool isOlderThan30Days(Conversations conversation) {
    return !isToday(conversation) &&
        !isYesterday(conversation) &&
        !isWithin7Days(conversation) &&
        !isWithin30Days(conversation);
  }

  String getYearMonth(Conversations conversation) {
    DateTime? dt;
    if (conversation.updatedAt != null) {
      dt = DateTime.fromMillisecondsSinceEpoch(conversation.updatedAt! * 1000);
    }
    if (dt == null && conversation.createdAt != null) {
      dt = DateTime.fromMillisecondsSinceEpoch(conversation.createdAt! * 1000);
    }
    if (dt == null) return '';
    return '${dt.year}年${dt.month}月';
  }

  Widget _buildDrawerItem(Conversations conversation) {
    return ListTile(
      title: Text(
        conversation.name ?? '未命名',
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          // fontFamily: 'Noto',
        ),
      ),
      onTap: () {
        widget.onItemSelected(conversation);
      },
    );
  }

  bool isToday(Conversations conversation) {
    DateTime? dt;
    if (conversation.updatedAt != null) {
      dt = DateTime.fromMillisecondsSinceEpoch(conversation.updatedAt! * 1000);
    }
    if (dt == null && conversation.createdAt != null) {
      dt = DateTime.fromMillisecondsSinceEpoch(conversation.createdAt! * 1000);
    }
    if (dt == null) {
      return false;
    }
    final now = DateTime.now();
    // final yesterday = now.subtract(const Duration(days: 1));

    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  bool isMonth(Conversations conversation) {
    if (isToday(conversation)) return false;
    if (isYesterday(conversation)) return false;
    DateTime? dt;
    if (conversation.updatedAt != null) {
      dt = DateTime.fromMillisecondsSinceEpoch(conversation.updatedAt! * 1000);
    }
    if (dt == null && conversation.createdAt != null) {
      dt = DateTime.fromMillisecondsSinceEpoch(conversation.createdAt! * 1000);
    }
    if (dt == null) {
      return false;
    }
    final now = DateTime.now();

    return dt.year == now.year && dt.month == now.month;
  }

  bool isYesterday(Conversations conversation) {
    DateTime? dt;
    if (conversation.updatedAt != null) {
      dt = DateTime.fromMillisecondsSinceEpoch(conversation.updatedAt! * 1000);
    }
    if (dt == null && conversation.createdAt != null) {
      dt = DateTime.fromMillisecondsSinceEpoch(conversation.createdAt! * 1000);
    }
    if (dt == null) {
      return false;
    }
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    return dt.year == yesterday.year &&
        dt.month == yesterday.month &&
        dt.day == yesterday.day;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: groupConversationsByDate().length,
              itemBuilder: (context, index) {
                final group = groupConversationsByDate().entries.elementAt(
                  index,
                );
                final groupKey = group.key;
                final conversations = group.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16, top: 40, bottom: 8),
                      child: Text(
                        groupKey,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    for (final conversation in conversations)
                      _buildDrawerItem(conversation),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFEEEEEE), width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '匿',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'user',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                // const Spacer(),
                // const Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
