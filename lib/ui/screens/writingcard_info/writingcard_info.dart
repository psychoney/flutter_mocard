import 'dart:math';

import 'package:flutter/material.dart' hide AnimatedSlide;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocard/configs/images.dart';
import 'package:mocard/domain/entities/card.dart' as mocard;
import 'package:mocard/ui/screens/writingcard_info/state_provider.dart';

import 'package:mocard/ui/widgets/animated_fade.dart';
import 'package:mocard/ui/widgets/animated_slide.dart';
import 'package:mocard/ui/widgets/auto_slideup_panel.dart';
import 'package:mocard/ui/widgets/card_app.dart';
import 'package:mocard/ui/widgets/hero.dart';
import 'package:mocard/ui/widgets/main_app_bar.dart';
import 'package:mocard/ui/widgets/main_tab_view.dart';

import '../../../states/writing_card/writingcard_bloc.dart';
import '../../../states/writing_card/writingcard_event.dart';
import '../../../states/writing_card/writingcard_selector.dart';
import '../../widgets/card_chat.dart';
import '../../widgets/card_image.dart';

part 'sections/background_decoration.dart';
part 'sections/card_overall_info.dart';
part 'sections/card_info_card.dart';

class WritingCardInfoScreen extends StatefulWidget {
  @override
  _CardInfoState createState() => _CardInfoState();
}

class _CardInfoState extends State<WritingCardInfoScreen> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _rotateController;

  @override
  void initState() {
    _slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _rotateController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 5000),
    )..repeat();

    super.initState();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _rotateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WritingCardInfoStateProvider(
      slideController: _slideController,
      rotateController: _rotateController,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _BackgroundDecoration(),
            _CardInfoCard(),
            MediaQuery.of(context).viewInsets.bottom == 0 ? _CardOverallInfo() : Container(),
          ],
        ),
      ),
    );
  }
}
