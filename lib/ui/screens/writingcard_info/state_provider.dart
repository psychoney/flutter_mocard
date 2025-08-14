import 'package:flutter/material.dart';

class WritingCardInfoStateProvider extends InheritedWidget {
  final AnimationController slideController;
  final AnimationController rotateController;

  const WritingCardInfoStateProvider({
    Key? key,
    required this.slideController,
    required this.rotateController,
    required Widget child,
  }) : super(child: child);

  static WritingCardInfoStateProvider of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<WritingCardInfoStateProvider>();

    return result!;
  }

  @override
  bool updateShouldNotify(covariant WritingCardInfoStateProvider oldWidget) => false;
}
