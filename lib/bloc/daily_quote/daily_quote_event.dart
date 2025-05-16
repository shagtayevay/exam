import 'package:equatable/equatable.dart';

abstract class DailyQuoteEvent extends Equatable {
  const DailyQuoteEvent();

  @override
  List<Object?> get props => [];
}

class FetchDailyQuote extends DailyQuoteEvent {}

class LoadCachedQuote extends DailyQuoteEvent {}
