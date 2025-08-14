import '../../core/usecase.dart';
import '../../data/repositories/card_repository.dart';
import '../entities/card.dart';

class GetAllCardsUseCase extends NoParamsUseCase<List<Card>> {
  const GetAllCardsUseCase(this.repository);

  final CardRepository repository;

  @override
  Future<List<Card>> call() {
    return repository.getAllCards();
  }
}

class GetCardsParams {
  const GetCardsParams({
    required this.page,
    required this.limit,
    required this.type,
  });

  final int page;
  final int limit;
  final String type;
}

class GetCardsUseCase extends UseCase<List<Card>, GetCardsParams> {
  const GetCardsUseCase(this.repository);

  final CardRepository repository;

  @override
  Future<List<Card>> call(GetCardsParams params) {
    return repository.getCardsByType(type: params.type);
  }
}

class GetCardParam {
  final String number;

  const GetCardParam(this.number);
}

class GetCardUseCase extends UseCase<Card?, GetCardParam> {
  final CardRepository repository;

  const GetCardUseCase(this.repository);

  @override
  Future<Card?> call(GetCardParam params) {
    return repository.getCard(cardId: params.number);
  }
}
