import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/recommend/my_recommend_model.dart';
import 'package:mybrary/data/network/api.dart';
import 'package:mybrary/data/provider/common/dio_provider.dart';
import 'package:retrofit/retrofit.dart';

part 'recommend_repository.g.dart';

final recommendRepositoryProvider = Provider<RecommendRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = RecommendRepository(dio, baseUrl: bookServiceUrl);

  return repository;
});

@RestApi()
abstract class RecommendRepository {
  factory RecommendRepository(Dio dio, {String baseUrl}) = _RecommendRepository;

  @POST('/recommendation-feeds')
  @Headers({
    'Content-Type': 'application/json',
  })
  Future<CommonModel>? createRecommendFeed({
    @Header('User-Id') required String userId,
    @Body() required MyRecommendModel body,
    required BuildContext context,
  });
}
