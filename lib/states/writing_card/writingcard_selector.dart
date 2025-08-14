import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocard/domain/entities/card.dart' as mocard;
import 'package:mocard/states/writing_card/writingcard_bloc.dart';
import 'package:mocard/states/writing_card/writingcard_state.dart';

class WritingCardStateSelector<T> extends BlocSelector<WritingCardBloc, WritingCardState, T> {
  WritingCardStateSelector({
    required T Function(WritingCardState) selector,
    required Widget Function(T) builder,
  }) : super(
          selector: selector,
          builder: (_, value) => builder(value),
        );
}

class CardStateStatusSelector extends WritingCardStateSelector<WritingCardStateStatus> {
  CardStateStatusSelector(Widget Function(WritingCardStateStatus) builder)
      : super(
          selector: (state) => state.status,
          builder: builder,
        );
}

class CardCanLoadMoreSelector extends WritingCardStateSelector<bool> {
  CardCanLoadMoreSelector(Widget Function(bool) builder)
      : super(
          selector: (state) => state.canLoadMore,
          builder: builder,
        );
}

class NumberOfCardsSelector extends WritingCardStateSelector<int> {
  NumberOfCardsSelector(Widget Function(int) builder)
      : super(
          selector: (state) => state.cards.length,
          builder: builder,
        );
}

class CurrentCardSelector extends WritingCardStateSelector<mocard.Card> {
  CurrentCardSelector(Widget Function(mocard.Card) builder)
      : super(
          selector: (state) => state.selectedCard,
          builder: builder,
        );
}

class CardSelector extends WritingCardStateSelector<CardSelectorState> {
  CardSelector(int index, Widget Function(mocard.Card, bool) builder)
      : super(
          selector: (state) => CardSelectorState(
            state.cards[index],
            state.selectedCardIndex == index,
          ),
          builder: (value) => builder(value.card, value.selected),
        );
}

class CardSelectorState {
  final mocard.Card card;
  final bool selected;

  const CardSelectorState(this.card, this.selected);

  @override
  bool operator ==(Object other) =>
      other is CardSelectorState && card == other.card && selected == other.selected;
}
