import 'package:cloud_firestore/cloud_firestore.dart';
class WalletModel {
  final String? userId;
  final String? amount;
  final String? paymentId;
  final String? type;
  final String? status;
  final String? currency;
  WalletModel({
    this.currency,
    this.userId,
    this.amount,
    this.paymentId,
    this.type,
    this.status,
  });
  Map<String, dynamic> walletMap() {
    return {
      'userId': userId,
      'amount': amount,
      'paymentId': paymentId,
      'status': status,
      'timestamp': FieldValue.serverTimestamp(),
      'type': type, // or 'withdrawal'
      'currency': currency,
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      userId: map['userId'],
      amount: map['amount'],
      paymentId: map['paymentId'],
      type: map['deposit'],
      status: map['completed'],
      currency: map['currency'],

    );
  }
}
