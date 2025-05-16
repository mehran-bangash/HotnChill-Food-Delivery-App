import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';  // <--- dotenv import
import '../utils/utils.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();
  Map<String, dynamic>? paymentIntent;

  Future<bool> makePayment(String amount) async {
    try {
      paymentIntent = await createPayment(amount, "USD");
      if (paymentIntent == null) {
        Utils.toastMessage("Failed to create payment intent");
        return false;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: "Mehran ALi",
        ),
      );

      bool result = await displayPaymentSheet();
      return result;
    } catch (e) {
      Utils.toastMessage("Payment failed: ${e.toString()}");
      return false;
    }
  }

  Future<Map<String, dynamic>?> createPayment(String amount, String currency) async {
    try {
      final calculatedAmount = calculateAmount(amount);

      final body = {
        'amount': calculatedAmount.toString(),
        'currency': currency.toLowerCase(),
        'payment_method_types[]': 'card'
      };

      final response = await Dio().post(
        "https://api.stripe.com/v1/payment_intents",
        data: body,
        options: Options(
          headers: {
            // Load secret key from .env file here
            "Authorization": "Bearer ${dotenv.env['STRIPE_SECRET_KEY'] ?? ''}",
            "Content-Type": "application/x-www-form-urlencoded",
          },
        ),
      );

      return response.data as Map<String, dynamic>;
    } catch (e) {
      Utils.toastMessage('Payment creation error: $e');
      rethrow;
    }
  }

  Future<bool> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      Utils.toastMessage("Payment successful");
      return true;
    } on StripeException catch (e) {
      Utils.toastMessage("Payment cancelled or failed: ${e.error.localizedMessage}");
      return false;
    } catch (e) {
      Utils.toastMessage("Unexpected error: ${e.toString()}");
      return false;
    }
  }

  int calculateAmount(String amount) {
    return (double.parse(amount) * 100).round();
  }
}
