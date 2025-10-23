import 'package:photo_app/data/auth/services/login_data_service.dart';
import 'package:photo_app/data/auth/models/signin_req_params.dart';
import 'package:photo_app/domain/auth/usecases/signin.dart';
import 'package:photo_app/core/utils/token_storage.dart';
import 'package:photo_app/service_locator.dart';

class AutoLoginService {
  static Future<bool> tryAutoLogin() async {
    final savedData = LoginDataService.getSavedLoginData();

    if (savedData == null || !savedData.rememberMe) {
      return false;
    }

    try {
      final result = await sl<SignInUseCase>().call(
        params: SignInReqParams(
          email: savedData.email,
          password: savedData.password,
        ),
      );

      return await result.fold(
        (error) async {
          return false;
        },
        (data) async {
          final token = await TokenStorage.loadToken();
          if (token != null && token.isNotEmpty) {
            return true;
          } else {
            return false;
          }
        },
      );
    } catch (e) {
      return false;
    }
  }
}
