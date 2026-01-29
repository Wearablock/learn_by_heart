import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// AdMob Ad Service
///
/// Test IDs are used by default. Replace with real IDs for production.
/// To use real IDs, create lib/core/config/ad_config.dart with real values.
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  bool _isInitialized = false;

  // Test Ad Unit IDs (Google official test IDs)
  static const String _testBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testBannerIos = 'ca-app-pub-3940256099942544/2934735716';
  static const String _testInterstitialAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String _testInterstitialIos = 'ca-app-pub-3940256099942544/4411468910';
  static const String _testRewardedAndroid = 'ca-app-pub-3940256099942544/5224354917';
  static const String _testRewardedIos = 'ca-app-pub-3940256099942544/1712485313';

  // Production Ad Unit IDs
  static const String _prodBannerAndroid = 'ca-app-pub-8841058711613546/2272830457';
  static const String _prodBannerIos = 'ca-app-pub-8841058711613546/2084354119';
  static const String _prodInterstitialAndroid = 'ca-app-pub-8841058711613546/7333585444';
  static const String _prodInterstitialIos = 'ca-app-pub-8841058711613546/8940172971';
  static const String _prodRewardedAndroid = 'ca-app-pub-8841058711613546/4515850414';
  static const String _prodRewardedIos = 'ca-app-pub-8841058711613546/2374764623';

  /// Whether to use test ads
  /// - In debug mode: always uses test ads
  /// - In release mode: uses production ads
  static bool get useTestAds => kDebugMode;

  /// Get Banner Ad Unit ID
  static String get bannerAdUnitId {
    if (useTestAds) {
      return Platform.isAndroid ? _testBannerAndroid : _testBannerIos;
    }
    return Platform.isAndroid ? _prodBannerAndroid : _prodBannerIos;
  }

  /// Get Interstitial Ad Unit ID
  static String get interstitialAdUnitId {
    if (useTestAds) {
      return Platform.isAndroid ? _testInterstitialAndroid : _testInterstitialIos;
    }
    return Platform.isAndroid ? _prodInterstitialAndroid : _prodInterstitialIos;
  }

  /// Get Rewarded Ad Unit ID
  static String get rewardedAdUnitId {
    if (useTestAds) {
      return Platform.isAndroid ? _testRewardedAndroid : _testRewardedIos;
    }
    return Platform.isAndroid ? _prodRewardedAndroid : _prodRewardedIos;
  }

  /// Initialize Mobile Ads SDK
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      debugPrint('AdMob initialized successfully');
    } catch (e) {
      debugPrint('AdMob initialization failed: $e');
    }
  }

  /// Create a Banner Ad
  BannerAd createBannerAd({
    required void Function(Ad) onAdLoaded,
    required void Function(Ad, LoadAdError) onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdOpened: (ad) => debugPrint('Banner ad opened'),
        onAdClosed: (ad) => debugPrint('Banner ad closed'),
      ),
    );
  }

  /// Load Interstitial Ad
  Future<InterstitialAd?> loadInterstitialAd() async {
    InterstitialAd? interstitialAd;

    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          debugPrint('Interstitial ad loaded');
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial ad failed to load: ${error.message}');
          interstitialAd = null;
        },
      ),
    );

    // Wait for ad to load
    await Future.delayed(const Duration(milliseconds: 500));
    return interstitialAd;
  }

  /// Load Rewarded Ad
  Future<RewardedAd?> loadRewardedAd() async {
    RewardedAd? rewardedAd;

    await RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;
          debugPrint('Rewarded ad loaded');
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded ad failed to load: ${error.message}');
          rewardedAd = null;
        },
      ),
    );

    // Wait for ad to load
    await Future.delayed(const Duration(milliseconds: 500));
    return rewardedAd;
  }

  /// Show Interstitial Ad
  Future<void> showInterstitialAd(InterstitialAd ad) async {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        debugPrint('Interstitial ad dismissed');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        debugPrint('Interstitial ad failed to show: ${error.message}');
      },
    );
    await ad.show();
  }

  /// Show Rewarded Ad
  Future<bool> showRewardedAd(RewardedAd ad) async {
    bool rewarded = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        debugPrint('Rewarded ad dismissed');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        debugPrint('Rewarded ad failed to show: ${error.message}');
      },
    );

    await ad.show(
      onUserEarnedReward: (ad, reward) {
        rewarded = true;
        debugPrint('User earned reward: ${reward.amount} ${reward.type}');
      },
    );

    return rewarded;
  }
}
