import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/search/book_detail_user_infos_model.dart';
import 'package:mybrary/data/model/search/book_recommendation_feed_users_model.dart';
import 'package:mybrary/data/network/api.dart';
import 'package:mybrary/data/provider/common/dio_provider.dart';
import 'package:retrofit/http.dart';

part 'search_new_repository.g.dart';

final searchBookServiceRepositoryProvider =
    Provider<SearchNewRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = SearchNewRepository(dio, baseUrl: bookServiceUrl);

  return repository;
});

@RestApi()
abstract class SearchNewRepository {
  factory SearchNewRepository(Dio dio, {String baseUrl}) = _SearchNewRepository;

  @GET('/books/{isbn13}/interest/userInfos')
  Future<CommonModel<BookDetailUserInfosModel>> getInterestBookUserInfos({
    @Path('isbn13') required String? isbn13,
  });

  @GET('/books/{isbn13}/read-complete/userInfos')
  Future<CommonModel<BookDetailUserInfosModel>> getReadCompleteBookUserInfos({
    @Path('isbn13') required String? isbn13,
  });

  @GET('/books/{isbn13}/mybook/userInfos')
  Future<CommonModel<BookDetailUserInfosModel>> getMyBookUserInfos({
    @Path('isbn13') required String? isbn13,
  });

  @GET('/books/{isbn13}/recommendation-feeds/userInfos')
  Future<CommonModel<BookRecommendationFeedUsersModel>>
      getRecommendationFeedsUserInfos({
    @Path('isbn13') required String? isbn13,
  });
}
