import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../constants/pricing_constants.dart';

/// QR Code Payment Service for DupZero Pro
/// Supports: M-Pesa TZ, Airtel Money, CRDB, NMB,
///           M-Pesa KE, Visa/Mastercard, PayPal
/// Developed by Tavoo

enum PaymentMethod {
  mpesaTanzania,
  airtelTanzania,
  crdb,
  nmb,
  mpesaKenya,
  visaMastercard,
  paypal,
}

extension PaymentMethodExt on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.mpesaTanzania: return 'M-Pesa Tanzania';
      case PaymentMethod.airtelTanzania: return 'Airtel Money';
      case PaymentMethod.crdb:          return 'CRDB Bank';
      case PaymentMethod.nmb:           return 'NMB Bank';
      case PaymentMethod.mpesaKenya:    return 'M-Pesa Kenya';
      case PaymentMethod.visaMastercard:return 'Visa / Mastercard';
      case PaymentMethod.paypal:        return 'PayPal';
    }
  }

  String get icon {
    switch (this) {
      case PaymentMethod.mpesaTanzania: return '📱';
      case PaymentMethod.airtelTanzania:return '📡';
      case PaymentMethod.crdb:          return '🏦';
      case PaymentMethod.nmb:           return '🏦';
      case PaymentMethod.mpesaKenya:    return '📱';
      case PaymentMethod.visaMastercard:return '💳';
      case PaymentMethod.paypal:        return '🌐';
    }
  }

  String get country {
    switch (this) {
      case PaymentMethod.mpesaTanzania: return 'TZ';
      case PaymentMethod.airtelTanzania:return 'TZ';
      case PaymentMethod.crdb:          return 'TZ';
      case PaymentMethod.nmb:           return 'TZ';
      case PaymentMethod.mpesaKenya:    return 'KE';
      case PaymentMethod.visaMastercard:return 'WW';
      case PaymentMethod.paypal:        return 'WW';
    }
  }

  String get currency {
    switch (this) {
      case PaymentMethod.mpesaTanzania: return 'TZS';
      case PaymentMethod.airtelTanzania:return 'TZS';
      case PaymentMethod.crdb:          return 'TZS';
      case PaymentMethod.nmb:           return 'TZS';
      case PaymentMethod.mpesaKenya:    return 'KES';
      case PaymentMethod.visaMastercard:return 'USD';
      case PaymentMethod.paypal:        return 'USD';
    }
  }

  // Color for each payment method
  int get colorValue {
    switch (this) {
      case PaymentMethod.mpesaTanzania: return 0xFF00A651; // M-Pesa green
      case PaymentMethod.airtelTanzania:return 0xFFE40521; // Airtel red
      case PaymentMethod.crdb:          return 0xFF003087; // CRDB blue
      case PaymentMethod.nmb:           return 0xFF006633; // NMB green
      case PaymentMethod.mpesaKenya:    return 0xFF00A651; // M-Pesa green
      case PaymentMethod.visaMastercard:return 0xFF1A1F71; // Visa blue
      case PaymentMethod.paypal:        return 0xFF003087; // PayPal blue
    }
  }
}

class PaymentPlan {
  final String id;
  final String name;
  final double usdAmount;
  final String period;
  final String? badge;

  const PaymentPlan({
    required this.id,
    required this.name,
    required this.usdAmount,
    required this.period,
    this.badge,
  });

  // Convert USD to local currency
  double amountInCurrency(String currency) {
    switch (currency) {
      case 'TZS': return usdAmount * 2600; // ~TZS rate
      case 'KES': return usdAmount * 130;  // ~KES rate
      default:    return usdAmount;         // USD
    }
  }

  String formattedAmount(String currency) {
    final amount = amountInCurrency(currency);
    switch (currency) {
      case 'TZS': return 'Tsh ${amount.toStringAsFixed(0)}';
      case 'KES': return 'KSh ${amount.toStringAsFixed(0)}';
      default:    return '\$${amount.toStringAsFixed(2)}';
    }
  }
}

