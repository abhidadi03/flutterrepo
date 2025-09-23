import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../../auth/data/models/user_model.dart';

part 'otp_api.g.dart';

@RestApi()
abstract class OtpApi {
  factory OtpApi(Dio dio, {String baseUrl}) = _OtpApi;

  @POST('/users/validateUserPhone')
  Future<ValidateUserResponse> validateUser(@Body() Map<String, dynamic> body);
}
