import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/recommend/my_recommend_feed_model.dart';
import 'package:mybrary/data/model/recommend/my_recommend_model.dart';
import 'package:mybrary/data/model/recommend/recommend_feed_model.dart';
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

  @GET('/recommendation-feeds')
  Future<CommonModel<RecommendFeedModel>> getRecommendFeedList({
    @Header('User-Id') required String userId,
    @Query('cursor') int? cursor,
    @Query('limit') int? limit,
  });

  @POST('/recommendation-feeds')
  @Headers({
    'Content-Type': 'application/json',
  })
  Future<CommonModel>? createRecommendFeed({
    @Header('User-Id') required String userId,
    @Body() required MyRecommendModel body,
    required BuildContext context,
  });

  @PUT('/recommendation-feeds/{id}')
  @Headers({
    'Content-Type': 'application/json',
  })
  Future<CommonModel>? updateRecommendFeed({
    @Header('User-Id') required String userId,
    @Path('id') required int recommendationFeedId,
    @Body() required MyRecommendPostDataModel body,
    required BuildContext context,
  });

  @GET('/recommendation-feeds/{userId}')
  Future<CommonModel<MyRecommendFeedModel>> getMyRecommendPostList({
    @Path('userId') required String userId,
  });

  @GET('/mybooks/{myBookId}/recommendation-feed')
  Future<CommonModel<MyRecommendPostModel>> getMyRecommendPost({
    @Path('myBookId') required int myBookId,
  });
}
