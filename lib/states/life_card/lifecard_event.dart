abstract class LifeCardEvent {
  const LifeCardEvent();
}

class CardLoadStarted extends LifeCardEvent {
  final bool loadAll;
  const CardLoadStarted({this.loadAll = false});
}

class CardLoadMoreStarted extends LifeCardEvent {
  const CardLoadMoreStarted();
}

class CardSelectChanged extends LifeCardEvent {
  final String cardId;

  const CardSelectChanged({required this.cardId});
}

class CardSelectFewshot extends LifeCardEvent {
  final String cardId;
  const CardSelectFewshot({required this.cardId});
}
