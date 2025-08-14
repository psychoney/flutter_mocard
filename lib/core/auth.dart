import 'package:mocard/utils/locator.dart';

import 'network.dart';

class AuthService {
  static const String loginUrl = 'user/login';

  Future<String> login(String uniqueID) async {
    final response = await locator<NetworkManager>().request(
      RequestMethod.post,
      loginUrl,
      data: {
        'uniqueID': uniqueID,
      },
    );
    // 解析并返回token
    return response.data['data']['token'];
  }
}
