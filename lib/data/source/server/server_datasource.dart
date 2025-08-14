import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mocard/core/network.dart';
import 'package:mocard/data/source/server/models/fewshot.dart';

import '../../../utils/locator.dart';
import 'models/card.dart';

class ServerDataSource {
  static const String cardListUrl = 'setting/cardList?cardType=';

  static const String userFewshotUrl = 'user/fewshotHistory';

  static const String getLimitUrl = 'user/getLimit';

  static const String deleteFewshotHistoryUrl = 'user/deleteFewshotHistory';

  static const String getCardUrl = 'setting/getCard?cardId=';

  static const String fewshotSampleUrl = 'setting/fewshotSample';

  static const String createOrderUrl = 'purchase/createOrder';

  static const String handleReceiptUrl = 'purchase/handleReceipt';

  Future<List<ServerCardModel>> getCards({required String type}) async {
    String cardListUrlWithType = cardListUrl + type;
    final response =
        await locator<NetworkManager>().request(RequestMethod.get, cardListUrlWithType);
    final List<dynamic> jsonData = response.data['data'];
    final List<ServerCardModel> data =
        jsonData.map((item) => ServerCardModel.fromJson(item as Map<String, dynamic>)).toList();
    return data;
  }

  Future<ServerCardModel> getCard({required String cardId}) async {
    String getCardUrlWithType = getCardUrl + cardId;
    final response = await locator<NetworkManager>().request(RequestMethod.get, getCardUrlWithType);
    final dynamic jsonData = response.data['data'];
    final ServerCardModel data = ServerCardModel.fromJson(jsonData);
    return data;
  }

  Future<List<FewshotModel>> fewshotHistory() async {
    final response = await locator<NetworkManager>().request(RequestMethod.get, userFewshotUrl);
    final List<dynamic> jsonData = response.data['data'] ?? [];
    final List<FewshotModel> data =
        jsonData.map((item) => FewshotModel.fromJson(item as Map<String, dynamic>)).toList();
    return data;
  }

  Future<List<FewshotModel>> fewshotSample() async {
    final response = await locator<NetworkManager>().request(RequestMethod.get, fewshotSampleUrl);
    final List<dynamic> jsonData = response.data['data'] ?? [];
    final List<FewshotModel> data =
        jsonData.map((item) => FewshotModel.fromJson(item as Map<String, dynamic>)).toList();
    return data;
  }

  Future<void> deleteFewshotHistory() async {
    await locator<NetworkManager>().request(RequestMethod.get, deleteFewshotHistoryUrl);
  }

  Future<dynamic> getLimit() async {
    final response = await locator<NetworkManager>().request(RequestMethod.get, getLimitUrl);
    final dynamic jsonData = response.data['data'];
    return jsonData;
  }

  Future<dynamic> createOrder({required String orderType}) async {
    final response =
        await locator<NetworkManager>().request(RequestMethod.post, createOrderUrl, data: {
      'orderType': orderType,
    });
    final dynamic jsonData = response.data['data'];
    return jsonData;
  }

  Future<dynamic> handleReceipt(
      {required String productId,
      required String transactionId,
      required String receipt,
      required int orderId,
      required String purchaseStatus}) async {
    final response =
        await locator<NetworkManager>().request(RequestMethod.post, handleReceiptUrl, data: {
      'productId': productId,
      'transactionId': transactionId,
      'receipt': receipt,
      'orderId': orderId,
      'purchaseStatus': purchaseStatus
    });
    final dynamic jsonData = response.data['data'];
    return jsonData;
  }
}
