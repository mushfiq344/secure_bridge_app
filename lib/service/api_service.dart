import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:secure_bridges_app/service/request_bodies.dart';
import 'package:secure_bridges_app/utility/urls.dart';

import 'package:http/http.dart' as http hide Response hide Request;

import 'header_interceptor.dart';

part 'api_service.chopper.dart';

@ChopperApi(baseUrl: BASE_URL)
abstract class ApiService extends ChopperService {
  @Get(path: 'api/genres')
  // 7
  Future<Response> getPopularMovies();

  @Post(path: SIGN_IN_URL)
  Future<Response> loginUser(
    @Body() LoginBody body,
  );

  static ApiService create() {
    final client = ChopperClient(
        baseUrl: BASE_URL,
        services: [_$ApiService()],
        interceptors: [
          HeaderInterceptor(),
          HttpLoggingInterceptor(),
        ],
        converter: JsonConverter());
    return _$ApiService(client);
  }
}
