import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocard/configs/images.dart';
import 'package:mocard/routes.dart';

import 'package:mocard/ui/widgets/mo_card.dart';
import 'package:mocard/ui/widgets/main_app_bar.dart';
import 'package:mocard/ui/widgets/pokeball_background.dart';
import 'package:mocard/domain/entities/card.dart' as mocard;

import '../../../states/writing_card/writingcard_bloc.dart';
import '../../../states/writing_card/writingcard_event.dart';
import '../../../states/writing_card/writingcard_selector.dart';
import '../../../states/writing_card/writingcard_state.dart';
import '../../widgets/card_refresh_control.dart';

part 'sections/writing_grid.dart';

class WritingScreen extends StatefulWidget {
  const WritingScreen();

  @override
  State<StatefulWidget> createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  @override
  Widget build(BuildContext context) {
    return PokeballBackground(
      child: Stack(
        children: [
          _WritingGrid(),
          // _FabMenu(),
        ],
      ),
    );
  }
}
