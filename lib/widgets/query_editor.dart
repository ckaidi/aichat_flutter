import 'package:flutter/material.dart';

class QueryEditor extends StatefulWidget {
  final Function(String) onSend;
  final Function() onCancel;
  final String defaultText;

  const QueryEditor({
    super.key,
    required this.onSend,
    required this.onCancel,
    required this.defaultText,
  });

  @override
  State<QueryEditor> createState() => _QueryEditorState();
}

class _QueryEditorState extends State<QueryEditor> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _controller.addListener(() {
    //   setState(() {
    //     _hasText = _controller.text.isNotEmpty;
    //   });
    // });
    controller.text=widget.defaultText;
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border:
                  _isFocused
                      ? Border.all(color: const Color(0xFF5B7EF9), width: 2)
                      : null,
            ),
            child: TextField(
              controller: controller,
              maxLines: 3,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 8,
            children: [
              TextButton(
                onPressed: widget.onCancel,
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFededed),
                  padding: const EdgeInsets.all(15),
                  minimumSize: Size.zero,
                ),
                child: Text(
                  '取消',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.onSend(controller.text);
                  controller.clear();
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF5B7EF9),
                  padding: const EdgeInsets.all(15),
                  minimumSize: Size.zero,
                ),
                child: Text(
                  '发送',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
