// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mocard/configs/colors.dart';
import 'package:mocard/data/categories.dart';
import 'package:mocard/data/repositories/fewshot_repository.dart';
import 'package:mocard/domain/entities/category.dart';
import 'package:mocard/domain/entities/fewshot.dart';
import 'package:mocard/ui/widgets/pokeball_background.dart';
import 'package:mocard/routes.dart';
import 'package:mocard/utils/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../states/learning_card/learningcard_bloc.dart';
import '../../../states/learning_card/learningcard_state.dart';
import '../../../states/life_card/lifecard_bloc.dart';
import '../../../states/life_card/lifecard_state.dart';
import '../../../states/working_card/workingcard_bloc.dart';
import '../../../states/working_card/workingcard_state.dart';
import '../../../states/writing_card/writingcard_bloc.dart';
import '../../../states/writing_card/writingcard_event.dart' as writingcardEvent;
import '../../../states/working_card/workingcard_event.dart' as workingcardEvent;
import '../../../states/learning_card/learningcard_event.dart' as learningcardEvent;
import '../../../states/life_card/lifecard_event.dart' as lifecardEvent;

import '../../../states/theme/theme_cubit.dart';
import '../../../states/writing_card/writingcard_state.dart';
import 'widgets/fewshot_card.dart';
import 'widgets/category_card.dart';

part 'sections/fewshot_history.dart';
part 'sections/header_card_content.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  bool showTitle = false;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);

    super.initState();
  }

  @override
  void dispose() {
    if (_scrollController != null) {
      _scrollController.dispose();
    }

    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final offset = _scrollController.offset;
    final showTitle = offset > _HeaderCardContent.height - kToolbarHeight;

    // Prevent unneccesary rebuild
    if (this.showTitle == showTitle) return;

    setState(() {
      this.showTitle = showTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            expandedHeight: _HeaderCardContent.height,
            floating: true,
            pinned: true,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            backgroundColor: AppColors.red,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              centerTitle: true,
              title: Visibility(
                visible: showTitle,
                child: Text(
                  'Mocard',
                  style: Theme.of(context)
                      .appBarTheme
                      .toolbarTextStyle
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              background: _HeaderCardContent(),
            ),
          ),
        ],
        body: _FewshotHistory(),
      ),
    );
  }
}
