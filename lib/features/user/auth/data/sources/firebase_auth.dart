import 'package:retrofit/retrofit.dart';
import '../models/user_model.dart';
import 'package:dio/dio.dart';

part 'firebase_auth.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @GET('/users/getUser')
  Future<LoginedUser> getUser(@Header("Authorization") String token);

  @POST('/users/validateUser')
  Future<ValidateUserResponse> validateUser(@Body() Map<String, dynamic> body);

  @POST('/users/validateUserPhone')
  Future<ValidateUserResponse> validateUserPhone(
      @Body() Map<String, dynamic> body);
}
