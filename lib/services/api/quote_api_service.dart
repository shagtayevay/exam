import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/quote_model.dart';
import '../../models/quotes_list_response.dart';

part 'quote_api_service.g.dart';

@RestApi(baseUrl: 'https://favqs.com/api/')
abstract class QuoteApiService {
  factory QuoteApiService(Dio dio, {String baseUrl}) = _QuoteApiService;

  @GET('qotd')
  Future<QotdResponse> getQuoteOfTheDay();

  @GET('quotes')
  Future<QuotesListResponse> getQuotes(@Query('page') int page);
}
