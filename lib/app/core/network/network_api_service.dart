import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';

import '../constant_api/api_constant.dart';

class ApiClient {
  static final http.Client _client = http.Client();
  static const int _defaultTimeout = 60; // Default timeout duration in seconds
  static final RegExp _iso8601Regex =
  RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?([+-]\d{2}:\d{2}|Z)$');

  // ==========================================
  // HEADERS
  // ==========================================

  static Map<String, String> get _defaultHeaders {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // ==========================================
  // LOGGING METHODS
  // ==========================================

  static void _logRequest(String method, Uri url, {Map<String, String>? headers, dynamic body}) {
    if (!kDebugMode) return;

    final timestamp = DateFormat('hh:mm a, ss seconds, dd MMM yyyy').format(DateTime.now());

    debugPrint('╔══════════════════════════════════════════════════════════════');
    debugPrint('║ 📡 HTTP REQUEST');
    debugPrint('╟──────────────────────────────────────────────────────────────');
    debugPrint('║ [Timestamp] $timestamp');
    debugPrint('║ [Method]    $method');
    debugPrint('║ [URL]       $url');

    if (headers != null && headers.isNotEmpty) {
      debugPrint('╟ [Headers]');
      headers.forEach((key, value) => debugPrint('║   $key: $value'));
    }

    if (body != null) {
      debugPrint('╟ [Body]');
      final prettyBody = _tryPrettyJson(body);
      debugPrint('║ $prettyBody');
    }

    debugPrint('╚══════════════════════════════════════════════════════════════');
  }

  static void _logResponse(http.Response response) {
    if (!kDebugMode) return;

    final timestamp = DateFormat('hh:mm a, ss seconds, dd MMM yyyy').format(DateTime.now());

    debugPrint('╔══════════════════════════════════════════════════════════════');
    debugPrint('║ 📬 HTTP RESPONSE');
    debugPrint('╟──────────────────────────────────────────────────────────────');
    debugPrint('║ [Timestamp]    $timestamp');
    debugPrint('║ [Status Code]  ${response.statusCode}');
    debugPrint('║ [Reason]       ${response.reasonPhrase}');

    if (response.headers.isNotEmpty) {
      debugPrint('╟ [Response Headers]');
      response.headers.forEach((key, value) => debugPrint('║   $key: $value'));
    }

    debugPrint('╟ [Response Body]');
    final prettyBody = _tryPrettyJson(response.body);
    debugPrint('║ $prettyBody');

    debugPrint('╚══════════════════════════════════════════════════════════════');
  }

  // NEW: Custom Error Logger
  static void _logError(dynamic error, [StackTrace? stackTrace]) {
    if (!kDebugMode) return;

    final timestamp = DateFormat('hh:mm a, ss seconds, dd MMM yyyy').format(DateTime.now());

    debugPrint('╔══════════════════════════════════════════════════════════════');
    debugPrint('║ ❌ HTTP ERROR');
    debugPrint('╟──────────────────────────────────────────────────────────────');
    debugPrint('║ [Timestamp] $timestamp');

    if (error is HttpResponseException) {
      debugPrint('║ [Status Code] ${error.statusCode}');
      debugPrint('║ [Message]     ${error.message}');
      if (error.body != null && error.body!.isNotEmpty) {
        debugPrint('╟ [Error Body]');
        debugPrint('║ ${_tryPrettyJson(error.body)}');
      }
    } else {
      debugPrint('║ [Error]       ${error.toString()}');
    }

    // Optional: Print StackTrace if you want deep debugging (uncomment if needed)
    // if (stackTrace != null) {
    //   debugPrint('╟ [StackTrace]');
    //   debugPrint('║ $stackTrace');
    // }

    debugPrint('╚══════════════════════════════════════════════════════════════');
  }

  static String _tryPrettyJson(dynamic body) {
    try {
      final dynamic jsonBody = body is String && body.isNotEmpty ? jsonDecode(body) : body;
      final JsonEncoder encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(jsonBody);
    } catch (_) {
      return body.toString();
    }
  }

  // ==========================================
  // CORE API METHODS (CRUD)
  // ==========================================

  // --- GET ---
  static Future<dynamic> get(Uri url, {Map<String, String>? headers}) async {
    final mergedHeaders = {..._defaultHeaders, ...?headers};
    _logRequest('GET', url, headers: mergedHeaders);

    final response = await _executeRequest(() => _client.get(url, headers: mergedHeaders));
    _logResponse(response);
    return _convertIsoDatesToLocal(jsonDecode(response.body));
  }

  // --- POST ---
  static Future<dynamic> post(Uri url, {Map<String, String>? headers, dynamic body}) async {
    final mergedHeaders = {..._defaultHeaders, ...?headers};
    final encodedBody = body != null ? jsonEncode(body) : null;

    _logRequest('POST', url, headers: mergedHeaders, body: body);

    final response = await _executeRequest(
            () => _client.post(url, headers: mergedHeaders, body: encodedBody));
    _logResponse(response);
    return _convertIsoDatesToLocal(jsonDecode(response.body));
  }

  // --- PUT ---
  static Future<dynamic> put(Uri url, {Map<String, String>? headers, dynamic body}) async {
    final mergedHeaders = {..._defaultHeaders, ...?headers};
    final encodedBody = body != null ? jsonEncode(body) : null;

    _logRequest('PUT', url, headers: mergedHeaders, body: body);

    final response = await _executeRequest(
            () => _client.put(url, headers: mergedHeaders, body: encodedBody));
    _logResponse(response);
    return _convertIsoDatesToLocal(jsonDecode(response.body));
  }

  // --- PATCH ---
  static Future<dynamic> patch(Uri url, {Map<String, String>? headers, dynamic body}) async {
    final mergedHeaders = {..._defaultHeaders, ...?headers};
    final encodedBody = body != null ? jsonEncode(body) : null;

    _logRequest('PATCH', url, headers: mergedHeaders, body: body);

    final response = await _executeRequest(
            () => _client.patch(url, headers: mergedHeaders, body: encodedBody));
    _logResponse(response);
    return _convertIsoDatesToLocal(jsonDecode(response.body));
  }

  // --- DELETE ---
  static Future<dynamic> delete(Uri url, {Map<String, String>? headers, dynamic body}) async {
    final mergedHeaders = {..._defaultHeaders, ...?headers};
    final encodedBody = body != null ? jsonEncode(body) : null;

    _logRequest('DELETE', url, headers: mergedHeaders, body: body);

    final response = await _executeRequest(
            () => _client.delete(url, headers: mergedHeaders, body: encodedBody));
    _logResponse(response);

    if (response.body.isEmpty) return null;
    return _convertIsoDatesToLocal(jsonDecode(response.body));
  }

  // ==========================================
  // SPECIALIZED METHODS
  // ==========================================

  static Future<Uint8List> getBytes(Uri url, {Map<String, String>? headers}) async {
    final mergedHeaders = {..._defaultHeaders, ...?headers};
    _logRequest('GET Bytes', url, headers: mergedHeaders);

    final response = await _executeRequest(() => _client.get(url, headers: mergedHeaders));
    _logResponse(response);

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw HttpResponseException(statusCode: response.statusCode, message: response.body);
    }
  }

