import 'package:mocard/data/source/local/local_datasource.dart';
import 'package:mocard/data/source/mappers/server_to_local_mapper.dart';
import 'package:mocard/data/source/mappers/local_to_entity_mapper.dart';
import 'package:mocard/domain/entities/card.dart';

import '../source/server/server_datasource.dart';

abstract class CardRepository {
  Future<List<Card>> getAllCards();

  Future<List<Card>> getCardsByType({required String type});

  Future<Card?> getCard({required String cardId});
}

class CardDefaultRepository extends CardRepository {
  CardDefaultRepository({required this.serverDataSource, required this.localDataSource});

  final ServerDataSource serverDataSource;
  final LocalDataSource localDataSource;

  @override
  Future<List<Card>> getAllCards() async {
    final cardHiveModels = await localDataSource.getAllCards();

    final cardEntities = cardHiveModels.map((e) => e.toEntity()).toList();

    return cardEntities;
  }

  // @override
  // Future<List<Card>> getCards({required int limit, required int page, required type}) async {
  //   // await localDataSource.clearCards();
  //   final hasCachedData = await localDataSource.hasData();

  //   if (!hasCachedData) {
  //     print('getting cards from server');
  //     final cardServerModels = await serverDataSource.getCards(type: type);
  //     final cardHiveModels = cardServerModels.map((e) => e.toHiveModel());

  //     await localDataSource.saveCards(cardHiveModels);
  //   }
  //   print('getting cards from local');
  //   final cardHiveModels = await localDataSource.getCards(
  //     page: page,
  //     limit: limit,
  //   );
  //   final cardEntities = cardHiveModels.map((e) => e.toEntity()).toList();

  //   return cardEntities;
  // }

  @override
  Future<Card?> getCard({required String cardId}) async {
    print('getCard from server');
    final cardModel = await serverDataSource.getCard(cardId: cardId);
    if (cardModel == null) return null;
    final cardHiveModel = cardModel.toHiveModel();
    final card = cardHiveModel.toEntity();
    return card;
  }

  @override
  Future<List<Card>> getCardsByType({required String type}) async {
    print('getCardsByType from server');
    final cardServerModels = await serverDataSource.getCards(type: type);
    final cardHiveModels = cardServerModels.map((e) => e.toHiveModel());
    final cardEntities = cardHiveModels.map((e) => e.toEntity()).toList();

    return cardEntities;
  }
}
