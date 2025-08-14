import 'package:flutter/material.dart';

import 'option.dart';
import 'option_card.dart';

class OptionList extends StatefulWidget {
  final ValueChanged<int> onOptionSelected;
  OptionList({required this.onOptionSelected});

  @override
  _OptionListState createState() => _OptionListState();
}

class _OptionListState extends State<OptionList> {
  int selectedOptionIndex = 0;

  final List<Option> options = [
    Option(title: '年会员', price: '¥98', description: '2.5折', isRecommended: true),
    Option(title: '月会员', price: '¥18', description: '6折优惠'),
    Option(title: '周会员', price: '¥8', description: '新人体验'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: options.asMap().entries.map((entry) {
        return OptionCard(
          option: entry.value,
          isSelected: selectedOptionIndex == entry.key,
          onSelect: () {
            setState(() {
              selectedOptionIndex = entry.key;
              widget.onOptionSelected(selectedOptionIndex);
            });
          },
        );
      }).toList(),
    );
  }
}
