import 'package:flutter_bloc/flutter_bloc.dart';
import './profile_event.dart';
import './profile_state.dart';
import '../../domain/repository/profile_repository.dart';
import '../../data/../domain/usecases/profile_usecase.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  final ProfileUsecase profileUsecase;
  ProfileBloc({required this.profileRepository, required this.profileUsecase})
      : super(ProfileInitial()) {
    on<FetchProfile>(_onfetchProfile);
  }
  Future<void> _onfetchProfile(
      FetchProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final user = await profileUsecase.execute(event.token);
      // for (var u in user) {
      print('user to check:----${user.name} ${user.email} ${user.phoneNo}');
      // }
      emit(ProfileSuccess(user));
    } catch (e) {
      print('error in the bloc:${e.toString()}');
      emit(ProfileError(e.toString()));
    }
  }
}
