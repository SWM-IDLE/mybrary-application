import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mybrary/data/network/api.dart';
import 'package:mybrary/data/provider/common/secure_storage_provider.dart';
import 'package:mybrary/res/constants/config.dart';
import 'package:mybrary/res/variable/global_navigator_variable.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = ref.watch(dioSingletonProvider);

  final secureStorage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor(secureStorage: secureStorage, dio: dio),
  );

  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;
  final Dio dio;

  CustomInterceptor({
    required this.secureStorage,
    required this.dio,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await secureStorage.read(key: accessTokenKey);
    log("API 요청 경로: ${options.path}");

    options.headers[accessTokenHeaderKey] = 'Bearer $accessToken';

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("API 응답값: ${response.data}");

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    log("ERROR: Server 에러 코드 <${err.response?.statusCode}>");
    log("ERROR: Server 에러 메세지 <${err.response?.data.toString()}>");

    if (err.response?.statusCode == 401) {
      log('ERROR: Access 토큰 만료에 대한 서버 에러가 발생했습니다.');

      final accessToken = await secureStorage.read(key: accessTokenKey);
      final refreshToken = await secureStorage.read(key: refreshTokenKey);

      final context = GlobalNavigatorVariable.navigatorKey.currentContext!;

      dio.interceptors.clear();
      dio.interceptors.add(InterceptorsWrapper(onError: (err, handler) async {
        if (err.response?.statusCode == 401) {
          log('ERROR: Refresh 토큰 만료에 대한 서버 에러가 발생했습니다.');
          await secureStorage.deleteAll();

          if (!context.mounted) return;
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/signin',
            (Route<dynamic> route) => false,
          );
        }
        return handler.reject(err);
      }));

      dio.options.headers[accessTokenHeaderKey] =
          '$jwtHeaderBearer$accessToken';
      dio.options.headers[refreshTokenHeaderKey] =
          '$jwtHeaderBearer$refreshToken';

      final refreshResponse = await dio.get(
        getApi(API.getRefreshToken),
      );

      final newAccessToken = refreshResponse.headers[accessTokenHeaderKey]![0];
      final newRefreshToken =
          refreshResponse.headers[refreshTokenHeaderKey]![0];

      await secureStorage.write(key: accessTokenKey, value: newAccessToken);
      await secureStorage.write(key: refreshTokenKey, value: newRefreshToken);

      final options = err.requestOptions;

      options.headers[accessTokenHeaderKey] = '$jwtHeaderBearer$newAccessToken';

      final response = await dio.fetch(options);

      return handler.resolve(response);
    }
    return handler.reject(err);
  }
}
