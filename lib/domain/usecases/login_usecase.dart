import 'package:gongbab_owner/data/auth/auth_token_manager.dart';
import 'package:gongbab_owner/domain/entities/auth/login_entity.dart';
import 'package:gongbab_owner/domain/repositories/auth_repository.dart';
import 'package:gongbab_owner/domain/utils/result.dart';

class LoginUseCase {
  final AuthRepository repository;
  final AuthTokenManager authTokenManager;

  LoginUseCase(this.repository, this.authTokenManager);

  Future<Result<LoginEntity>> execute({
    required String code,
    required String deviceType,
    required String deviceId,
  }) async {
    final result = await repository.login(
      code: code,
      deviceType: deviceType,
      deviceId: deviceId,
    );
    return result.when(
      success: (loginEntity) async {
        await authTokenManager.saveTokens(loginEntity.accessToken, loginEntity.refreshToken);
        return Result.success(loginEntity);
      },
      failure: (code, data) => Result.failure(code, data),
      error: (error) => Result.error(error),
    );
  }
}
