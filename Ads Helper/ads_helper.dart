import 'dart:io';

/// Utility class to manage ad unit IDs for different platforms
class AdHelper {
  // Banner ad unit IDs
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return ''; // Add your Android banner ad unit ID here
    } else if (Platform.isIOS) {
      return ''; // Add your iOS banner ad unit ID here
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // Interstitial ad unit IDs
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return ''; // Add your Android interstitial ad unit ID here
    } else if (Platform.isIOS) {
      return ''; // Add your iOS interstitial ad unit ID here
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // App open ad unit IDs
  static String get openAppAdUnitId {
    if (Platform.isAndroid) {
      return ''; // Add your Android app open ad unit ID here
    } else if (Platform.isIOS) {
      return ''; // Add your iOS app open ad unit ID here
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // Rewarded ad unit IDs
  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return ''; // Add your Android rewarded ad unit ID here
    } else if (Platform.isIOS) {
      return ''; // Add your iOS rewarded ad unit ID here
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
