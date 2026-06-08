import 'package:dio/dio.dart';
import '../vocabulary/models/vocabulary_model.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  final String _backendUrl = const String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'http://10.103.247.228:3000',
  );

  Future<List<VocabularyModel>> getWords() async {
    try {
      final response = await _dio.get(
        '$_backendUrl/words',
        options: Options(
          headers: const {
            'x-api-key': 'lingobreeze_public_key_2026',
          },
          connectTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => VocabularyModel.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch words from backend: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred fetching backend words: $e');
    }
  }
}
