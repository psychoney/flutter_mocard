abstract class WritingCardEvent {
  const WritingCardEvent();
}

class CardLoadStarted extends WritingCardEvent {
  final bool loadAll;
  const CardLoadStarted({this.loadAll = false});
}

class CardLoadMoreStarted extends WritingCardEvent {
  const CardLoadMoreStarted();
}

class CardSelectChanged extends WritingCardEvent {
  final String cardId;

  const CardSelectChanged({required this.cardId});
}

class CardSelectFewshot extends WritingCardEvent {
  final String cardId;
  const CardSelectFewshot({required this.cardId});
}
