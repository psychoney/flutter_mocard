import 'package:hive/hive.dart';

part 'card.g.dart';

@HiveType(typeId: 1)
class CardHiveModel extends HiveObject {
  static const String boxKey = 'card';

  @HiveField(0)
  late String number;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String description;

  @HiveField(3)
  late List<Map<String, dynamic>> role;

  @HiveField(4)
  late List<Map<String, dynamic>> demo;

  @HiveField(5)
  late String imgUrl;

  @HiveField(6)
  late String type;

  @HiveField(7)
  late String color;
}
