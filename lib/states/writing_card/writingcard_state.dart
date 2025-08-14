import 'package:mocard/domain/entities/card.dart';

enum WritingCardStateStatus {
  initial,
  loading,
  loadSuccess,
  loadFailure,
  loadingMore,
  loadMoreSuccess,
  loadMoreFailure,
}

class WritingCardState {
  final WritingCardStateStatus status;
  final List<Card> cards;
  final int selectedCardIndex;
  final int page;
  final Exception? error;
  final bool canLoadMore;

  Card get selectedCard => cards[selectedCardIndex];

  const WritingCardState._({
    this.status = WritingCardStateStatus.initial,
    this.cards = const [],
    this.selectedCardIndex = 0,
    this.page = 1,
    this.canLoadMore = true,
    this.error,
  });

  const WritingCardState.initial() : this._();

  WritingCardState asLoading() {
    return copyWith(
      status: WritingCardStateStatus.loading,
    );
  }

  WritingCardState asLoadSuccess(List<Card> cards, {bool canLoadMore = true}) {
    return copyWith(
      status: WritingCardStateStatus.loadSuccess,
      cards: cards,
      page: 1,
      canLoadMore: canLoadMore,
    );
  }

  WritingCardState asLoadFailure(Exception e) {
    return copyWith(
      status: WritingCardStateStatus.loadFailure,
      error: e,
    );
  }

  WritingCardState asLoadingMore() {
    return copyWith(status: WritingCardStateStatus.loadingMore);
  }

  WritingCardState asLoadMoreSuccess(List<Card> newCards, {bool canLoadMore = true}) {
    return copyWith(
      status: WritingCardStateStatus.loadMoreSuccess,
      cards: [...cards, ...newCards],
      page: canLoadMore ? page + 1 : page,
      canLoadMore: canLoadMore,
    );
  }

  WritingCardState asLoadMoreFailure(Exception e) {
    return copyWith(
      status: WritingCardStateStatus.loadMoreFailure,
      error: e,
    );
  }

  WritingCardState copyWith({
    WritingCardStateStatus? status,
    List<Card>? cards,
    int? selectedCardIndex,
    int? page,
    bool? canLoadMore,
    Exception? error,
  }) {
    return WritingCardState._(
      status: status ?? this.status,
      cards: cards ?? this.cards,
      selectedCardIndex: selectedCardIndex ?? this.selectedCardIndex,
      page: page ?? this.page,
      canLoadMore: canLoadMore ?? this.canLoadMore,
      error: error ?? this.error,
    );
  }
}
