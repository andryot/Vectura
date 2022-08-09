import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/jwt_pair.dart';
import '../models/user/user.dart';
import '../server/routes.dart';
import '../util/either.dart';
import '../util/failures/backend_failure.dart';
import '../util/functions/auth_header_value.dart';
import 'http_service.dart';

class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance!;

  const AuthService._({required HttpService httpService}) : _http = httpService;

  factory AuthService({required HttpService httpService}) {
    if (_instance != null) {
      throw StateError('AuthService already created!');
    }

    _instance = AuthService._(httpService: httpService);
    return _instance!;
  }

  final HttpService _http;

  Future<Either<BackendFailure, VecturaUser>> login(
      String email, String password) async {
    final http.Response? response = await _http.post(
      [
        VecServerRoute.api,
        VecServerRoute.apiAuth,
        VecServerRoute.apiAuthLogin,
      ],
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode(
        <String, String>{
          VecturaUserJsonKey.email: email,
          VecturaUserJsonKey.password: password,
        },
      ),
    );

    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.ok:
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print(
            'Login ID: ${jsonResponse['id']}, oseba: ${jsonResponse['name']}.');
        return value(VecturaUser.fromJson(jsonResponse));
      case HttpStatus.badRequest:
        print('No email/password, fail code: ${response.statusCode}.');
        return error(const BadRequestBackendFailure());
      // return {'error': "badRequest"};
      case HttpStatus.notFound:
        print('Wrong email/password, fail code: ${response.statusCode}.');
        return error(const NotFoundBackendFailure());
      // return {'error': "notFound"};
      default:
        return error(const UnknownBackendFailure());
    }
  }

  Future<Either<BackendFailure, VecturaUser>> register(
      String email, String password, String name, String phone) async {
    final http.Response? response = await _http.post(
      [
        VecServerRoute.api,
        VecServerRoute.apiAuth,
        VecServerRoute.apiAuthRegister,
      ],
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode(
        <String, String>{
          VecturaUserJsonKey.email: email,
          VecturaUserJsonKey.password: password,
          VecturaUserJsonKey.name: name,
          VecturaUserJsonKey.phone: phone,
        },
      ),
    );

    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.created:
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print(
            'Register ID: ${jsonResponse['id']}, oseba: ${jsonResponse['name']}.');
        return value(VecturaUser.fromJson(jsonDecode(response.body)));
      case HttpStatus.badRequest:
        print('Missing required field, fail code: ${response.statusCode}.');
        return error(const BadRequestBackendFailure());
      // return {'error': "badRequest"};
      case HttpStatus.forbidden:
        print('Email already taken, fail code: ${response.statusCode}.');
        return error(const ForbiddenBackendFailure());
      // return {'error': "forbidden"};
      default:
        return error(const UnknownBackendFailure());
    }
  }

  Future<Either<BackendFailure, JwtPair>> refreshToken(
      String refreshToken) async {
    final http.Response? response = await _http.post(
      [
        VecServerRoute.api,
        VecServerRoute.apiAuth,
        VecServerRoute.apiAuthRefresh,
      ],
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode(
        <String, String>{'refresh_token': refreshToken},
      ),
    );

    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.ok:
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return value(JwtPair.fromJson(jsonResponse));
      case HttpStatus.badRequest:
        print("bad request");
        return error(const BadRequestBackendFailure());
      default:
        return error(const UnknownBackendFailure());
    }
  }

  Future<Either<BackendFailure, VecturaUser>> getUserData() async {
    final http.Response? response = await HttpService.instance.get(
      [
        VecServerRoute.api,
        VecServerRoute.apiUser,
      ],
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: ContentType.json.value,
        HttpHeaders.authorizationHeader: authHeaderValue(),
      },
    );

    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.ok:
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return value(VecturaUser.fromJson(jsonResponse));
      case HttpStatus.unauthorized:
        print("unauthorized");
        return error(const UnauthorizedBackendFailure());
      default:
        return error(const UnknownBackendFailure());
    }
  }

  Future<Either<BackendFailure, void>> updateUserInfo(
    Map<String, String?> userInfo,
  ) async {
    final http.Response? response = await HttpService.instance.patch(
      [
        VecServerRoute.api,
        VecServerRoute.apiUser,
      ],
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: ContentType.json.value,
        HttpHeaders.authorizationHeader: authHeaderValue(),
      },
      body: jsonEncode(
        userInfo,
      ),
    );

    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.ok:
        return value(null);
      case HttpStatus.unauthorized:
        return error(const UnauthorizedBackendFailure());
      case HttpStatus.badRequest:
        return error(const BadRequestBackendFailure());
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }

  Future<Either<BackendFailure, void>> changePassword(
      String newPassword) async {
    final http.Response? response = await HttpService.instance.put(
      [
        VecServerRoute.api,
        VecServerRoute.apiUser,
        VecServerRoute.apiUserPassword,
      ],
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: ContentType.json.value,
        HttpHeaders.authorizationHeader: authHeaderValue(),
      },
      body: jsonEncode(
        <String, String>{VecturaUserJsonKey.newPassword: newPassword},
      ),
    );

    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.ok:
        return value(null);
      case HttpStatus.unauthorized:
        return error(const UnauthorizedBackendFailure());
      case HttpStatus.badRequest:
        return error(const BadRequestBackendFailure());
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }
}
