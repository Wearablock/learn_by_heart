import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Premium subscription manager for ad-free experience
///
/// Handles in-app purchase for removing ads in Learn by Heart app.
class PremiumManager {
  PremiumManager._();

  static PremiumManager? _instance;
  static PremiumManager get shared => _instance ??= PremiumManager._();

  static const String _productId = 'learn_by_heart_remove_ads';
  static const String _storageKey = 'premium_unlocked';

  final _purchaseApi = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchaseListener;

  bool _storeReady = false;
  bool _premium = false;
  ProductDetails? _product;

  /// Whether store is available
  bool get storeAvailable => _storeReady;

  /// Whether user has premium (ad-free) status
  bool get isPremium => _premium;

  /// Product details for purchase UI
  ProductDetails? get productInfo => _product;

  /// Formatted price string
  String get displayPrice => _product?.price ?? '';

  /// Stream for premium status changes
  final _statusNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> get statusNotifier => _statusNotifier;

  /// Initialize premium manager
  Future<void> init() async {
    // Restore cached state
    final storage = await SharedPreferences.getInstance();
    _premium = storage.getBool(_storageKey) ?? false;
    _statusNotifier.value = _premium;

    // Check store availability
    _storeReady = await _purchaseApi.isAvailable();
    if (!_storeReady) {
      _log('Store unavailable');
      return;
    }

    // Setup purchase listener
    _purchaseListener = _purchaseApi.purchaseStream.listen(
      _processPurchaseUpdates,
      onError: (e) => _log('Purchase stream error: $e'),
    );

    // Fetch product info
    await _fetchProductInfo();

    // Sync with store
    await syncPurchaseStatus();
  }

  Future<void> _fetchProductInfo() async {
    final response = await _purchaseApi.queryProductDetails({_productId});

    if (response.notFoundIDs.isNotEmpty) {
      _log('Product not found: ${response.notFoundIDs}');
    }

    if (response.productDetails.isNotEmpty) {
      _product = response.productDetails.first;
      _log('Product: ${_product?.title} @ ${_product?.price}');
    }
  }

  void _processPurchaseUpdates(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      _handlePurchaseUpdate(purchase);
    }
  }

  Future<void> _handlePurchaseUpdate(PurchaseDetails purchase) async {
    switch (purchase.status) {
      case PurchaseStatus.pending:
        _log('Purchase pending: ${purchase.productID}');
        break;

      case PurchaseStatus.error:
        _log('Purchase error: ${purchase.error?.message}');
        break;

      case PurchaseStatus.purchased:
      case PurchaseStatus.restored:
        if (purchase.productID == _productId) {
          await _grantPremium();
        }
        break;

      case PurchaseStatus.canceled:
        _log('Purchase canceled');
        break;
    }

    // Finalize purchase
    if (purchase.pendingCompletePurchase) {
      await _purchaseApi.completePurchase(purchase);
    }
  }

  Future<void> _grantPremium() async {
    _premium = true;
    _statusNotifier.value = true;

    final storage = await SharedPreferences.getInstance();
    await storage.setBool(_storageKey, true);

    _log('Premium granted');
  }

  /// Purchase premium (ad removal)
  Future<bool> buyPremium() async {
    if (!_storeReady || _product == null) {
      _log('Cannot purchase: store unavailable or product not loaded');
      return false;
    }

    if (_premium) {
      _log('Already premium');
      return true;
    }

    try {
      final param = PurchaseParam(productDetails: _product!);
      return await _purchaseApi.buyNonConsumable(purchaseParam: param);
    } catch (e) {
      _log('Purchase error: $e');
      return false;
    }
  }

  /// Sync purchase status with store
  Future<void> syncPurchaseStatus() async {
    if (!_storeReady) return;

    try {
      await _purchaseApi.restorePurchases();
    } catch (e) {
      _log('Restore error: $e');
    }
  }

  void dispose() {
    _purchaseListener?.cancel();
    _statusNotifier.dispose();
  }

  void _log(String msg) {
    if (kDebugMode) {
      debugPrint('[PremiumManager] $msg');
    }
  }
}

/// Legacy alias for backward compatibility
@Deprecated('Use PremiumManager instead')
class IapService {
  static PremiumManager get instance => PremiumManager.shared;
  bool get adsRemoved => PremiumManager.shared.isPremium;
  Future<void> initialize() => PremiumManager.shared.init();
  Future<bool> purchaseRemoveAds() => PremiumManager.shared.buyPremium();
  Future<void> restorePurchases() => PremiumManager.shared.syncPurchaseStatus();
}
