import 'package:dio/dio.dart';

class QuotableService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.quotable.io/'));

  Future<List<Map<String, dynamic>>> getQuotes() async {
    final response = await _dio.get('quotes');
    return List<Map<String, dynamic>>.from(response.data['results']);
  }
}
