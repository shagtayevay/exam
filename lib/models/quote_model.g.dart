// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuoteModel _$QuoteModelFromJson(Map<String, dynamic> json) => QuoteModel(
      body: json['body'] as String,
      author: json['author'] as String,
    );

Map<String, dynamic> _$QuoteModelToJson(QuoteModel instance) =>
    <String, dynamic>{
      'body': instance.body,
      'author': instance.author,
    };

QotdResponse _$QotdResponseFromJson(Map<String, dynamic> json) => QotdResponse(
      quote: QuoteModel.fromJson(json['quote'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QotdResponseToJson(QotdResponse instance) =>
    <String, dynamic>{
      'quote': instance.quote,
    };
