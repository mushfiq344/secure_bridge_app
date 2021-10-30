import 'dart:async';
import 'package:chopper/chopper.dart';

// 1
class HeaderInterceptor implements RequestInterceptor {
  // 2
  static const String AUTH_HEADER = "Authorization";
  // 3
  static const String BEARER = "Bearer ";
  // 4
  static const String V4_AUTH_HEADER = "< your key here >";

  @override
  FutureOr<Request> onRequest(Request request) async {
    // 5
    Request newRequest =
        request.copyWith(headers: {AUTH_HEADER: BEARER + V4_AUTH_HEADER});
    return newRequest;
  }
}
