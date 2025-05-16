import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotnchill/model/wallet_model.dart';
import 'package:hotnchill/services/wallet_service.dart';
import 'package:hotnchill/view_model/auth_view_model.dart';

import '../utils/utils.dart';

class WalletViewModel extends ChangeNotifier {
  WalletViewModel();

  final int _hundred = 100,
      _fiveHundred = 500,
      _thousand = 1000,
      _twentyThousand = 2000;
  final int _walletBalance = 0;
  WalletModel? _walletModel;

  final WalletService walletService = WalletService.instance;
  final AuthViewModel authViewModel = AuthViewModel();

  // Getters
  int get hundred => _hundred;

  int get fiveHundred => _fiveHundred;

  int get thousand => _thousand;

  int get twentyThousand => _twentyThousand;

  int get walletBalance => _walletBalance;

  WalletModel? get walletModel => _walletModel;

  /// This returns a live stream of transactions
  Future<void> getWalletTransactionStream(String uid) async {
    try {
      DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection("userWallet").doc(uid).get();
      if (snapshot.exists) {
        _walletModel = WalletModel.fromMap(snapshot.data() as Map<String, dynamic>);
      } else {
       // Utils.toastMessage("No wallet document found for UID: $uid");
      }
    } catch (e) {
      Utils.toastMessage("Error fetching transactions: ${e.toString()}");
    }
    notifyListeners();
  }

}