  // ==========================================
  // MULTIPART REQUESTS
  // ==========================================

  static Future<dynamic> multipartRequest(
      String method,
      Uri url, {
        Map<String, String>? fields,
        List<http.MultipartFile>? files,
        Map<String, String>? headers,
      }) async {
    final mergedHeaders = {..._defaultHeaders, ...?headers};
    mergedHeaders.remove('Content-Type');

    final req = http.MultipartRequest(method, url);
    req.headers.addAll(mergedHeaders);

    if (fields != null) req.fields.addAll(fields);

    if (files != null) {
      final processedFiles = await Future.wait(
        files.map((file) => _processMultipartFile(file)).toList(),
      );
      req.files.addAll(processedFiles);
    }

    _logMultipartRequest(method, url, headers: mergedHeaders, fields: fields, files: files);

    final response = await _executeMultipartRequest(req);
    _logResponse(response);
    return _convertIsoDatesToLocal(jsonDecode(response.body));
  }

  static Future<http.MultipartFile> _processMultipartFile(http.MultipartFile file) async {
    final filename = file.filename;
    if (filename == null) throw ApiException('File must have a filename');

    final extension = filename.split('.').last.toLowerCase();
    final allowedExtensions = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'webp': 'image/webp',
      'avif': 'image/avif',
      'gif': 'image/gif',
      'svg': 'image/svg+xml',
      'bmp': 'image/bmp',
      'tiff': 'image/tiff',
    };

    if (!allowedExtensions.containsKey(extension)) {
      throw ApiException(
          'Only image formats are allowed (JPEG, JPG, PNG, WEBP, AVIF, GIF, SVG, BMP, TIFF). Received: $extension');
    }

    final mimeType = allowedExtensions[extension]!;
    final contentType = MediaType.parse(mimeType);

