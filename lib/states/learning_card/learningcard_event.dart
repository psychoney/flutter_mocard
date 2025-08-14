abstract class LearningCardEvent {
  const LearningCardEvent();
}

class CardLoadStarted extends LearningCardEvent {
  final bool loadAll;
  const CardLoadStarted({this.loadAll = false});
}

class CardLoadMoreStarted extends LearningCardEvent {
  const CardLoadMoreStarted();
}

class CardSelectChanged extends LearningCardEvent {
  final String cardId;

  const CardSelectChanged({required this.cardId});
}

class CardSelectFewshot extends LearningCardEvent {
  final String cardId;
  const CardSelectFewshot({required this.cardId});
}