class QRPaymentData {
  final PaymentMethod method;
  final PaymentPlan plan;
  final String transactionId;
  final DateTime generatedAt;
  final DateTime expiresAt;

  const QRPaymentData({
    required this.method,
    required this.plan,
    required this.transactionId,
    required this.generatedAt,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  // How many minutes until expiry
  int get minutesLeft =>
    expiresAt.difference(DateTime.now()).inMinutes.clamp(0, 999);
}

class QRPaymentService {
  static final QRPaymentService _instance = QRPaymentService._();
  factory QRPaymentService() => _instance;
  QRPaymentService._();

  // Available plans
  static const plans = [
    PaymentPlan(
      id: PricingConstants.monthlyProductId,
      name: 'Monthly Pro',
      usdAmount: 2.99,
      period: '/month',
    ),
    PaymentPlan(
      id: PricingConstants.yearlyProductId,
      name: 'Yearly Pro',
      usdAmount: 19.99,
      period: '/year',
      badge: 'SAVE 44%',
    ),
    PaymentPlan(
      id: PricingConstants.lifetimeProductId,
      name: 'Lifetime Pro',
      usdAmount: 49.99,
      period: 'once',
      badge: 'BEST VALUE',
    ),
  ];

  // Generate QR code data string for a given payment method + plan
  String generateQRData({
    required PaymentMethod method,
    required PaymentPlan plan,
    required String transactionId,
  }) {
    final currency = method.currency;
    final amount = plan.amountInCurrency(currency);

    switch (method) {
      case PaymentMethod.mpesaTanzania:
        // Tanzania M-Pesa QR format (Lipa na M-Pesa)
        return _buildMpesaTZQR(amount, currency, transactionId, plan.name);

      case PaymentMethod.airtelTanzania:
        // Airtel Money Tanzania QR format
        return _buildAirtelQR(amount, currency, transactionId, plan.name);

      case PaymentMethod.crdb:
        // CRDB Bank QR (Tanzania bank transfer)
        return _buildCRDBQR(amount, currency, transactionId, plan.name);

      case PaymentMethod.nmb:
        // NMB Bank QR
        return _buildNMBQR(amount, currency, transactionId, plan.name);

      case PaymentMethod.mpesaKenya:
        // Kenya M-Pesa STK push QR
        return _buildMpesaKEQR(amount, currency, transactionId, plan.name);

      case PaymentMethod.visaMastercard:
        // EMVCo QR standard (used by Visa/Mastercard worldwide)
        return _buildEMVCoQR(amount, currency, transactionId, plan.name);

      case PaymentMethod.paypal:
        // PayPal.me payment link as QR
        return _buildPaypalQR(amount, currency, transactionId, plan.name);
    }
  }

  // ── M-Pesa Tanzania ─────────────────────────────────────────
  // Format: Vodacom/M-Pesa Lipa na M-Pesa business QR
  String _buildMpesaTZQR(double amount, String currency,
      String txId, String description) {
    // EMV-compatible format used by M-Pesa Tanzania
    return jsonEncode({
      'type': 'MPESA_TZ',
      'version': '01',
      'merchant': {
        'name': 'DupZero by Tavoo',
        'business_number': '000000', // Replace with real Paybill
        'account': 'PRO_$txId',
      },
      'transaction': {
        'id': txId,
        'amount': amount.toStringAsFixed(2),
        'currency': currency,
        'description': 'DupZero $description',
      },
      'app': 'dupzero',
      'expires': DateTime.now().add(const Duration(minutes: 30))
          .toIso8601String(),
    });
  }

  // ── Airtel Money Tanzania ────────────────────────────────────
  String _buildAirtelQR(double amount, String currency,
      String txId, String description) {
    return jsonEncode({
      'type': 'AIRTEL_TZ',
      'version': '01',
      'merchant': {
        'name': 'DupZero by Tavoo',
        'merchant_id': '000000', // Replace with real Airtel merchant ID
      },
      'transaction': {
        'id': txId,
        'amount': amount.toStringAsFixed(2),
        'currency': currency,
        'description': 'DupZero $description',
      },
      'app': 'dupzero',
    });
  }

  // ── CRDB Bank Tanzania ───────────────────────────────────────
  String _buildCRDBQR(double amount, String currency,
      String txId, String description) {
    return jsonEncode({
      'type': 'CRDB_TZ',
      'version': '01',
      'merchant': {
        'name': 'DupZero by Tavoo',
        'account': '00000000000', // Replace with real CRDB account
        'bank': 'CRDB Bank Tanzania',
      },
      'transaction': {
        'id': txId,
        'amount': amount.toStringAsFixed(2),
        'currency': currency,
        'reference': 'DUPZERO_$txId',
        'description': 'DupZero $description',
      },
    });
  }

  // ── NMB Bank Tanzania ────────────────────────────────────────
  String _buildNMBQR(double amount, String currency,
      String txId, String description) {
    return jsonEncode({
      'type': 'NMB_TZ',
      'version': '01',
      'merchant': {
        'name': 'DupZero by Tavoo',
        'account': '00000000000', // Replace with real NMB account
        'bank': 'NMB Bank Tanzania',
      },
      'transaction': {
        'id': txId,
        'amount': amount.toStringAsFixed(2),
        'currency': currency,
        'reference': 'DUPZERO_$txId',
        'description': 'DupZero $description',
      },
    });
  }

  // ── M-Pesa Kenya ─────────────────────────────────────────────
  String _buildMpesaKEQR(double amount, String currency,
      String txId, String description) {
    return jsonEncode({
      'type': 'MPESA_KE',
      'version': '01',
      'merchant': {
        'name': 'DupZero by Tavoo',
        'paybill': '000000', // Replace with real Safaricom Paybill
        'account': 'PRO',
      },
      'transaction': {
        'id': txId,
        'amount': amount.toStringAsFixed(2),
        'currency': currency,
        'description': 'DupZero $description',
      },
    });
  }

  // ── EMVCo (Visa/Mastercard worldwide) ────────────────────────
  // This is the international standard used by all banks
  String _buildEMVCoQR(double amount, String currency,
      String txId, String description) {
    // EMVCo QR Code Specification for Payment Systems
    final sb = StringBuffer();
    sb.write('000201');           // Payload format indicator
    sb.write('010212');           // Point of initiation (dynamic)
    // Merchant account info
    final merchantInfo = '0010com.dupzero0110DupZero';
    sb.write('26${merchantInfo.length.toString().padLeft(2, '0')}$merchantInfo');
    sb.write('52040000');         // Merchant category code
    sb.write('5303$currency');    // Transaction currency
    // Amount
    final amtStr = amount.toStringAsFixed(2);
    sb.write('54${amtStr.length.toString().padLeft(2, '0')}$amtStr');
    sb.write('5802TZ');           // Country code
    sb.write('5906Tavoo');        // Merchant name
    sb.write('6009Dar es Salaam');// Merchant city
    // Additional data
    final addData = '0107$txId';
    sb.write('62${addData.length.toString().padLeft(2, '0')}$addData');
    sb.write('6304');             // CRC placeholder
    return sb.toString();
  }

  // ── PayPal ───────────────────────────────────────────────────
  String _buildPaypalQR(double amount, String currency,
      String txId, String description) {
    // PayPal.me deep link — generates scannable payment QR
    final note = Uri.encodeComponent('DupZero $description - $txId');
    return 'https://paypal.me/tavoodupzero/${amount.toStringAsFixed(2)}$currency?note=$note';
    // Replace 'tavoodupzero' with your real PayPal.me username
  }

  // Generate unique transaction ID
  String generateTransactionId() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch.toString().substring(5);
    return 'DZ$timestamp';
  }
}
