import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Добавить цитату в избранное
  Future<void> addFavorite(String userId, Map<String, dynamic> quote) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .add(quote);
  }

  // Получить список избранных цитат
  Stream<QuerySnapshot<Map<String, dynamic>>> getFavorites(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots();
  }

  // Удалить цитату из избранного
  Future<void> deleteFavorite(String userId, String favoriteId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(favoriteId)
        .delete();
  }

  // Обновить цитату
  Future<void> updateFavorite(
      String userId, String favoriteId, Map<String, dynamic> data) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(favoriteId)
        .update(data);
  }

  // Данные профиля
  Future<void> setProfile(String userId, Map<String, dynamic> profile) async {
    await _db
        .collection('users')
        .doc(userId)
        .set(profile, SetOptions(merge: true));
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getProfile(String userId) {
    return _db.collection('users').doc(userId).snapshots();
  }
}
