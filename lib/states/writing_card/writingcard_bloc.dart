import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocard/states/writing_card/writingcard_event.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../data/repositories/card_repository.dart';
import 'writingcard_state.dart';

class WritingCardBloc extends Bloc<WritingCardEvent, WritingCardState> {
  static const int writingcardsPerPage = 50;

  final CardRepository _writingcardRepository;

  WritingCardBloc(this._writingcardRepository) : super(WritingCardState.initial()) {
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

  void _onLoadStarted(CardLoadStarted event, Emitter<WritingCardState> emit) async {
    try {
      emit(state.asLoading());

      final writingcards = event.loadAll
          ? await _writingcardRepository.getAllCards()
          : await _writingcardRepository.getCardsByType(type: "WRITING");

      final canLoadMore = writingcards.length >= writingcardsPerPage;

      emit(state.asLoadSuccess(writingcards, canLoadMore: canLoadMore));
    } on Exception catch (e) {
      emit(state.asLoadFailure(e));
    }
  }

  void _onLoadMoreStarted(CardLoadMoreStarted event, Emitter<WritingCardState> emit) async {
    try {
      if (!state.canLoadMore) return;

      emit(state.asLoadingMore());

      final writingcards = await _writingcardRepository.getCardsByType(
        type: "WRITING",
      );

      final canLoadMore = writingcards.length >= writingcardsPerPage;

      emit(state.asLoadMoreSuccess(writingcards, canLoadMore: canLoadMore));
    } on Exception catch (e) {
      emit(state.asLoadMoreFailure(e));
    }
  }

  void _onSelectChanged(CardSelectChanged event, Emitter<WritingCardState> emit) async {
    try {
      final writingcardIndex = state.cards.indexWhere(
        (writingcard) => writingcard.id == event.cardId,
      );

      if (writingcardIndex < 0 || writingcardIndex >= state.cards.length) return;

      // final writingcard = await _writingcardRepository.getCard(cardId: event.cardId);

      // if (writingcard == null) return;

      emit(state.copyWith(
        // cards: state.cards..setAll(writingcardIndex, [writingcard]),
        selectedCardIndex: writingcardIndex,
      ));
    } on Exception catch (e) {
      emit(state.asLoadMoreFailure(e));
    }
  }

  void _onSelectFewshot(CardSelectFewshot event, Emitter<WritingCardState> emit) async {
    try {
      final cards = await _writingcardRepository.getCardsByType(type: "WRITING");
      emit(state.asLoadSuccess(cards));
      final writingcardIndex = state.cards.indexWhere(
        (writingcard) => writingcard.id == event.cardId,
      );
      if (writingcardIndex < 0 || writingcardIndex >= state.cards.length) return;
      emit(state.copyWith(
        selectedCardIndex: writingcardIndex,
      ));
    } on Exception catch (e) {
      emit(state.asLoadMoreFailure(e));
    }
  }
}
