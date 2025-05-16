import 'package:equatable/equatable.dart';
import '../../models/quote_model.dart';

abstract class DailyQuoteState extends Equatable {
  const DailyQuoteState();

  @override
  List<Object?> get props => [];
}

class DailyQuoteInitial extends DailyQuoteState {}

class DailyQuoteLoading extends DailyQuoteState {}

class DailyQuoteLoaded extends DailyQuoteState {
  final QuoteModel quote;
  const DailyQuoteLoaded(this.quote);

  @override
  List<Object?> get props => [quote];
}

class DailyQuoteError extends DailyQuoteState {
  final String message;
  const DailyQuoteError(this.message);

  @override
  List<Object?> get props => [message];
}
