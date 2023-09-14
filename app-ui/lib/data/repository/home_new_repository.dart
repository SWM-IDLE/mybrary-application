import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/books_params.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/home/books_by_category_model.dart';
import 'package:mybrary/data/model/home/books_by_interest_model.dart';
import 'package:mybrary/data/model/home/today_registered_book_count_model.dart';
import 'package:mybrary/data/network/api.dart';
import 'package:mybrary/data/provider/common/dio_provider.dart';
import 'package:retrofit/retrofit.dart';

part 'home_new_repository.g.dart';

final homeBookServiceRepositoryProvider = Provider<HomeNewRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = HomeNewRepository(dio, baseUrl: bookServiceUrl);

  return repository;
});

final homeUserServiceRepositoryProvider = Provider<HomeNewRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = HomeNewRepository(dio, baseUrl: userServiceUrl);

  return repository;
});

@RestApi()
abstract class HomeNewRepository {
  factory HomeNewRepository(Dio dio, {String baseUrl}) = _HomeNewRepository;

  @GET('/mybooks/today-registration-count')
  Future<CommonModel<TodayRegisteredBookCountModel>>
      getTodayRegisteredBookCount();

  @GET('/books/recommendations')
  Future<CommonModel<BooksByCategoryModel>> getBooksByCategory({
    @Queries() BooksParams? booksParams = const BooksParams(
      type: 'Bestseller',
    ),
  });

  @GET('/interests/book-recommendations/{type}')
  Future<CommonModel<BooksByInterestModel>> getBooksByInterest({
    @Path('type') required String? type,
  });
}
