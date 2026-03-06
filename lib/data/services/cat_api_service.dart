import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:hw_1/domain/entities/app_error.dart';
import 'package:hw_1/domain/entities/breed.dart';
import 'package:hw_1/domain/entities/cat_profile.dart';
import 'package:hw_1/domain/utils/app_strings.dart';

class CatApiService {
  CatApiService({required this.client, this.apiKey});

  final http.Client client;
  final String? apiKey;

  static const _host = 'api.thecatapi.com';
  static const _basePath = '/v1';

  Map<String, String> get _headers {
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    if (apiKey != null && apiKey!.isNotEmpty) {
      headers['x-api-key'] = apiKey!;
    }
    return headers;
  }

  Map<String, String>? get imageHeaders {
    if (kIsWeb || apiKey == null || apiKey!.isEmpty) {
      return null;
    }
    return {'x-api-key': apiKey!};
  }

  Future<CatProfile> fetchRandomCat({bool forceError = false}) async {
    if (forceError) {
      throw const AppError(
        message: AppStrings.errorTest,
        debugMessage: 'Force error triggered manually',
      );
    }
    final uri = Uri.https(_host, '$_basePath/images/search', {
      'has_breeds': '1',
      'limit': '1',
    });
    final response = await _safeRequest(
      () => client.get(uri, headers: _headers),
    );
    final payload = _decodeList(response);
    if (payload.isEmpty) {
      throw const AppError(
        message: AppStrings.errorNoCat,
        debugMessage: 'Empty payload for /images/search',
      );
    }
    final first = payload.first;
    if (first is! Map<String, dynamic>) {
      throw const AppError(
        message: AppStrings.errorInvalidPayload,
        debugMessage: 'Invalid cat payload type',
      );
    }
    try {
      return CatProfile.fromSearchJson(first);
    } on ArgumentError catch (error) {
      throw AppError(
        message: AppStrings.errorCatNoBreed,
        debugMessage: error.message?.toString(),
      );
    }
  }

  Future<List<Breed>> fetchBreeds() async {
    final uri = Uri.https(_host, '$_basePath/breeds');
    final response = await _safeRequest(
      () => client.get(uri, headers: _headers),
    );
    final payload = _decodeList(response);
    return payload
        .whereType<Map<String, dynamic>>()
        .map(Breed.fromJson)
        .toList();
  }

  Future<http.Response> _safeRequest(
    Future<http.Response> Function() call,
  ) async {
    try {
      final response = await call().timeout(const Duration(seconds: 15));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      }
      throw AppError(
        message: AppStrings.errorServer,
        debugMessage:
            'Status code: ${response.statusCode} body: ${response.body}',
      );
    } on TimeoutException {
      throw const AppError(
        message: AppStrings.errorTimeout,
        debugMessage: 'Request timeout',
      );
    } on SocketException catch (error) {
      throw AppError(
        message: AppStrings.errorNoNetwork,
        debugMessage: error.message,
      );
    } on http.ClientException catch (error) {
      throw AppError(
        message: AppStrings.errorClient,
        debugMessage: error.message,
      );
    }
  }

  List<dynamic> _decodeList(http.Response response) {
    try {
      final result = jsonDecode(response.body);
      if (result is List<dynamic>) {
        return result;
      }
      throw const AppError(
        message: AppStrings.errorUnexpectedData,
        debugMessage: 'Payload is not a list',
      );
    } on FormatException catch (error) {
      throw AppError(
        message: AppStrings.errorParse,
        debugMessage: error.message,
      );
    }
  }
}