    return http.MultipartFile(
      file.field,
      file.finalize(),
      file.length,
      filename: filename,
      contentType: contentType,
    );
  }

  static void _logMultipartRequest(
      String method,
      Uri url, {
        Map<String, String>? headers,
        Map<String, String>? fields,
        List<http.MultipartFile>? files,
      }) {
    if (!kDebugMode) return;

    final timestamp = DateFormat('hh:mm a, ss seconds, dd MMM yyyy').format(DateTime.now());
    debugPrint('╔══════════════════════════════════════════════════════════════');
    debugPrint('║ 📡 MULTIPART REQUEST');
    debugPrint('╟──────────────────────────────────────────────────────────────');
    debugPrint('║ [Timestamp] $timestamp');
    debugPrint('║ [Method]    $method');
    debugPrint('║ [URL]       $url');

    if (headers != null && headers.isNotEmpty) {
      debugPrint('╟ [Headers]');
      headers.forEach((key, value) => debugPrint('║   $key: $value'));
    }
    if (fields != null && fields.isNotEmpty) {
      debugPrint('╟ [Fields]');
      fields.forEach((key, value) => debugPrint('║   $key: $value'));
    }
    if (files != null && files.isNotEmpty) {
      debugPrint('╟ [Files]');
      for (var file in files) {
        debugPrint('║   ${file.filename} (${file.length} bytes) | Type: ${file.contentType}');
      }
    }
    debugPrint('╚══════════════════════════════════════════════════════════════');
  }

  static Future<http.Response> _executeMultipartRequest(http.MultipartRequest request) async {
    try {
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: _defaultTimeout),
        onTimeout: () => throw TimeoutException('Request timed out'),
      );
      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } catch (error, stackTrace) {
      _logError(error, stackTrace); // Trigger error print here
      if (error is ApiException) rethrow;
      throw _mapToException(error);
    }
  }

  // ==========================================
  // EXECUTION & ERROR HANDLING LOGIC
  // ==========================================

  static Future<http.Response> _executeRequest(Future<http.Response> Function() request) async {
    try {
      final response = await request().timeout(
        const Duration(seconds: _defaultTimeout),
        onTimeout: () => throw TimeoutException('Request timed out'),
      );
      return _handleResponse(response);
    } catch (error, stackTrace) {
      _logError(error, stackTrace); // Trigger error print here
      if (error is ApiException) rethrow;
      throw _mapToException(error);
    }
  }

  static Exception _mapToException(dynamic error) {
    if (error is SocketException) {
      return NoInternetException('No internet connection: ${error.message}');
    } else if (error is TimeoutException) {
      return RequestTimeoutException('Request timed out: ${error.message}');
    } else if (error is http.ClientException) {
      return HttpRequestException('HTTP Client Error: ${error.message}');
    } else if (error is FormatException) {
      return DataParsingException('Error parsing response: ${error.message}');
    } else {
      return UnknownApiException(error.toString());
    }
  }

  static http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      String errorMessage;
      try {
        final body = jsonDecode(response.body);
        errorMessage = body['message'] ?? response.reasonPhrase ?? 'Unknown error';
      } catch (_) {
        errorMessage = response.reasonPhrase ?? 'Unknown error';
      }
      throw HttpResponseException(
          message: errorMessage, statusCode: response.statusCode, body: response.body);
    }
  }

  static dynamic _convertIsoDatesToLocal(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data.map((key, value) => MapEntry(key, _convertIsoDatesToLocal(value)));
    }
    if (data is List) return data.map(_convertIsoDatesToLocal).toList();
    if (data is String && _iso8601Regex.hasMatch(data)) {
      final parsed = DateTime.tryParse(data);
      if (parsed != null) return parsed.toLocal().toIso8601String();
    }
    return data;
  }
}

// ==========================================
// CUSTOM EXCEPTIONS
// ==========================================
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class NoInternetException extends ApiException {
  NoInternetException(super.message);
}

class RequestTimeoutException extends ApiException {
  RequestTimeoutException(super.message);
}

class HttpRequestException extends ApiException {
  HttpRequestException(super.message);
}

class HttpResponseException extends ApiException {
  final int statusCode;
  final String? body;

  HttpResponseException({required String message, required this.statusCode, this.body})
      : super(message);

  @override
  String toString() => 'HttpResponseException: $message (Status Code: $statusCode)';
}

class DataParsingException extends ApiException {
  DataParsingException(super.message);
}

class UnknownApiException extends ApiException {
  UnknownApiException(super.message);
}