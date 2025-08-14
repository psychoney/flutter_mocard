import 'package:flutter/material.dart';
import 'package:mocard/configs/colors.dart';

import 'option.dart';

class OptionCard extends StatelessWidget {
  final Option option;
  final bool isSelected;
  final VoidCallback onSelect;

  OptionCard({required this.option, required this.isSelected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? Colors.blue : AppColors.grey;
    final backgroundColor =
        isSelected ? Colors.blue.withOpacity(0.2) : Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: onSelect,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: borderColor, width: 1.0),
            ),
            color: backgroundColor, // Set Background Color

            child: Container(
              width: 100.0, // Set Width
              height: 150.0, // Set Height
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    option.title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    option.price,
                    style: TextStyle(
                      fontSize: 30.0,
                    ),
                  ),
                  Text(
                    option.description,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSelected) // Add checkmark icon
            Positioned(
              bottom: 0,
              left: 42,
              child: Icon(
                Icons.check_circle,
                color: Colors.blue,
              ),
            ),
          if (option.isRecommended)
            Positioned(
              top: 0,
              right: 15,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  '最多人选择',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
