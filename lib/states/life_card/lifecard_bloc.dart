import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocard/states/life_card/lifecard_event.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../data/repositories/card_repository.dart';
import 'lifecard_state.dart';

class LifeCardBloc extends Bloc<LifeCardEvent, LifeCardState> {
  static const int lifecardsPerPage = 50;

  final CardRepository _lifecardRepository;

  LifeCardBloc(this._lifecardRepository) : super(LifeCardState.initial()) {
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

  void _onLoadStarted(CardLoadStarted event, Emitter<LifeCardState> emit) async {
    try {
      emit(state.asLoading());

      final lifecards = event.loadAll
          ? await _lifecardRepository.getAllCards()
          : await _lifecardRepository.getCardsByType(type: "LIFE");

      final canLoadMore = lifecards.length >= lifecardsPerPage;

      emit(state.asLoadSuccess(lifecards, canLoadMore: canLoadMore));
    } on Exception catch (e) {
      emit(state.asLoadFailure(e));
    }
  }

  void _onLoadMoreStarted(CardLoadMoreStarted event, Emitter<LifeCardState> emit) async {
    try {
      if (!state.canLoadMore) return;

      emit(state.asLoadingMore());

      final lifecards = await _lifecardRepository.getCardsByType(
        type: "LIFE",
      );

      final canLoadMore = lifecards.length >= lifecardsPerPage;

      emit(state.asLoadMoreSuccess(lifecards, canLoadMore: canLoadMore));
    } on Exception catch (e) {
      emit(state.asLoadMoreFailure(e));
    }
  }

  void _onSelectChanged(CardSelectChanged event, Emitter<LifeCardState> emit) async {
    if (state.cards.isEmpty) {
      final cards = await _lifecardRepository.getCardsByType(type: "LIFE");
      emit(state.asLoadSuccess(cards));
    }
    try {
      final lifecardIndex = state.cards.indexWhere(
        (lifecard) => lifecard.id == event.cardId,
      );

      if (lifecardIndex < 0 || lifecardIndex >= state.cards.length) return;

      // final lifecard = await _lifecardRepository.getCard(cardId: event.cardId);

      // if (lifecard == null) return;

      emit(state.copyWith(
        // cards: state.cards..setAll(lifecardIndex, [lifecard]),
        selectedCardIndex: lifecardIndex,
      ));
    } on Exception catch (e) {
      emit(state.asLoadMoreFailure(e));
    }
  }

  void _onSelectFewshot(CardSelectFewshot event, Emitter<LifeCardState> emit) async {
    try {
      final cards = await _lifecardRepository.getCardsByType(type: "LIFE");
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
