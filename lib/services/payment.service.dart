// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_paymob/flutter_paymob.dart';
// import 'package:flutter_paymob/paymob_response.dart';

// class PaymentService {
//   // Initialize FlutterPaymob instance
//   final FlutterPaymob _paymob = FlutterPaymob.instance;

//   Future<void> initializePaymentService() async {
//     try {
//       await _paymob.initialize(
//         apiKey: dotenv.get('API_KEY'),
//         integrationID: int.parse(dotenv.get('integrationID')),
//         walletIntegrationId: int.parse(dotenv.get('walletIntegrationId')),
//         iFrameID: int.parse(dotenv.get('iFrameID')),
//       );
//       print('Paymob service initialized successfully.');
//     } catch (e) {
//       print('Error initializing Paymob service: $e');
//     }
//   }

//   Future<void> payWithCard(
//     BuildContext context,
//     double amount, {
//     Function(PaymentPaymobResponse)? onPayment,
//   }) async {
//     try {
//       await _paymob.payWithCard(
//         context: context,
//         currency: "EGP",
//         amount: amount,
//         onPayment: onPayment,
//       );
//     } catch (e) {
//       print('Error processing card payment: $e');
//     }
//   }

//   Future<void> payWithWallet(
//     BuildContext context,
//     double amount,
//     String walletNumber, {
//     Function(PaymentPaymobResponse)? onPayment,
//   }) async {
//     try {
//       await _paymob.payWithWallet(
//         context: context,
//         currency: "EGP",
//         amount: amount,
//         number: walletNumber,
//         onPayment: onPayment,
//       );
//     } catch (e) {
//       print('Error processing wallet payment: $e');
//     }
//   }
// }
