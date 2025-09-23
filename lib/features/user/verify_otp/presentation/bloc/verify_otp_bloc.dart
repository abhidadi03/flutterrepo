import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:myfirstapp/features/user/send_otp/presentation/bloc/phone_validation_event.dart';
import '../../domain/repository/verify_otp_repository.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../bloc/verify_otp_state.dart';
import '../bloc/verify_otp_bloc.dart';
import '../bloc/verify_otp_state.dart';
import '../bloc/verify_otp_event.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final VerifyOtpRepository repository;
  final VerifyOtpUsecase verifyOtp;

  VerifyOtpBloc({required this.repository, required this.verifyOtp})
      : super(VerifyOtpInitial()) {
    on<VerfiyOtp>(_verifyotp);
  }

  Future<void> _verifyotp(VerfiyOtp event, Emitter<VerifyOtpState> emit) async {
    emit(VerifyOtpLoading());
    try {
      final otp = await verifyOtp.verifyOtp(event.phone, event.otp);
    } catch (e) {
      emit(OtpVerficationFailed(e.toString()));
    }
  }
}
