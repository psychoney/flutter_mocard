import 'package:flutter/material.dart';

import '../../configs/colors.dart';

class Card {
  const Card(
      {required this.id,
      required this.title,
      required this.demo,
      required this.description,
      required this.imgUrl,
      required this.role,
      required this.type,
      required this.color});

  final String id;
  final String title;
  final List<Map<String, dynamic>> demo;
  final String description;
  final String imgUrl;
  final List<Map<String, dynamic>> role;
  final String type;
  final String color;
}

extension CardX on Card {
  Color get appColor {
    switch (color) {
      case "blue":
        return AppColors.blue;

      case "red":
        return AppColors.red;

      case "green":
        return AppColors.lightGreen;

      case "brown":
        return AppColors.brown;

      case "grey":
        return AppColors.grey;

      case "yellow":
        return AppColors.yellow;

      case "pink":
        return AppColors.pink;

      case "black":
        return AppColors.black;

      case "purple":
        return AppColors.purple;

      case "teal":
        return AppColors.teal;

      default:
        return AppColors.teal;
    }
  }
}
