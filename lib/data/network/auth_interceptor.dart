import 'package:dio/dio.dart';
import 'package:gongbab_owner/data/auth/auth_token_manager.dart';
import 'package:gongbab_owner/data/models/auth/login_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthInterceptor extends QueuedInterceptor {
  final AuthTokenManager _authTokenManager;
  final Dio _dio;
  // For token refresh calls, to avoid circular dependencies.
  late final Dio _tokenDio;

  AuthInterceptor(this._authTokenManager, this._dio) {
    // Create a new Dio instance for token refresh.
    // It shares the same base options but won't be affected by the main instance's interceptors.
    _tokenDio = Dio(BaseOptions(
      baseUrl: _dio.options.baseUrl,
      connectTimeout: _dio.options.connectTimeout,
      receiveTimeout: _dio.options.receiveTimeout,
      contentType: 'application/json',
      headers: {'Accept': 'application/json'},
    ));
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final accessToken = _authTokenManager.getAccessToken();
    if (accessToken != null && !options.path.contains('/auth/refresh')) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // If the error is from the refresh token endpoint itself, it means the refresh token is invalid.
    // In this case, we clear tokens and propagate the error. The router will handle redirection.
    if (err.requestOptions.path.contains('/auth/refresh')) {
      await _authTokenManager.clearTokens();
      return handler.next(err);
    }
    
    final refreshToken = _authTokenManager.getRefreshToken();
    if (refreshToken == null) {
      await _authTokenManager.clearTokens();
      return handler.next(err);
    }

    try {
      // Attempt to refresh the token using the separate Dio instance.
      final response = await _tokenDio.post(
        '/api/v1/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final loginModel = LoginModel.fromJson(response.data);

      await _authTokenManager.saveTokens(
        loginModel.accessToken,
        loginModel.refreshToken,
      );

      // Token refreshed, now retry the original request that failed.
      final options = err.requestOptions;
      options.headers['Authorization'] = 'Bearer ${loginModel.accessToken}';

      final retryResponse = await _dio.fetch(options);
      return handler.resolve(retryResponse);

    } on DioException catch (e) {
      // If token refresh fails, clear tokens and reject the request.
      await _authTokenManager.clearTokens();
      return handler.reject(e);
    } catch (e) {
       // Handle any other unexpected errors during refresh.
      await _authTokenManager.clearTokens();
      return handler.reject(err);
    }
  }
}
