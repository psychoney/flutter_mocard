import 'package:flutter/material.dart';

class LearningCardInfoStateProvider extends InheritedWidget {
  final AnimationController slideController;
  final AnimationController rotateController;

  const LearningCardInfoStateProvider({
    Key? key,
    required this.slideController,
    required this.rotateController,
    required Widget child,
  }) : super(child: child);

  static LearningCardInfoStateProvider of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<LearningCardInfoStateProvider>();

    return result!;
  }

  @override
  bool updateShouldNotify(covariant LearningCardInfoStateProvider oldWidget) => false;
}
