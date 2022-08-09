import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/rides/review.dart';
import '../models/rides/ride.dart';
import '../models/rides/vehicle.dart';
import '../server/routes.dart';
import '../util/either.dart';
import '../util/failures/backend_failure.dart';
import '../util/functions/auth_header_value.dart';
import 'http_service.dart';

class BackendService {
  static BackendService? _instance;
  static BackendService get instance => _instance!;

  const BackendService._({required HttpService httpService})
      : _http = httpService;

  factory BackendService({required HttpService httpService}) {
    if (_instance != null) {
      throw StateError('BackendService already created');
    }

    _instance = BackendService._(httpService: httpService);
    return _instance!;
  }

  final HttpService _http;

  Future<Either<BackendFailure, List<VecturaRide>>> getRides() async {
    final http.Response? response = await _http.get(
      [
        VecServerRoute.api,
        VecServerRoute.apiUser,
        VecServerRoute.apiUserRides,
      ],
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
    );
    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.ok:
        final List<dynamic> rides = jsonDecode(response.body)["rides"];

        List<VecturaRide> vecturaRides = [];

        for (Map<String, dynamic> ride in rides) {
          vecturaRides.add(VecturaRide.fromJson(ride));
        }

        return value(vecturaRides);
      case HttpStatus.unauthorized:
        return error(const UnauthorizedBackendFailure());
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }

  Future<Either<BackendFailure, List<VecturaRide>>> searchRides(
      int page, int limit) async {
    final http.Response? response = await _http.get([
      VecServerRoute.api,
      VecServerRoute.apiRides,
    ], headers: <String, String>{
      HttpHeaders.authorizationHeader: authHeaderValue(),
      HttpHeaders.contentTypeHeader: ContentType.json.value,
    }, queryParameters: <String, dynamic>{
      VecServerRoute.queryParamPage: page.toString(),
      VecServerRoute.queryParamLimit: limit.toString()
    });
    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.ok:
        final List<dynamic> rides = jsonDecode(response.body)["offers"];

        List<VecturaRide> vecturaRides = [];

        for (Map<String, dynamic> ride in rides) {
          vecturaRides.add(VecturaRide.fromJson(ride));
        }

        return value(vecturaRides);
      case HttpStatus.unauthorized:
        return error(const UnauthorizedBackendFailure());
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }

  Future<Either<BackendFailure, String>> createRide(VecturaRide ride) async {
    final http.Response? response = await _http.post(
      [
        VecServerRoute.api,
        VecServerRoute.apiRides,
      ],
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode(ride.toJson()),
    );

    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.created:
        return value(response.body);
      case HttpStatus.preconditionFailed:
        return error(const PreconditionFailedBackendFailure());
      case HttpStatus.forbidden:
        return error(const ForbiddenBackendFailure());
      case HttpStatus.unauthorized:
        return error(const UnauthorizedBackendFailure());
      case HttpStatus.badRequest:
        return error(const BadRequestBackendFailure());
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }

  Future<Either<BackendFailure, VecturaRide>> getRideDetails(String id) async {
    final http.Response? response = await _http.get(
      [VecServerRoute.api, VecServerRoute.apiRides, id],
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
    );

    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.ok:
        return value(VecturaRide.fromJson(json.decode(response.body)));
      case HttpStatus.notFound:
        return error(const NotFoundBackendFailure());
      case HttpStatus.internalServerError:
        return error(const InternalServerErrorBackendFailure());
      case HttpStatus.unauthorized:
        return error(const UnauthorizedBackendFailure());
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }

  Future<Either<BackendFailure, void>> deleteRide(String id) async {
    final http.Response? response = await _http.del(
      [VecServerRoute.api, VecServerRoute.apiRides, id],
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
    );

    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.ok:
        return value(null);
      case HttpStatus.unauthorized:
        return error(const UnauthorizedBackendFailure());
      case HttpStatus.notFound:
        return error(const NotFoundBackendFailure());
      case HttpStatus.internalServerError:
        return error(const InternalServerErrorBackendFailure());
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }

  Future<Either<BackendFailure, void>> joinRide(String id) async {
    final http.Response? response = await _http.post(
      [
        VecServerRoute.api,
        VecServerRoute.apiRides,
        id,
        VecServerRoute.apiRidesIdAccept,
      ],
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
    );

    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.ok:
        return value(null);
      case HttpStatus.internalServerError:
        return error(const InternalServerErrorBackendFailure());
      case HttpStatus.notFound:
        return error(const NotFoundBackendFailure());
      case HttpStatus.preconditionFailed:
        return error(const PreconditionFailedBackendFailure());
      case HttpStatus.unauthorized:
        return error(const UnauthorizedBackendFailure());
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }

