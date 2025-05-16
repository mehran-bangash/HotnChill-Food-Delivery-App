import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotnchill/model/wallet_model.dart';
import 'package:hotnchill/utils/utils.dart';

import '../view_model/auth_view_model.dart';

class WalletService {
  // Public static instance
  static final WalletService instance = WalletService._internal();
  // Factory constructor
  factory WalletService() => instance;
  // Private constructor
  WalletService._internal();
  final AuthViewModel authViewModel = AuthViewModel();

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<void> addWalletDetail(WalletModel walletModel) async {
    try {
      await _firebaseFirestore
          .collection("userWallet")
          .doc(walletModel.userId)
          .set(walletModel.walletMap());


    } catch (e) {
      Utils.toastMessage("Error occurred: ${e.toString()}");
    }
  }


  Future<void> updateWalletDetail({
    required String uid,
      String? pid,
    required String amount,
  }) async {
    try {
      await _firebaseFirestore.collection("userWallet").doc(uid)
          .update({
        'paymentId': pid,
        'amount': amount,
      });
    } on FirebaseException catch (e) {
      Utils.toastMessage(e.toString());
    } catch (e) {
      Utils.toastMessage("Error occur: ${e.toString()}");
    }
  }
  Future<WalletModel?> getWalletTransactions(String uid) async{
    try {
       DocumentSnapshot snapshot=await FirebaseFirestore.instance
          .collection("userWallet")
          .doc(uid).get();
      if (snapshot.exists) {
        return WalletModel.fromMap(snapshot.data() as Map<String, dynamic>);
      }

    } catch (e) {
      Utils.toastMessage("Error fetching transactions: ${e.toString()}");

    }
    return null;
  }

}