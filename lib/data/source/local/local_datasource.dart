import 'dart:math';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocard/data/source/local/models/card.dart';

class LocalDataSource {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    Hive.registerAdapter<CardHiveModel>(CardHiveModelAdapter());

    await Hive.openBox<CardHiveModel>(CardHiveModel.boxKey);
  }

  Future<bool> hasData() async {
    final cardBox = Hive.box<CardHiveModel>(CardHiveModel.boxKey);

    return cardBox.length > 0;
  }

  Future<void> saveCards(Iterable<CardHiveModel> cards) async {
    final cardBox = Hive.box<CardHiveModel>(CardHiveModel.boxKey);

    final cardsMap = {for (var e in cards) e.number: e};

    await cardBox.clear();
    await cardBox.putAll(cardsMap);
  }

  Future<void> clearCards() async {
    final cardBox = Hive.box<CardHiveModel>(CardHiveModel.boxKey);
    await cardBox.clear();
  }

  Future<List<CardHiveModel>> getAllCards() async {
    final cardBox = Hive.box<CardHiveModel>(CardHiveModel.boxKey);

    final cards = List.generate(cardBox.length, (index) => cardBox.getAt(index))
        .whereType<CardHiveModel>()
        .toList();

    return cards;
  }

  Future<List<CardHiveModel>> getCards({required int page, required int limit}) async {
    final cardBox = Hive.box<CardHiveModel>(CardHiveModel.boxKey);
    final totalCards = cardBox.length;

    final start = (page - 1) * limit;
    final newCardCount = min(totalCards - start, limit);

    final cards = List.generate(newCardCount, (index) => cardBox.getAt(start + index))
        .whereType<CardHiveModel>()
        .toList();

    return cards;
  }

  Future<CardHiveModel?> getCard(String number) async {
    final cardBox = Hive.box<CardHiveModel>(CardHiveModel.boxKey);

    return cardBox.get(number);
  }
}
