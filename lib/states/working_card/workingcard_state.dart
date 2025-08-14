import 'package:mocard/domain/entities/card.dart';

enum WorkingCardStateStatus {
  initial,
  loading,
  loadSuccess,
  loadFailure,
  loadingMore,
  loadMoreSuccess,
  loadMoreFailure,
}

class WorkingCardState {
  final WorkingCardStateStatus status;
  final List<Card> cards;
  final int selectedCardIndex;
  final int page;
  final Exception? error;
  final bool canLoadMore;

  Card get selectedCard => cards[selectedCardIndex];

  const WorkingCardState._({
    this.status = WorkingCardStateStatus.initial,
    this.cards = const [],
    this.selectedCardIndex = 0,
    this.page = 1,
    this.canLoadMore = true,
    this.error,
  });

  const WorkingCardState.initial() : this._();

  WorkingCardState asLoading() {
    return copyWith(
      status: WorkingCardStateStatus.loading,
    );
  }

  WorkingCardState asLoadSuccess(List<Card> cards, {bool canLoadMore = true}) {
    return copyWith(
      status: WorkingCardStateStatus.loadSuccess,
      cards: cards,
      page: 1,
      canLoadMore: canLoadMore,
    );
  }

  WorkingCardState asLoadFailure(Exception e) {
    return copyWith(
      status: WorkingCardStateStatus.loadFailure,
      error: e,
    );
  }

  WorkingCardState asLoadingMore() {
    return copyWith(status: WorkingCardStateStatus.loadingMore);
  }

  WorkingCardState asLoadMoreSuccess(List<Card> newCards, {bool canLoadMore = true}) {
    return copyWith(
      status: WorkingCardStateStatus.loadMoreSuccess,
      cards: [...cards, ...newCards],
      page: canLoadMore ? page + 1 : page,
      canLoadMore: canLoadMore,
    );
  }

  WorkingCardState asLoadMoreFailure(Exception e) {
    return copyWith(
      status: WorkingCardStateStatus.loadMoreFailure,
      error: e,
    );
  }

  WorkingCardState copyWith({
    WorkingCardStateStatus? status,
    List<Card>? cards,
    int? selectedCardIndex,
    int? page,
    bool? canLoadMore,
    Exception? error,
  }) {
    return WorkingCardState._(
      status: status ?? this.status,
      cards: cards ?? this.cards,
      selectedCardIndex: selectedCardIndex ?? this.selectedCardIndex,
      page: page ?? this.page,
      canLoadMore: canLoadMore ?? this.canLoadMore,
      error: error ?? this.error,
    );
  }
}
