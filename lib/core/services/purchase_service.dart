import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../constants/pricing_constants.dart';

/// Handles real Google Play / App Store subscriptions
/// Developed by Tavoo — DupZero
class PurchaseService {
  static final PurchaseService _instance = PurchaseService._();
  factory PurchaseService() => _instance;
  PurchaseService._();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;
  final _productIds = {
    PricingConstants.monthlyProductId,
    PricingConstants.yearlyProductId,
    PricingConstants.lifetimeProductId,
  };

  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  // Callbacks
  Function(PurchaseDetails)? onPurchaseSuccess;
  Function(String)? onPurchaseError;

  Future<void> initialize() async {
    final available = await _iap.isAvailable();
    if (!available) {
      debugPrint('In-App Purchase not available on this device');
      return;
    }

    // Listen to purchase updates
    _sub = _iap.purchaseStream.listen(
      _handlePurchases,
      onError: (e) => debugPrint('Purchase stream error: $e'),
    );

    // Load products from store
    await _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final response = await _iap.queryProductDetails(_productIds);
      if (response.error != null) {
        debugPrint('Product query error: ${response.error}');
        return;
      }
      _products = response.productDetails;
      debugPrint('Loaded ${_products.length} products from store');
    } catch (e) {
      debugPrint('Failed to load products: $e');
    }
  }

  Future<bool> buySubscription(String productId) async {
    final product = _products.where((p) => p.id == productId).firstOrNull;
    if (product == null) {
      onPurchaseError?.call('Product not found. Check your internet connection.');
      return false;
    }

    try {
      final param = PurchaseParam(productDetails: product);
      if (productId == PricingConstants.lifetimeProductId) {
        return await _iap.buyNonConsumable(purchaseParam: param);
      } else {
        return await _iap.buyNonConsumable(purchaseParam: param);
      }
    } catch (e) {
      onPurchaseError?.call(e.toString());
      return false;
    }
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void _handlePurchases(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _verifyAndComplete(purchase);
        case PurchaseStatus.error:
          onPurchaseError?.call(
            purchase.error?.message ?? 'Purchase failed');
          _iap.completePurchase(purchase);
        case PurchaseStatus.canceled:
          debugPrint('Purchase cancelled by user');
        case PurchaseStatus.pending:
          debugPrint('Purchase pending...');
      }
    }
  }

  Future<void> _verifyAndComplete(PurchaseDetails purchase) async {
    // In production: verify receipt with your backend server
    // For now: trust the store verification
    if (purchase.pendingCompletePurchase) {
      await _iap.completePurchase(purchase);
    }
    onPurchaseSuccess?.call(purchase);
  }

  void dispose() {
    _sub?.cancel();
  }
}
