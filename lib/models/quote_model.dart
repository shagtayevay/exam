import 'package:json_annotation/json_annotation.dart';

part 'quote_model.g.dart';

@JsonSerializable()
class QuoteModel {
  final String body;
  final String author;

  QuoteModel({required this.body, required this.author});

  factory QuoteModel.fromJson(Map<String, dynamic> json) =>
      _$QuoteModelFromJson(json);
  Map<String, dynamic> toJson() => _$QuoteModelToJson(this);
}

@JsonSerializable()
class QotdResponse {
  @JsonKey(name: 'quote')
  final QuoteModel quote;

  QotdResponse({required this.quote});

  factory QotdResponse.fromJson(Map<String, dynamic> json) =>
      _$QotdResponseFromJson(json);
  Map<String, dynamic> toJson() => _$QotdResponseToJson(this);
}
