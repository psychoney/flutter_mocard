import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocard/states/learning_card/learningcard_event.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../data/repositories/card_repository.dart';
import 'learningcard_state.dart';

class LearningCardBloc extends Bloc<LearningCardEvent, LearningCardState> {
  static const int learningcardsPerPage = 50;

  final CardRepository _learningcardRepository;

  LearningCardBloc(this._learningcardRepository) : super(LearningCardState.initial()) {
    on<CardLoadStarted>(
      _onLoadStarted,
      transformer: (events, mapper) => events.switchMap(mapper),
    );
    on<CardLoadMoreStarted>(
      _onLoadMoreStarted,
      transformer: (events, mapper) => events.switchMap(mapper),
    );
    on<CardSelectChanged>(_onSelectChanged);
    on<CardSelectFewshot>(_onSelectFewshot);
  }

  void _onLoadStarted(CardLoadStarted event, Emitter<LearningCardState> emit) async {
    try {
      emit(state.asLoading());

      final learningcards = event.loadAll
          ? await _learningcardRepository.getAllCards()
          : await _learningcardRepository.getCardsByType(type: "LEARNING");

      final canLoadMore = learningcards.length >= learningcardsPerPage;

      emit(state.asLoadSuccess(learningcards, canLoadMore: canLoadMore));
    } on Exception catch (e) {
      emit(state.asLoadFailure(e));
    }
  }

  void _onLoadMoreStarted(CardLoadMoreStarted event, Emitter<LearningCardState> emit) async {
    if (state.cards.isEmpty) {
      final cards = await _learningcardRepository.getCardsByType(type: "LEARNING");
      emit(state.asLoadSuccess(cards));
    }
    try {
      if (!state.canLoadMore) return;

      emit(state.asLoadingMore());

      final learningcards = await _learningcardRepository.getCardsByType(
        type: "LEARNING",
      );

      final canLoadMore = learningcards.length >= learningcardsPerPage;

      emit(state.asLoadMoreSuccess(learningcards, canLoadMore: canLoadMore));
    } on Exception catch (e) {
      emit(state.asLoadMoreFailure(e));
    }
  }

  void _onSelectChanged(CardSelectChanged event, Emitter<LearningCardState> emit) async {
    try {
      final learningcardIndex = state.cards.indexWhere(
        (learningcard) => learningcard.id == event.cardId,
      );

      if (learningcardIndex < 0 || learningcardIndex >= state.cards.length) return;

      // final learningcard = await _learningcardRepository.getCard(cardId: event.cardId);

      // if (learningcard == null) return;

      emit(state.copyWith(
        // cards: state.cards..setAll(learningcardIndex, [learningcard]),
        selectedCardIndex: learningcardIndex,
      ));
    } on Exception catch (e) {
      emit(state.asLoadMoreFailure(e));
    }
  }

  void _onSelectFewshot(CardSelectFewshot event, Emitter<LearningCardState> emit) async {
    try {
      final cards = await _learningcardRepository.getCardsByType(type: "LEARNING");
      emit(state.asLoadSuccess(cards));
      final index = state.cards.indexWhere(
        (card) => card.id == event.cardId,
      );
      if (index < 0 || index >= state.cards.length) return;
      emit(state.copyWith(
        selectedCardIndex: index,
      ));
    } on Exception catch (e) {
      emit(state.asLoadMoreFailure(e));
    }
  }
}
