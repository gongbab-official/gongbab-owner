import 'package:gongbab_owner/domain/entities/auth/login_entity.dart';
import 'package:gongbab_owner/domain/utils/result.dart';

abstract class AuthRepository {
  Future<Result<LoginEntity>> login({
    required String code,
    required String deviceType,
    required String deviceId,
  });
}