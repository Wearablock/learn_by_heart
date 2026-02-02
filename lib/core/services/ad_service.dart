import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'iap_service.dart';

/// Flashcard app monetization manager
///
/// Handles all ad-related functionality for the Learn by Heart app.
/// Uses test IDs in debug mode, production IDs in release.
class FlashcardAdsManager {
  FlashcardAdsManager._();

  static FlashcardAdsManager? _instance;
  static FlashcardAdsManager get shared => _instance ??= FlashcardAdsManager._();

  bool _initialized = false;

  /// Master switch for ads (set false for screenshots/testing)
  static const bool monetizationActive = true;

  /// Whether to display ads (respects premium status)
  static bool get canShowAds => monetizationActive && !PremiumManager.shared.isPremium;

  // --- Test Ad Units (Google official) ---
  static const _testBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const _testBannerIos = 'ca-app-pub-3940256099942544/2934735716';
  static const _testFullscreenAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const _testFullscreenIos = 'ca-app-pub-3940256099942544/4411468910';
  static const _testRewardAndroid = 'ca-app-pub-3940256099942544/5224354917';
  static const _testRewardIos = 'ca-app-pub-3940256099942544/1712485313';

  // --- Production Ad Units ---
  static const _liveBannerAndroid = 'ca-app-pub-8841058711613546/2272830457';
  static const _liveBannerIos = 'ca-app-pub-8841058711613546/2084354119';
  static const _liveFullscreenAndroid = 'ca-app-pub-8841058711613546/7333585444';
  static const _liveFullscreenIos = 'ca-app-pub-8841058711613546/8940172971';
  static const _liveRewardAndroid = 'ca-app-pub-8841058711613546/4515850414';
  static const _liveRewardIos = 'ca-app-pub-8841058711613546/2374764623';

  /// Use test ads in debug, live ads in release
  static bool get _isTestMode => kDebugMode;

  /// Banner ad unit ID for current platform
  static String get bannerUnitId {
    if (_isTestMode) {
      return Platform.isAndroid ? _testBannerAndroid : _testBannerIos;
    }
    return Platform.isAndroid ? _liveBannerAndroid : _liveBannerIos;
  }

  /// Fullscreen (interstitial) ad unit ID
  static String get fullscreenUnitId {
    if (_isTestMode) {
      return Platform.isAndroid ? _testFullscreenAndroid : _testFullscreenIos;
    }
    return Platform.isAndroid ? _liveFullscreenAndroid : _liveFullscreenIos;
  }

  /// Reward ad unit ID
  static String get rewardUnitId {
    if (_isTestMode) {
      return Platform.isAndroid ? _testRewardAndroid : _testRewardIos;
    }
    return Platform.isAndroid ? _liveRewardAndroid : _liveRewardIos;
  }

  /// Setup the ads SDK
  Future<void> setup() async {
    if (!monetizationActive || _initialized) return;

    try {
      await MobileAds.instance.initialize();
      _initialized = true;
      _debugLog('Ads SDK ready');
    } catch (e) {
      _debugLog('Ads SDK setup failed: $e');
    }
  }

  /// Build a banner ad instance
  BannerAd buildBanner({
    required void Function(Ad) onLoaded,
    required void Function(Ad, LoadAdError) onError,
  }) {
    return BannerAd(
      adUnitId: bannerUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onLoaded,
        onAdFailedToLoad: onError,
        onAdOpened: (_) => _debugLog('Banner opened'),
        onAdClosed: (_) => _debugLog('Banner closed'),
      ),
    );
  }

  /// Prepare a fullscreen ad
  Future<InterstitialAd?> prepareFullscreenAd() async {
    InterstitialAd? loadedAd;

    await InterstitialAd.load(
      adUnitId: fullscreenUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          loadedAd = ad;
          _debugLog('Fullscreen ad ready');
        },
        onAdFailedToLoad: (error) {
          _debugLog('Fullscreen ad error: ${error.message}');
        },
      ),
    );

    await Future.delayed(const Duration(milliseconds: 500));
    return loadedAd;
  }

  /// Prepare a reward ad
  Future<RewardedAd?> prepareRewardAd() async {
    RewardedAd? loadedAd;

    await RewardedAd.load(
      adUnitId: rewardUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          loadedAd = ad;
          _debugLog('Reward ad ready');
        },
        onAdFailedToLoad: (error) {
          _debugLog('Reward ad error: ${error.message}');
        },
      ),
    );

    await Future.delayed(const Duration(milliseconds: 500));
    return loadedAd;
  }

  /// Display a fullscreen ad
  Future<void> displayFullscreenAd(InterstitialAd ad) async {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _debugLog('Fullscreen ad dismissed');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _debugLog('Fullscreen ad show error: ${error.message}');
      },
    );
    await ad.show();
  }

  /// Display a reward ad and return whether user earned reward
  Future<bool> displayRewardAd(RewardedAd ad) async {
    bool rewardEarned = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _debugLog('Reward ad dismissed');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _debugLog('Reward ad show error: ${error.message}');
      },
    );

    await ad.show(
      onUserEarnedReward: (ad, reward) {
        rewardEarned = true;
        _debugLog('Reward earned: ${reward.amount} ${reward.type}');
      },
    );

    return rewardEarned;
  }

  void _debugLog(String msg) {
    if (kDebugMode) {
      debugPrint('[FlashcardAds] $msg');
    }
  }
}

/// Legacy alias for backward compatibility
@Deprecated('Use FlashcardAdsManager instead')
class AdService {
  static FlashcardAdsManager get instance => FlashcardAdsManager.shared;
  static bool get shouldShowAds => FlashcardAdsManager.canShowAds;
  Future<void> initialize() => FlashcardAdsManager.shared.setup();
}
