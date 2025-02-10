import 'package:get_it/get_it.dart';
import 'package:photo_app/core/network/dio_client.dart';
import 'package:photo_app/data/auth/repositories/auth.dart';
import 'package:photo_app/data/auth/sources/auth_api_service.dart';
import 'package:photo_app/domain/auth/repositories/auth.dart';
import 'package:photo_app/domain/auth/usecases/signin.dart';
import 'package:photo_app/domain/auth/usecases/signup.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerSingleton<DioClient>(DioClient());

  //services
  sl.registerSingleton<AuthApiService>(AuthApiServiceImplementation());

  //repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImplementation());

  //usecases
  sl.registerSingleton<SignUpUseCase>(SignUpUseCase());
  sl.registerSingleton<SignInUseCase>(SignInUseCase());
}
