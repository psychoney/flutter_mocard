import 'package:mocard/domain/entities/card.dart';

enum LearningCardStateStatus {
  initial,
  loading,
  loadSuccess,
  loadFailure,
  loadingMore,
  loadMoreSuccess,
  loadMoreFailure,
}

class LearningCardState {
  final LearningCardStateStatus status;
  final List<Card> cards;
  final int selectedCardIndex;
  final int page;
  final Exception? error;
  final bool canLoadMore;

  Card get selectedCard => cards[selectedCardIndex];

  const LearningCardState._({
    this.status = LearningCardStateStatus.initial,
    this.cards = const [],
    this.selectedCardIndex = 0,
    this.page = 1,
    this.canLoadMore = true,
    this.error,
  });

  const LearningCardState.initial() : this._();

  LearningCardState asLoading() {
    return copyWith(
      status: LearningCardStateStatus.loading,
    );
  }

  LearningCardState asLoadSuccess(List<Card> cards, {bool canLoadMore = true}) {
    return copyWith(
      status: LearningCardStateStatus.loadSuccess,
      cards: cards,
      page: 1,
      canLoadMore: canLoadMore,
    );
  }

  LearningCardState asLoadFailure(Exception e) {
    return copyWith(
      status: LearningCardStateStatus.loadFailure,
      error: e,
    );
  }

  LearningCardState asLoadingMore() {
    return copyWith(status: LearningCardStateStatus.loadingMore);
  }

  LearningCardState asLoadMoreSuccess(List<Card> newCards, {bool canLoadMore = true}) {
    return copyWith(
      status: LearningCardStateStatus.loadMoreSuccess,
      cards: [...cards, ...newCards],
      page: canLoadMore ? page + 1 : page,
      canLoadMore: canLoadMore,
    );
  }

  LearningCardState asLoadMoreFailure(Exception e) {
    return copyWith(
      status: LearningCardStateStatus.loadMoreFailure,
      error: e,
    );
  }

  LearningCardState copyWith({
    LearningCardStateStatus? status,
    List<Card>? cards,
    int? selectedCardIndex,
    int? page,
    bool? canLoadMore,
    Exception? error,
  }) {
    return LearningCardState._(
      status: status ?? this.status,
      cards: cards ?? this.cards,
      selectedCardIndex: selectedCardIndex ?? this.selectedCardIndex,
      page: page ?? this.page,
      canLoadMore: canLoadMore ?? this.canLoadMore,
      error: error ?? this.error,
    );
  }
}
