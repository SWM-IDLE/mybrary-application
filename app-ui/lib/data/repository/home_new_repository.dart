import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/home/today_registered_book_count_model.dart';
import 'package:mybrary/data/network/api.dart';
import 'package:mybrary/data/provider/dio_provider.dart';
import 'package:retrofit/retrofit.dart';

part 'home_new_repository.g.dart';

final homeRepositoryProvider = Provider<HomeNewRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = HomeNewRepository(dio, baseUrl: bookServiceUrl);

  return repository;
});

@RestApi()
abstract class HomeNewRepository {
  factory HomeNewRepository(Dio dio, {String baseUrl}) = _HomeNewRepository;

  @GET('/mybooks/today-registration-count')
  @Headers({
    'Authorization':
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJBY2Nlc3NUb2tlbiIsImxvZ2luSWQiOiIxYTI0MGYzZC05MjQyLTQ0NjEtYjlhNC1kOTAwNTJmZjlkYzciLCJleHAiOjE2OTQxNTQzNzJ9.YX-uiA1tUiV0BrrSwi9tysr30BTGT_WEPaP5ECdoR9Vda4lGGU54zifb6cdLhJTwNtd7VXoEb2aC4urbWx05fg',
  })
  Future<CommonModel<TodayRegisteredBookCountModel>>
      getTodayRegisteredBookCount();
}
