import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotnchill/exceptions/item_exeception.dart';
import 'package:hotnchill/model/item_model.dart';
import 'package:hotnchill/utils/utils.dart';

class ItemRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> addItem(String name, ItemModel item) async {
    try {
      await _firestore.collection(name).doc(item.id).set(item.toJson());
    } on FirebaseException catch (e) {
      throw ItemException(e.message ?? "Failed to add item.");
    } catch (e) {
      throw ItemException("Something went wrong: $e");
    }
  }

  Stream<QuerySnapshot> getFoodItem(String name) {
    try {
      return _firestore.collection(name).snapshots();
    } catch (e) {Utils.toastMessage(e.toString());
      return const Stream.empty(); // return empty stream on error
    }
  }
  Future<void> addCartDetail(String uid, Map<String, dynamic> cardInfo) async {
    try {
      await _firestore
          .collection("FoodCartDetail")
          .doc(uid)
          .collection("items")
          .add({
        ...cardInfo,
        'createdAt': FieldValue.serverTimestamp(),
        'totalPrice': cardInfo['totalPrice'],
      });
    } catch (e) {
      Utils.toastMessage("Failed to add item: ${e.toString()}");
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCartItems(String uid) {
    return _firestore
        .collection("FoodCartDetail")
        .doc(uid)
        .collection("items")
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> removeCartItem(String uid, String itemId) async {
    await _firestore
        .collection("FoodCartDetail")
        .doc(uid)
        .collection("items")
        .doc(itemId)
        .delete();
  }

  Future<void> clearCart(String uid) async {
    final snapshot = await _firestore
        .collection("FoodCartDetail")
        .doc(uid)
        .collection("items")
        .get();

    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}

