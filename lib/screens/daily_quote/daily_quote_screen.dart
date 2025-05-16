import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/daily_quote/daily_quote_bloc.dart';
import '../../bloc/daily_quote/daily_quote_event.dart';
import '../../bloc/daily_quote/daily_quote_state.dart';
import '../../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../components/quote_card.dart';
import '../../components/loading_indicator.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';

class DailyQuoteScreen extends StatefulWidget {
  const DailyQuoteScreen({super.key});

  @override
  State<DailyQuoteScreen> createState() => _DailyQuoteScreenState();
}

class _DailyQuoteScreenState extends State<DailyQuoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bodyController = TextEditingController();
  final _authorController = TextEditingController();

  Future<void> _addQuote() async {
    if (_formKey.currentState!.validate()) {
      final body = _bodyController.text.trim();
      final author = _authorController.text.trim();
      try {
        final dbRef = FirebaseDatabase.instance.ref('user_quotes');
        await dbRef.push().set({
          'body': body,
          'author': author,
          'created_at': DateTime.now().toIso8601String(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('quote_added'.tr())),
        );
        _bodyController.clear();
        _authorController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _bodyController,
              decoration: InputDecoration(labelText: 'quote_text'.tr()),
              validator: (value) => value == null || value.isEmpty
                  ? 'enter_quote_text'.tr()
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _authorController,
              decoration: InputDecoration(labelText: 'author'.tr()),
              validator: (value) =>
                  value == null || value.isEmpty ? 'enter_author'.tr() : null,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _addQuote,
              child: Text('add'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
