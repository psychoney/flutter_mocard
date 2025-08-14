import '../../../domain/entities/fewshot.dart';
import '../server/models/fewshot.dart';

extension FewshotModelX on FewshotModel {
  Fewshot toEntity() => Fewshot(
      uid: uid,
      deviceId: deviceId,
      cardId: cardId,
      imageUrl: imageUrl,
      question: question,
      answer: answer,
      type: type,
      createTime: createTime);
}