  Future<Either<BackendFailure, void>> cancelJoinRide(String id) async {
    final http.Response? response = await _http.post(
      [
        VecServerRoute.api,
        VecServerRoute.apiRides,
        id,
        VecServerRoute.apiRidesIdCancel,
      ],
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
    );

    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.ok:
        return value(null);
      case HttpStatus.internalServerError:
        return error(const InternalServerErrorBackendFailure());
      case HttpStatus.notFound:
        return error(const NotFoundBackendFailure());
      case HttpStatus.unauthorized:
        return error(const UnauthorizedBackendFailure());
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }

  Future<Either<BackendFailure, void>> addReview(
      VecturaReview review, String id) async {
    final http.Response? response = await _http.post(
      [
        VecServerRoute.api,
        VecServerRoute.apiRides,
        id,
        VecServerRoute.apiRidesIdReview,
      ],
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode(review.toJson()),
    );

    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.created:
        return value(null);
      case HttpStatus.unauthorized:
        return error(const UnauthorizedBackendFailure());
      case HttpStatus.forbidden:
        return error(const ForbiddenBackendFailure());
      case HttpStatus.notFound:
        return error(const NotFoundBackendFailure());
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }

  Future<Either<BackendFailure, void>> addVehicle(
      VecturaVehicle vehicle) async {
    final http.Response? response = await _http.post(
      [
        VecServerRoute.api,
        VecServerRoute.apiUser,
        VecServerRoute.apiUserVehicle,
      ],
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode(vehicle.toJson()),
    );

    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.created:
        return value(null);
      case HttpStatus.unauthorized:
        return error(const UnauthorizedBackendFailure());
      case HttpStatus.badRequest:
        return error(const BadRequestBackendFailure());
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }

  Future<Either<BackendFailure, void>> updateVehicle(
      VecturaVehicle vehicle) async {
    final http.Response? response = await _http.put(
      [
        VecServerRoute.api,
        VecServerRoute.apiUser,
        VecServerRoute.apiUserVehicle,
      ],
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode(vehicle.toJson()),
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

  Future<Either<BackendFailure, void>> removeVehicle() async {
    final http.Response? response = await _http.del(
      [
        VecServerRoute.api,
        VecServerRoute.apiUser,
        VecServerRoute.apiUserVehicle,
      ],
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
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

  Future<Either<BackendFailure, List<VecturaRide>>> rideHistory(
      int filter, int page, int limit) async {
    final http.Response? response = await _http.get([
      VecServerRoute.api,
      VecServerRoute.apiUser,
      VecServerRoute.apiUserRideHistory,
    ], headers: <String, String>{
      HttpHeaders.authorizationHeader: authHeaderValue(),
      HttpHeaders.contentTypeHeader: ContentType.json.value,
    }, queryParameters: <String, dynamic>{
      VecServerRoute.queryParamFilter: filter.toString(),
      VecServerRoute.queryParamPage: page.toString(),
      VecServerRoute.queryParamLimit: limit.toString()
    });

    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.ok:
        final List<dynamic> rides = jsonDecode(response.body)["rides"];

        List<VecturaRide> vecturaRides = [];

        for (Map<String, dynamic> ride in rides) {
          vecturaRides.add(VecturaRide.fromJson(ride));
        }

        return value(vecturaRides);
      case HttpStatus.unauthorized:
        return error(const UnauthorizedBackendFailure());
      case HttpStatus.badRequest:
        return error(const BadRequestBackendFailure());
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }

  Future<Either<BackendFailure, List<VecturaReview>>> getReviewsForUser(
      String userId) async {
    final http.Response? response = await _http.get(
      [
        VecServerRoute.api,
        VecServerRoute.apiUsers,
        userId,
        VecServerRoute.apiUseridReviews,
      ],
      headers: <String, String>{
        HttpHeaders.authorizationHeader: authHeaderValue(),
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
    );

    if (response == null) return error(const UnknownBackendFailure());

    switch (response.statusCode) {
      case HttpStatus.ok:
        final List<dynamic> reviews = jsonDecode(response.body)["reviews"];

        List<VecturaReview> vecturaReviews = [];

        for (Map<String, dynamic> review in reviews) {
          vecturaReviews.add(VecturaReview.fromJson(review));
        }

        return value(vecturaReviews);
      case HttpStatus.unauthorized:
        return error(const UnauthorizedBackendFailure());
      default:
        return error(BackendFailure.fromStatusCode(response.statusCode));
    }
  }
}
