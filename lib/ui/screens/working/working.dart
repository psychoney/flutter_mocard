import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocard/configs/images.dart';
import 'package:mocard/routes.dart';

import 'package:mocard/ui/widgets/mo_card.dart';
import 'package:mocard/ui/widgets/main_app_bar.dart';
import 'package:mocard/ui/widgets/pokeball_background.dart';
import 'package:mocard/domain/entities/card.dart' as mocard;

import '../../../states/working_card/workingcard_bloc.dart';
import '../../../states/working_card/workingcard_event.dart';
import '../../../states/working_card/workingcard_selector.dart';
import '../../../states/working_card/workingcard_state.dart';
import '../../widgets/card_refresh_control.dart';

part 'sections/working_grid.dart';

class WorkingScreen extends StatefulWidget {
  const WorkingScreen();

  @override
  State<StatefulWidget> createState() => _WorkinngScreenState();
}

class _WorkinngScreenState extends State<WorkingScreen> {
  @override
  Widget build(BuildContext context) {
    return PokeballBackground(
      child: Stack(
        children: [
          _WorkingGrid(),
          // _FabMenu(),
        ],
      ),
    );
  }
}
