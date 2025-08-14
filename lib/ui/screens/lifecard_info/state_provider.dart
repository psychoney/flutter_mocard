import 'package:flutter/material.dart';

class LifeCardInfoStateProvider extends InheritedWidget {
  final AnimationController slideController;
  final AnimationController rotateController;

  const LifeCardInfoStateProvider({
    Key? key,
    required this.slideController,
    required this.rotateController,
    required Widget child,
  }) : super(child: child);

  static LifeCardInfoStateProvider of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<LifeCardInfoStateProvider>();

    return result!;
  }

  @override
  bool updateShouldNotify(covariant LifeCardInfoStateProvider oldWidget) => false;
}
