import 'package:mocard/domain/entities/card.dart';

enum LifeCardStateStatus {
  initial,
  loading,
  loadSuccess,
  loadFailure,
  loadingMore,
  loadMoreSuccess,
  loadMoreFailure,
}

class LifeCardState {
  final LifeCardStateStatus status;
  final List<Card> cards;
  final int selectedCardIndex;
  final int page;
  final Exception? error;
  final bool canLoadMore;

  Card get selectedCard => cards[selectedCardIndex];

  const LifeCardState._({
    this.status = LifeCardStateStatus.initial,
    this.cards = const [],
    this.selectedCardIndex = 0,
    this.page = 1,
    this.canLoadMore = true,
    this.error,
  });

  const LifeCardState.initial() : this._();

  LifeCardState asLoading() {
    return copyWith(
      status: LifeCardStateStatus.loading,
    );
  }

  LifeCardState asLoadSuccess(List<Card> cards, {bool canLoadMore = true}) {
    return copyWith(
      status: LifeCardStateStatus.loadSuccess,
      cards: cards,
      page: 1,
      canLoadMore: canLoadMore,
    );
  }

  LifeCardState asLoadFailure(Exception e) {
    return copyWith(
      status: LifeCardStateStatus.loadFailure,
      error: e,
    );
  }

  LifeCardState asLoadingMore() {
    return copyWith(status: LifeCardStateStatus.loadingMore);
  }

  LifeCardState asLoadMoreSuccess(List<Card> newCards, {bool canLoadMore = true}) {
    return copyWith(
      status: LifeCardStateStatus.loadMoreSuccess,
      cards: [...cards, ...newCards],
      page: canLoadMore ? page + 1 : page,
      canLoadMore: canLoadMore,
    );
  }

  LifeCardState asLoadMoreFailure(Exception e) {
    return copyWith(
      status: LifeCardStateStatus.loadMoreFailure,
      error: e,
    );
  }

  LifeCardState copyWith({
    LifeCardStateStatus? status,
    List<Card>? cards,
    int? selectedCardIndex,
    int? page,
    bool? canLoadMore,
    Exception? error,
  }) {
    return LifeCardState._(
      status: status ?? this.status,
      cards: cards ?? this.cards,
      selectedCardIndex: selectedCardIndex ?? this.selectedCardIndex,
      page: page ?? this.page,
      canLoadMore: canLoadMore ?? this.canLoadMore,
      error: error ?? this.error,
    );
  }
}
