import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 鲸鱼图标
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF5B7EF9),
              shape: BoxShape.circle,
            ),
            child: Image.asset('assets/icon.png')
            // const Icon(
            //   Icons.water,
            //   color: Colors.white,
            //   size: 40,
            // ),
          ),
          const SizedBox(height: 20),
          // 欢迎文本
          const Text(
            '我是DeepSeek应用',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          // 描述文本
          const Text(
            '请问有什么可以帮到您？',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          // const Text(
          //   '的任务交给我吧～',
          //   style: TextStyle(
          //     fontSize: 16,
          //     color: Colors.black54,
          //   ),
          // ),
        ],
      ),
    );
  }
}