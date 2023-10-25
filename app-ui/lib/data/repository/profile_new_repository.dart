import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mybrary/data/model/common/common_model.dart';
import 'package:mybrary/data/model/profile/profile_email_model.dart';
import 'package:mybrary/data/network/api.dart';
import 'package:mybrary/data/provider/common/dio_provider.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_new_repository.g.dart';

final profileRepositoryProvider = Provider<ProfileNewRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = ProfileNewRepository(dio, baseUrl: userServiceUrl);

  return repository;
});

@RestApi()
abstract class ProfileNewRepository {
  factory ProfileNewRepository(Dio dio, {String baseUrl}) =
      _ProfileNewRepository;

  @GET('/users/{userId}/profile/email')
  Future<CommonModel<ProfileEmailModel>> getUserEmail({
    @Path('userId') required String? userId,
  });
}
