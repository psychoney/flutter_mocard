import 'package:flutter/material.dart';

import '../../../../configs/colors.dart';

class ChatMessage extends StatelessWidget {
  final String content;
  final bool isSender;
  final String messageType;
  final String imageUrl;

  ChatMessage({
    required this.content,
    required this.isSender,
    this.messageType = 'image',
    this.imageUrl = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'isSender': isSender,
      'messageType': messageType,
      'imageUrl': imageUrl,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.teal,
                AppColors.blue,
              ], // 设置气泡的渐变颜色
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                )
              : Text(
                  content,
                  style: TextStyle(color: Colors.black),
                ),
        ),
      ),
    );
  }
}
