class Fewshot {
  const Fewshot(
      {required this.uid,
      required this.deviceId,
      required this.cardId,
      required this.imageUrl,
      required this.question,
      required this.answer,
      required this.type,
      required this.createTime});

  final String uid;
  final String deviceId;
  final String cardId;
  final String imageUrl;
  final String question;
  final String answer;
  final String type;
  final DateTime createTime;
}
