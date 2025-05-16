import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotnchill/services/stripe_service.dart';
import 'package:hotnchill/view_model/wallet_view_model.dart';
import 'package:provider/provider.dart';

import '../model/wallet_model.dart';
import '../services/wallet_service.dart';
import '../utils/utils.dart';
import '../view_model/auth_view_model.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  bool isHundred = false,
      isFiveHundred = false,
      isThousand = false,
      isTwentyThousand = false;
  final WalletService walletService = WalletService.instance;
  final walletViewModel = WalletViewModel();
  int amount = 0;
  final AuthViewModel authViewModel = AuthViewModel();

  Widget showWalletBalance(BuildContext context) {
    final walletViewModel = Provider.of<WalletViewModel>(context);
    final uid = authViewModel.currentUserId;
    if (uid != null) {
      Provider.of<WalletViewModel>(context, listen: false)
          .getWalletTransactionStream(uid);
    }
    final amount = walletViewModel.walletModel?.amount ?? '0';

    return Text(
      "Rs $amount",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 18,
        fontFamily: "poppins",
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final walletViewModel = Provider.of<WalletViewModel>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 5,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: Container(
                height: screenHeight * 0.11,
                width: screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Wallet",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: "poppins",
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Material(
              elevation: 5,
              child: Container(
                height: screenHeight * 0.1,
                width: screenWidth,
                decoration: BoxDecoration(color: Color(0x88887CB5)),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.06,
                        top: screenHeight * 0.01,
                      ),
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: Image.asset("assets/images/Wallet.png"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.05,
                        top: screenHeight * 0.02,
                      ),
                      child: Column(
                        spacing: 5,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Wallet",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontSize: 18,
                              fontFamily: "poppins",
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            child: showWalletBalance(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Add Money",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: "poppins",
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      isHundred = true;
                      isFiveHundred = false;
                      isThousand = false;
                      isTwentyThousand = false;
                      amount = walletViewModel.hundred;
                      setState(() {});
                    },
                    child: Material(
                      elevation: 2,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              "Rs ${walletViewModel.hundred.toString()}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      isHundred = false;
                      isFiveHundred = true;
                      isThousand = false;
                      isTwentyThousand = false;
                      amount = walletViewModel.fiveHundred;
                      setState(() {});
                    },
                    child: Material(
                      elevation: 2,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              "Rs ${walletViewModel.fiveHundred.toString()}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      isHundred = false;
                      isFiveHundred = false;
                      isThousand = true;
                      isTwentyThousand = false;
                      amount = walletViewModel.thousand;
                      setState(() {});
                    },
                    child: Material(
                      elevation: 2,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              "Rs ${walletViewModel.thousand.toString()}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      isHundred = false;
                      isFiveHundred = false;
                      isThousand = false;
                      isTwentyThousand = true;
                      amount = walletViewModel.twentyThousand;
                      setState(() {});
                    },
                    child: Material(
                      elevation: 2,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              "Rs ${walletViewModel.twentyThousand.toString()}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                try {
                  Utils.toastMessage("1. Starting payment process");
                  bool paymentSuccess = await StripeService.instance
                      .makePayment(amount.toString());

                  if (!paymentSuccess) {
                    Utils.toastMessage("Payment failed");
                    return;
                  }

                  final uid = authViewModel.currentUserId;
                  if (uid == null) {
                    Utils.toastMessage("User not logged in");
                    return;
                  }

                  // Get a single snapshot of the document
                  final walletDoc = await FirebaseFirestore.instance
                      .collection("userWallet")
                      .doc(uid)
                      .get();  // Note: Using .get() here

                  final paymentId = StripeService.instance.paymentIntent!['id'];
                  if (walletDoc.exists) {
                    final currentData = walletDoc.data() as Map<String, dynamic>;
                    final currentBalance = double.tryParse(currentData['amount'].toString()) ?? 0;
                    final updatedBalance = currentBalance + amount;

                    await walletService.updateWalletDetail(
                      uid: uid,
                      pid: StripeService.instance.paymentIntent!['id'],
                      amount: updatedBalance.toString(),
                    );
                  } else {
                    final walletModel = WalletModel(
                      userId: uid,
                      amount: amount.toString(),
                      currency: "USD",
                      paymentId: paymentId,
                      status: "completed",
                      type: "deposit",
                    );
                    await walletService.addWalletDetail(walletModel);
                  }
                  Utils.toastMessage("Money added successfully!");
                } catch (e) {
                  Utils.toastMessage("Error: ${e.toString()}");
                }
              },

              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.07,
                  vertical: screenHeight * 0.03,
                ),
                child: Container(
                  height: screenHeight * 0.06,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Text(
                      "Add Money",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "poppins",
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
