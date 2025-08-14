import 'package:flutter/material.dart';
import 'package:mocard/ui/widgets/spacer.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    this.margin = const EdgeInsets.symmetric(horizontal: 28),
  });

  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      margin: margin,
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 26),
          HSpacer(13),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                isDense: true,
                hintText: '搜索卡片和技能',
                contentPadding: EdgeInsets.zero,
                hintStyle: TextStyle(
                  fontSize: 14,
                  // color: AppColors.grey,
                  height: 1,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
