import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocard/states/working_card/workingcard_event.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../data/repositories/card_repository.dart';
import 'workingcard_state.dart';

class WorkingCardBloc extends Bloc<WorkingCardEvent, WorkingCardState> {
  static const int workingcardsPerPage = 50;

  final CardRepository _workingcardRepository;

  WorkingCardBloc(this._workingcardRepository) : super(WorkingCardState.initial()) {
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

  void _onLoadStarted(CardLoadStarted event, Emitter<WorkingCardState> emit) async {
    try {
      emit(state.asLoading());

      final workingcards = event.loadAll
          ? await _workingcardRepository.getAllCards()
          : await _workingcardRepository.getCardsByType(type: "WORKING");

      final canLoadMore = workingcards.length >= workingcardsPerPage;

      emit(state.asLoadSuccess(workingcards, canLoadMore: canLoadMore));
    } on Exception catch (e) {
      emit(state.asLoadFailure(e));
    }
  }

  void _onLoadMoreStarted(CardLoadMoreStarted event, Emitter<WorkingCardState> emit) async {
    try {
      if (!state.canLoadMore) return;

      emit(state.asLoadingMore());

      final workingcards = await _workingcardRepository.getCardsByType(type: "WORKING");

      final canLoadMore = workingcards.length >= workingcardsPerPage;

      emit(state.asLoadMoreSuccess(workingcards, canLoadMore: canLoadMore));
    } on Exception catch (e) {
      emit(state.asLoadMoreFailure(e));
    }
  }

  void _onSelectChanged(CardSelectChanged event, Emitter<WorkingCardState> emit) async {
    try {
      final workingcardIndex = state.cards.indexWhere(
        (workingcard) => workingcard.id == event.cardId,
      );

      if (workingcardIndex < 0 || workingcardIndex >= state.cards.length) return;

      // final workingcard = await _workingcardRepository.getCard(cardId: event.cardId);

      // if (workingcard == null) return;

      emit(state.copyWith(
        // cards: state.cards..setAll(workingcardIndex, [workingcard]),
        selectedCardIndex: workingcardIndex,
      ));
    } on Exception catch (e) {
      emit(state.asLoadMoreFailure(e));
    }
  }

  void _onSelectFewshot(CardSelectFewshot event, Emitter<WorkingCardState> emit) async {
    try {
      final cards = await _workingcardRepository.getCardsByType(type: "WORKING");
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
