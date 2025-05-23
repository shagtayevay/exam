import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../daily_quote/daily_quote_screen.dart';
import '../favorites/favorites_screen.dart';
import '../profile/profile_screen.dart';
import '../../bloc/daily_quote/daily_quote_bloc.dart';
import '../../services/api/quote_api_service.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../models/quotes_list_response.dart';
import '../../components/quote_card.dart';
import '../../services/api/quotable_service.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return QuotesListScreen();
      case 1:
        return BlocProvider(
          create: (_) => DailyQuoteBloc(
            apiService: QuoteApiService(Dio()),
          ),
          child: const DailyQuoteScreen(),
        );
      case 2:
        return const FavoritesScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const Center(child: Text('Главная'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'main'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'quote_of_the_day'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'favorites'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'profile'.tr(),
          ),
        ],
      ),
    );
  }
}

class TypeFitService {
  final Dio _dio = Dio();
  Future<List<Map<String, dynamic>>> getQuotes() async {
    final response = await _dio.get('https://type.fit/api/quotes');
    return List<Map<String, dynamic>>.from(response.data);
  }
}

Future<List<Map<String, dynamic>>> loadLocalQuotes() async {
  final data = await rootBundle.loadString('assets/quotes.json');
  return List<Map<String, dynamic>>.from(json.decode(data));
}

Future<List<Map<String, dynamic>>> loadUserQuotes() async {
  final dbRef = FirebaseDatabase.instance.ref('user_quotes');
  final snapshot = await dbRef.get();
  if (snapshot.exists) {
    final data = Map<String, dynamic>.from(snapshot.value as Map);
    final quotes = data.values
        .map((e) => {
              'body': e['body'] ?? '',
              'author': e['author'] ?? '',
              'created_at': e['created_at'] ?? '',
            })
        .toList();
    quotes.sort(
        (a, b) => (b['created_at'] ?? '').compareTo(a['created_at'] ?? ''));
    return quotes;
  }
  return [];
}

Future<List<Map<String, dynamic>>> loadAllQuotes() async {
  final userQuotes = await loadUserQuotes();
  final response =
      await Dio().get('https://jsonplaceholder.typicode.com/posts');
  final data = response.data as List;
  final onlineQuotes = data
      .map((item) => {
            'body': item['body'] ?? '',
            'author': 'User  0${item['userId'] ?? ''}',
          })
      .toList();
  return [...userQuotes, ...onlineQuotes];
}

Future<List<Map<String, dynamic>>> loadQuotesFromJsonPlaceholder() async {
  final response =
      await Dio().get('https://jsonplaceholder.typicode.com/posts');
  final data = response.data as List;
  return data
      .map((item) => {
            'body': item['body'] ?? '',
            'author': 'User  0${item['userId'] ?? ''}',
          })
      .toList();
}

class QuotesListScreen extends StatelessWidget {
  const QuotesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: loadAllQuotes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final quotes = snapshot.data!;
        final user = FirebaseAuth.instance.currentUser;
        final firestoreService = FirestoreService();
        if (user == null) {
          // Неавторизованный пользователь
          return ListView.builder(
            itemCount: quotes.length,
            itemBuilder: (context, i) {
              final quote = quotes[i];
              return ListTile(
                title: Text(quote['body'] ?? ''),
                subtitle: Text(quote['author'] ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: null,
                ),
              );
            },
          );
        }
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firestoreService.getFavorites(user.uid),
          builder: (context, favSnapshot) {
            final favoriteDocs = favSnapshot.data?.docs ?? [];
            final favorites = favoriteDocs.map((doc) => doc.data()).toList();
            return ListView.builder(
              itemCount: quotes.length,
              itemBuilder: (context, i) {
                final quote = quotes[i];
                final isFavorite = favorites.any((fav) =>
                    fav['body'] == quote['body'] &&
                    fav['author'] == quote['author']);
                return ListTile(
                  title: Text(quote['body'] ?? ''),
                  subtitle: Text(quote['author'] ?? ''),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: () async {
                      if (!isFavorite) {
                        await firestoreService.addFavorite(user.uid, quote);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('add_to_favorites'.tr())),
                        );
                      }
                      // (опционально: добавить удаление из избранного по повторному нажатию)
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
