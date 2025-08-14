abstract class WorkingCardEvent {
  const WorkingCardEvent();
}

class CardLoadStarted extends WorkingCardEvent {
  final bool loadAll;
  const CardLoadStarted({this.loadAll = false});
}

class CardLoadMoreStarted extends WorkingCardEvent {
  const CardLoadMoreStarted();
}

class CardSelectChanged extends WorkingCardEvent {
  final String cardId;

  const CardSelectChanged({required this.cardId});
}

class CardSelectFewshot extends WorkingCardEvent {
  final String cardId;
  const CardSelectFewshot({required this.cardId});
}
