import 'package:mocard/data/source/local/models/card.dart';

import '../server/models/card.dart';

extension ServerCardModelToLocalX on ServerCardModel {
  CardHiveModel toHiveModel() => CardHiveModel()
    ..number = id.trim()
    ..title = title.trim()
    ..description = description.trim()
    ..role = role
    ..imgUrl = imageUrl.trim()
    ..demo = demo
    ..type = type.trim()
    ..color = color.trim();
}
