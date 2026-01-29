import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// In-App Purchase Service for managing ad removal
class IapService {
  static final IapService _instance = IapService._internal();
  factory IapService() => _instance;
  IapService._internal();

  static const String removeAdsId = 'learn_by_heart_remove_ads';
  static const String _adsRemovedKey = 'ads_removed';

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _isAvailable = false;
  bool _adsRemoved = false;
  ProductDetails? _removeAdsProduct;

  bool get isAvailable => _isAvailable;
  bool get adsRemoved => _adsRemoved;
  ProductDetails? get removeAdsProduct => _removeAdsProduct;

  final StreamController<bool> _adsRemovedController =
      StreamController<bool>.broadcast();
  Stream<bool> get adsRemovedStream => _adsRemovedController.stream;

  /// Initialize the IAP service
  Future<void> initialize() async {
    // Load cached purchase state
    final prefs = await SharedPreferences.getInstance();
    _adsRemoved = prefs.getBool(_adsRemovedKey) ?? false;

    // Check if store is available
    _isAvailable = await _inAppPurchase.isAvailable();
    if (!_isAvailable) {
      _log('Store not available');
      return;
    }

    // Listen to purchase updates
    _subscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (error) {
        _log('Purchase stream error: $error');
      },
    );

    // Load products
    await _loadProducts();

    // Restore previous purchases
    await restorePurchases();
  }

  Future<void> _loadProducts() async {
    final response = await _inAppPurchase.queryProductDetails({removeAdsId});

    if (response.notFoundIDs.isNotEmpty) {
      _log('Products not found: ${response.notFoundIDs}');
    }

    if (response.productDetails.isNotEmpty) {
      _removeAdsProduct = response.productDetails.first;
      _log('Product loaded: ${_removeAdsProduct?.title} - ${_removeAdsProduct?.price}');
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchase in purchaseDetailsList) {
      _handlePurchase(purchase);
    }
  }

  Future<void> _handlePurchase(PurchaseDetails purchase) async {
    if (purchase.status == PurchaseStatus.pending) {
      _log('Purchase pending: ${purchase.productID}');
    } else if (purchase.status == PurchaseStatus.error) {
      _log('Purchase error: ${purchase.error?.message}');
    } else if (purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored) {
      // Verify and deliver the product
      if (purchase.productID == removeAdsId) {
        await _deliverRemoveAds();
      }
    } else if (purchase.status == PurchaseStatus.canceled) {
      _log('Purchase canceled');
    }

    // Complete the purchase
    if (purchase.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchase);
    }
  }

  Future<void> _deliverRemoveAds() async {
    _adsRemoved = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_adsRemovedKey, true);
    _adsRemovedController.add(true);
    _log('Ads removed successfully');
  }

  /// Purchase the remove ads product
  Future<bool> purchaseRemoveAds() async {
    if (!_isAvailable || _removeAdsProduct == null) {
      _log('Cannot purchase: store not available or product not loaded');
      return false;
    }

    if (_adsRemoved) {
      _log('Ads already removed');
      return true;
    }

    final purchaseParam = PurchaseParam(
      productDetails: _removeAdsProduct!,
    );

    try {
      final success = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
      return success;
    } catch (e) {
      _log('Purchase failed: $e');
      return false;
    }
  }

  /// Restore previous purchases
  Future<void> restorePurchases() async {
    if (!_isAvailable) return;

    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      _log('Restore purchases failed: $e');
    }
  }

  /// Get formatted price string
  String get priceString {
    return _removeAdsProduct?.price ?? '';
  }

  void dispose() {
    _subscription?.cancel();
    _adsRemovedController.close();
  }

  static void _log(String message) {
    if (kDebugMode) {
      debugPrint('[IapService] $message');
    }
  }
}
