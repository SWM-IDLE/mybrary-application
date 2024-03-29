// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_new_repository.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _SearchNewRepository implements SearchNewRepository {
  _SearchNewRepository(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<CommonModel<BookDetailUserInfosModel>> getInterestBookUserInfos(
      {isbn13}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommonModel<BookDetailUserInfosModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/books/${isbn13}/interest/userInfos',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommonModel<BookDetailUserInfosModel>.fromJson(
      _result.data!,
      (json) => BookDetailUserInfosModel.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<CommonModel<BookDetailUserInfosModel>> getReadCompleteBookUserInfos(
      {isbn13}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommonModel<BookDetailUserInfosModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/books/${isbn13}/read-complete/userInfos',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommonModel<BookDetailUserInfosModel>.fromJson(
      _result.data!,
      (json) => BookDetailUserInfosModel.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<CommonModel<BookDetailUserInfosModel>> getMyBookUserInfos(
      {isbn13}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommonModel<BookDetailUserInfosModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/books/${isbn13}/mybook/userInfos',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommonModel<BookDetailUserInfosModel>.fromJson(
      _result.data!,
      (json) => BookDetailUserInfosModel.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  @override
  Future<CommonModel<BookRecommendationFeedUsersModel>>
      getRecommendationFeedsUserInfos({isbn13}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommonModel<BookRecommendationFeedUsersModel>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/books/${isbn13}/recommendation-feeds/userInfos',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommonModel<BookRecommendationFeedUsersModel>.fromJson(
      _result.data!,
      (json) => BookRecommendationFeedUsersModel.fromJson(
          json as Map<String, dynamic>),
    );
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
