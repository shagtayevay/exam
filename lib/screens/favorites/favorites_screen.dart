import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../components/loading_indicator.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Требуется вход'));
    }
    final firestoreService = FirestoreService();
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: firestoreService.getFavorites(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Нет избранных цитат'));
        }
        final docs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data();
            return ListTile(
              title: Text(data['body'] ?? ''),
              subtitle: Text(data['author'] ?? ''),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await firestoreService.deleteFavorite(user.uid, doc.id);
                },
              ),
            );
          },
        );
      },
    );
  }
}
