import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/UserModel.dart';
part 'profile_auth.g.dart';

@RestApi()
abstract class ProfileAuth {
  factory ProfileAuth(Dio dio, {String baseUrl}) = _ProfileAuth;

  @GET('/users/profile')
  Future<Profile> fetchProfile(@Header("Authorization") String token);
}
