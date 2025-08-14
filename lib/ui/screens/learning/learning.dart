import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocard/configs/images.dart';
import 'package:mocard/routes.dart';

import 'package:mocard/ui/widgets/mo_card.dart';
import 'package:mocard/ui/widgets/main_app_bar.dart';
import 'package:mocard/ui/widgets/pokeball_background.dart';
import 'package:mocard/domain/entities/card.dart' as mocard;

import '../../../states/learning_card/learningcard_bloc.dart';
import '../../../states/learning_card/learningcard_event.dart';
import '../../../states/learning_card/learningcard_selector.dart';
import '../../../states/learning_card/learningcard_state.dart';
import '../../widgets/card_refresh_control.dart';

part 'sections/learning_grid.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen();

  @override
  State<StatefulWidget> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  @override
  Widget build(BuildContext context) {
    return PokeballBackground(
      child: Stack(
        children: [
          _LearningGrid(),
          // _FabMenu(),
        ],
      ),
    );
  }
}
