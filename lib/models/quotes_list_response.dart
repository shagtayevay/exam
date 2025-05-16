import 'quote_model.dart';

class QuotesListResponse {
  final List<QuoteModel> quotes;
  final int page;
  final int lastPage;

  QuotesListResponse(
      {required this.quotes, required this.page, required this.lastPage});

  factory QuotesListResponse.fromJson(Map<String, dynamic> json) {
    return QuotesListResponse(
      quotes: (json['quotes'] as List)
          .map((e) => QuoteModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: json['page'] as int,
      lastPage: json['last_page'] as int,
    );
  }
}
