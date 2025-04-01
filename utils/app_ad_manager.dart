import 'package:aua_questions_app/Ads%20Helper/ads_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppAdManager {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  AppOpenAd? _appOpenAd;
  RewardedAd? _rewardedAd;

  // Banner ad methods
  void loadBannerAd({Function(BannerAd)? onAdLoaded}) {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd = ad as BannerAd;
          if (onAdLoaded != null) {
            onAdLoaded(_bannerAd!);
          }
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  // Interstitial ad methods
  void loadInterstitialAd({Function(InterstitialAd)? onAdLoaded}) {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              loadInterstitialAd(
                  onAdLoaded: onAdLoaded); // Reload after dismissal
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              loadInterstitialAd(
                  onAdLoaded: onAdLoaded); // Reload after failure
            },
          );

          if (onAdLoaded != null) {
            onAdLoaded(ad);
          }
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  // App open ad methods
  void loadOpenAd({Function(AppOpenAd)? onAdLoaded}) {
    AppOpenAd.load(
      adUnitId: AdHelper.openAppAdUnitId,
      request: const AdRequest(),
      orientation: AppOpenAd.orientationPortrait,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              // App open ad was dismissed
            },
          );

          if (onAdLoaded != null) {
            onAdLoaded(ad);
          }
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAd failed to load: ${error.message}');
        },
      ),
    );
  }

  // Rewarded ad methods
  void loadRewardedAd({Function(RewardedAd)? onAdLoaded}) {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              loadRewardedAd(onAdLoaded: onAdLoaded);
            },
          );

          if (onAdLoaded != null) {
            onAdLoaded(ad);
          }
        },
        onAdFailedToLoad: (error) {
          debugPrint('RewardedAd failed to load: ${error.message}');
        },
      ),
    );
  }

  // Show ads
  Future<bool> showInterstitial() async {
    if (_interstitialAd == null) {
      return false;
    }

    try {
      await _interstitialAd!.show();
      _interstitialAd = null;
      return true;
    } catch (e) {
      debugPrint('Error showing interstitial: $e');
      return false;
    }
  }

  Future<bool> showRewarded(
      {required Function(RewardItem) onUserEarnedReward}) async {
    if (_rewardedAd == null) {
      return false;
    }

    try {
      await _rewardedAd!.show;
      _rewardedAd = null;
      return true;
    } catch (e) {
      debugPrint('Error showing rewarded ad: $e');
      return false;
    }
  }

  // Create banner ad widget
  Widget getBannerAdWidget() {
    if (_bannerAd == null) {
      return const SizedBox(height: 50);
    }

    return SizedBox(
      height: 50,
      width: _bannerAd!.size.width.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  // Cleanup
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _appOpenAd?.dispose();
    _rewardedAd?.dispose();
  }
}
