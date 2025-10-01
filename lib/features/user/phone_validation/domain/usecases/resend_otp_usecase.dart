import 'package:myfirstapp/features/user/phone_validation/presentation/bloc/phone_validation_event.dart';

import '../repository/otp_repository.dart';
import '../entities/otp_result.dart';

class ResendOtpUsecase {
  final OtpRepository otpRepository;
  ResendOtpUsecase(this.otpRepository);

  Future<OtpResult> resendOtp({required String phone, int? resendToken}) {
    return otpRepository.resendOtp(phone: phone, resendToken: resendToken);
  }
}
