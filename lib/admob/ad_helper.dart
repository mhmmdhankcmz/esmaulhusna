import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2723435209726138/1839869392'; // esmanın açıklandığı sayfanın reklamı
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    return null;
  }

  static String? get bannerAdUnitHome {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2723435209726138/1335638215'; // anasayfanın banner reklamı
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    return null;
  }

  // static String? get interstitialAdUnitId {
  //   if (Platform.isAndroid) {
  //     return 'ca-app-pub-2723435209726138~4059427954';
  //   } else if (Platform.isIOS) {
  //     return 'ca-app-pub-2723435209726138~4059427954';
  //   }
  //   return null;
  // }

  // static String? get rewardedAdUnitId {
  //   if (Platform.isAndroid) {
  //     return 'ca-app-pub-2723435209726138~4059427954';
  //   } else if (Platform.isIOS) {
  //     return 'ca-app-pub-2723435209726138~4059427954';
  //   }
  //   return null;
  // }
  static final BannerAdListener bannerListener = BannerAdListener(
      onAdLoaded: (ad) => debugPrint('Ad loaded'),
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        debugPrint('Ad failed to load: $error');
      });
}
