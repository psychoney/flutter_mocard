import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mocard/configs/colors.dart';
import 'package:mocard/domain/entities/fewshot.dart';

class FewshotCard extends StatelessWidget {
  final Fewshot fewshot;
  final void Function()? onPress;

  const FewshotCard(
    this.fewshot, {
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(child: _buildContent(context)),
            SizedBox(width: 20),
            Image(image: NetworkImage(fewshot.imageUrl), width: 110, height: 66),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          fewshot.question,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        Text(
          fewshot.answer,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 6),
        Text(
          DateFormat('yyyy-MM-dd HH:mm').format(fewshot.createTime), // 格式化日期时间
        ),
      ],
    );
  }
}
