import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:mocard/core/utils.dart';

class NetworkManager {
  final Dio dio;

  static String? token;

  static String? baseUrl;

  const NetworkManager._(this.dio);

  factory NetworkManager({String? baseUrl, String? token}) {
    final dio = Dio();

    dio.options.baseUrl = (baseUrl ?? NetworkManager.baseUrl)!;

    // dio.interceptors.add(DioCacheManager(CacheConfig(
    //   defaultMaxAge: Duration(days: 10),
    //   maxMemoryCacheCount: 3,
    // )).interceptor);
    if (token != null) {
      dio.options.headers['access-token'] = token;
    }

    return NetworkManager._(dio);
  }

  static void initialize({required String baseUrl}) {
    NetworkManager.baseUrl = baseUrl;
  }

  void updateToken(String newToken) {
    NetworkManager.token = newToken;
  }

  Future<Response<T>> request<T>(
    RequestMethod method,
    String url, {
    data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) {
    headers = headers ?? {};
    if (token != null) {
      headers['access-token'] = token;
    }
    return dio.request(
      url,
      data: data,
      queryParameters: queryParameters,
      options: Options(
        method: method.value,
        headers: headers,
      ),
    );
  }
}

enum RequestMethod {
  get,
  head,
  post,
  put,
  delete,
  connect,
  options,
  trace,
  patch,
}

extension RequestMethodX on RequestMethod {
  String get value => getEnumValue(this).toUpperCase();
}
