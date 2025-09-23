import 'package:myfirstapp/features/user/auth/data/models/user_model.dart';
import 'package:retrofit/retrofit.dart';
import '../models/user_model.dart';
import 'package:dio/dio.dart';

part 'user_api.g.dart';

@RestApi()
abstract class UserApi {
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;

  @DELETE('/users/{id}')
  Future<void> deleteUser(@Path("id") int id);

  @POST('/users/')
  @DioResponseType(ResponseType.json)
  Future<Map<String, dynamic>> createUser(@Body() Map<String, dynamic> body);

  @PUT("/users/{id}")
  Future<UserModel> updateUser(
      @Path("id") int id, @Body() Map<String, dynamic> body);

  @GET("/users")
  Future<List<UserModel>> getUsers();

  @POST("/users/send-otp")
  Future<String> sendOtp(@Body() Map<String, dynamic> body);

  @POST("/users/verify-otp")
  Future<String> verifyOtp(@Body() Map<String, dynamic> body);

  @POST("/users/reset-password")
  Future<ResetPasswordResponse> resetpassword(
      @Body() Map<String, dynamic> body);
}
