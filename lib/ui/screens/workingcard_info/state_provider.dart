import 'package:flutter/material.dart';

class WorkingCardInfoStateProvider extends InheritedWidget {
  final AnimationController slideController;
  final AnimationController rotateController;

  const WorkingCardInfoStateProvider({
    Key? key,
    required this.slideController,
    required this.rotateController,
    required Widget child,
  }) : super(child: child);

  static WorkingCardInfoStateProvider of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<WorkingCardInfoStateProvider>();

    return result!;
  }

  @override
  bool updateShouldNotify(covariant WorkingCardInfoStateProvider oldWidget) => false;
}
