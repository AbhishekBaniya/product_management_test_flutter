import 'dart:io';

import 'package:dio/dio.dart';

// class DioClient {
//   final Dio dio;
//
//   DioClient(this.dio) {
//     dio.options = BaseOptions(
//       baseUrl: "http://localhost:3000",
//       connectTimeout: const Duration(seconds: 10),
//       receiveTimeout: const Duration(seconds: 10),
//       headers: {'Content-Type': 'application/json'},
//     );
//   }
// }
// import 'package:flutter/foundation.dart';
//
// class DioClient {
//   final Dio dio;
//
//   DioClient(this.dio) {
//     dio.options = BaseOptions(
//       baseUrl:_baseUrl,
//       connectTimeout: const Duration(seconds: 10),
//       receiveTimeout: const Duration(seconds: 10),
//       headers: {'Content-Type': 'application/json'},
//     );
//
//     dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           print('➡️ ${options.method} ${options.uri}');
//           print('Headers: ${options.headers}');
//           print('Body: ${options.data}');
//           handler.next(options);
//         },
//         onResponse: (response, handler) {
//           print('✅ ${response.statusCode} ${response.requestOptions.uri}');
//           print('Response: ${response.data}');
//           handler.next(response);
//         },
//         onError: (e, handler) {
//           print('❌ ERROR ${e.requestOptions.uri}');
//           print('Message: ${e.message}');
//           handler.next(e);
//         },
//       ),
//     );
//
//   }
//
//   static String get _baseUrl {
//     if (kIsWeb) {
//       return 'http://localhost:3000';
//     }
//     if (Platform.isAndroid) {
//       return 'http://10.0.2.2:3000';
//     }
//     return 'http://localhost:3000'; // iOS, macOS
//   }
// }
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    if (!kReleaseMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  static String get _baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }
}
