import 'package:mocard/data/source/local/models/card.dart';
import 'package:mocard/domain/entities/card.dart';

extension CardHiveModelX on CardHiveModel {
  Card toEntity({List<CardHiveModel> evolutions = const []}) => Card(
      id: number.trim(),
      title: title.trim(),
      description: description.trim(),
      demo: demo,
      imgUrl: imgUrl.trim(),
      role: role,
      type: type.trim(),
      color: color.trim());
}
