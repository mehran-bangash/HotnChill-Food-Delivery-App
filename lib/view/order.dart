import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotnchill/view_model/item_detail_view_model.dart';
import 'package:provider/provider.dart';
import '../services/wallet_service.dart';
import '../utils/utils.dart';
import '../view_model/auth_view_model.dart';
import '../view_model/wallet_view_model.dart';
import 'dart:async'; // Add this import for StreamSubscription

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
 //var deducedPrice;
 // bool isDelete = false;
  bool _isLoading = false;
  final WalletService walletService = WalletService.instance;
  StreamSubscription? _cartSubscription;

  @override
  void initState() {
    super.initState();
    _initializeCart();
  }

  @override
  void dispose() {
    _cartSubscription?.cancel();
    super.dispose();
  }

  void _initializeCart() {
    final viewModel = Provider.of<ItemDetailViewModel>(context, listen: false);
    _cartSubscription = viewModel.getCartItems().listen((snapshot) {
      // ✅ Always call calculateTotal — even when empty
      viewModel.calculateTotal(snapshot.docs);
    });
  }

  Widget showItemCard() {
    return Consumer<ItemDetailViewModel>(
      builder: (context, viewModel, child) {
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: viewModel.getCartItems(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'Your cart is empty',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;

            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final ds = snapshot.data!.docs[index];
                final data = ds.data();

                return Padding(
                  padding: const EdgeInsets.only(top: 8, left: 15, right: 15),
                  child: Material(
                    color: Colors.white,
                    elevation: 10,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      height: screenHeight * 0.15,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 14),
                            child: Container(
                              height: 100,
                              width: 55,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  data['quantity']?.toString() ?? '0',
                                  style: const TextStyle(
                                    fontFamily: "poppins",
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              child: Image.network(
                                data['imageUrl'] ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  );
                                },
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  return loadingProgress == null
                                      ? child
                                      : const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['itemName']?.toString() ?? 'Item',
                                  style: const TextStyle(
                                    fontFamily: "poppins",
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  ' Rs ${data['totalPrice'] ?? '0'}',
                                  style: const TextStyle(
                                    fontFamily: "poppins",
                                    color: Colors.black,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.35),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: screenHeight * 0.001,
                                  ),
                                  child: GestureDetector(
                                    onTap:() {

                                      viewModel.removeCartItem(ds.id);
                                      //deducedPrice=viewModel.totalPrice-data['totalPrice'];
                                      //isDelete=true;
                                      setState(() {

                                      });
                                    },

                                    child: const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Material(
              elevation: 5,
              child: Container(
                height: screenHeight * 0.1,
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.white),
                child: const Center(
                  child: Text(
                    "Food Cart",
                    style: TextStyle(
                      fontFamily: "poppins",
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(child: showItemCard()),
            const Divider(height: 1, thickness: 2, color: Colors.black),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Price ",
                    style: TextStyle(
                      fontFamily: "poppins",
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Consumer<ItemDetailViewModel>(
                    builder:
                        (context, vm, child) => Text(
                          ' Rs ${vm.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: "poppins",
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                if (_isLoading) return;
                setState(() => _isLoading = true);

                try {
                  final authViewModel = AuthViewModel();
                  final viewModel = Provider.of<ItemDetailViewModel>(
                    context,
                    listen: false,
                  );
                  final walletViewModel = Provider.of<WalletViewModel>(
                    context,
                    listen: false,
                  );
                  final uid = authViewModel.currentUserId;

                  if (uid == null) {
                    Utils.toastMessage("User not logged in");
                    return;
                  }

                  await walletViewModel.getWalletTransactionStream(uid);
                  final amountStr = walletViewModel.walletModel?.amount ?? '0';
                  final walletAmount = double.tryParse(amountStr) ?? 0.0;

                  if (viewModel.total <= walletAmount) {
                    final newAmount = walletAmount - viewModel.total;
                    await walletService.updateWalletDetail(
                      uid: uid,
                      amount: newAmount.toStringAsFixed(2),
                    );
                    await viewModel.clearCart();
                    Utils.toastMessage("Order successfully placed");
                  } else {
                    Utils.toastMessage("Insufficient wallet balance");
                  }
                } catch (e) {
                  Utils.toastMessage("Checkout failed: ${e.toString()}");
                } finally {
                  setState(() => _isLoading = false);
                }
              },
              child: Container(
                height: 55,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "CheckOut",
                            style: TextStyle(
                              fontFamily: "poppins",
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
