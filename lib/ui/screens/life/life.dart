import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocard/configs/images.dart';
import 'package:mocard/routes.dart';

import 'package:mocard/ui/widgets/mo_card.dart';
import 'package:mocard/ui/widgets/main_app_bar.dart';
import 'package:mocard/ui/widgets/pokeball_background.dart';
import 'package:mocard/domain/entities/card.dart' as mocard;

import '../../../states/life_card/lifecard_bloc.dart';
import '../../../states/life_card/lifecard_event.dart';
import '../../../states/life_card/lifecard_selector.dart';
import '../../../states/life_card/lifecard_state.dart';
import '../../widgets/card_refresh_control.dart';

part 'sections/life_grid.dart';

class LifeScreen extends StatefulWidget {
  const LifeScreen();

  @override
  State<StatefulWidget> createState() => _LifeScreenState();
}

class _LifeScreenState extends State<LifeScreen> {
  @override
  Widget build(BuildContext context) {
    return PokeballBackground(
      child: Stack(
        children: [
          _LifeGrid(),
          // _FabMenu(),
        ],
      ),
    );
  }
}
