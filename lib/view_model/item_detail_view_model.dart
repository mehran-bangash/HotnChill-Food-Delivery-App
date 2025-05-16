import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hotnchill/view_model/auth_view_model.dart';
import '../repository/item_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ItemDetailViewModel extends ChangeNotifier {
  final String? imageUrl;
  final String? itemName;
  final String? totalQuantity;
  final String? itemPrice;
  bool _isDelete=false;

  int _quantity = 1;
  final int _itemPrice = 0;
  double _total = 0;
  //final bool _isInitialized = false;
  bool get isDelete=> _isDelete;
  final AuthViewModel authViewModel = AuthViewModel();
final itemRepository=ItemRepository();
  ItemDetailViewModel({
    this.imageUrl,
    this.itemName,
    this.totalQuantity,
    this.itemPrice,
  });

  // // Initialize method to be called after widget is mounted
  // void initialize(int price) {
  //   if (!_isInitialized) {
  //     _itemPrice = price;
  //     _isInitialized = true;
  //     // Don't notify here to avoid build-phase issues
  //   }
  // }

  // Getters
  int get quantity => _quantity;
  int get itemUnitPrice => _itemPrice;
  int _unitPrice = 0; // store base price
  double get total => _total;


  int get totalPrice => _unitPrice * quantity;

  void initialize(int price) {
    _unitPrice = price;
    _quantity = 1;
    notifyListeners();
  }

   bool deletePrice(){
    return _isDelete=true;

   }
  // Quantity Management
  void increment() {
    _quantity++;
    notifyListeners();
  }

  void decrement() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getCartItems() {
    final uid = authViewModel.currentUserId;
    if (uid == null) return const Stream.empty();
    return itemRepository.getCartItems(uid);
  }

  Future<void> addFoodCard({
    required String imageUrl,
    required String itemName,
    required String quantity,
    required String totalPrice,
  }) async {
    final uid = authViewModel.currentUserId;
    if (uid == null) {
      Fluttertoast.showToast(msg: "Please login to add items to cart");
      return;
    }

    try {
      await itemRepository.addCartDetail(uid, {
        "imageUrl": imageUrl,
        "itemName": itemName,
        "quantity": quantity,
        "totalPrice": totalPrice,
      });
      Fluttertoast.showToast(msg: "$itemName added to cart");
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to add item: ${e.toString()}");
      rethrow;
    }
  }
  void calculateTotal(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    double total = 0;
    for (var doc in docs) {
      final data = doc.data();
      total += double.tryParse(data['totalPrice'].toString()) ?? 0.0;
    }
    _total = total;
    notifyListeners();
  }


  Future<void> removeCartItem(String itemId) async {
    final uid = authViewModel.currentUserId;
    if (uid == null) return;
    await itemRepository.removeCartItem(uid, itemId);
  }

  Future<void> clearCart() async {
    final uid = authViewModel.currentUserId;
    if (uid == null) return;
    await itemRepository.clearCart(uid);
    _total = 0;
    notifyListeners();
  }
}