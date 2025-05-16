import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/quote_model.dart';
import '../../services/api/quote_api_service.dart';
import 'daily_quote_event.dart';
import 'daily_quote_state.dart';

class DailyQuoteBloc extends Bloc<DailyQuoteEvent, DailyQuoteState> {
  final QuoteApiService apiService;

  DailyQuoteBloc({required this.apiService}) : super(DailyQuoteInitial()) {
    on<FetchDailyQuote>(_onFetchDailyQuote);
    on<LoadCachedQuote>(_onLoadCachedQuote);
  }

  Future<void> _onFetchDailyQuote(
      FetchDailyQuote event, Emitter<DailyQuoteState> emit) async {
    emit(DailyQuoteLoading());
    try {
      final response = await apiService.getQuoteOfTheDay();
      final quote = response.quote;
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('daily_quote_body', quote.body);
      prefs.setString('daily_quote_author', quote.author);
      emit(DailyQuoteLoaded(quote));
    } catch (e) {
      emit(DailyQuoteError('Ошибка загрузки цитаты дня'));
    }
  }

  Future<void> _onLoadCachedQuote(
      LoadCachedQuote event, Emitter<DailyQuoteState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final body = prefs.getString('daily_quote_body');
    final author = prefs.getString('daily_quote_author');
    if (body != null && author != null) {
      emit(DailyQuoteLoaded(QuoteModel(body: body, author: author)));
    } else {
      emit(DailyQuoteInitial());
    }
  }
}
