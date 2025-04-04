import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../states/counter_state.dart';
import '../states/theme_state.dart';
import 'app_logo.dart';

class CounterPage extends StatefulWidget {
  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  // Test ad unit ID for Android
  final adUnitId = 'ca-app-pub-3940256099942544/9214589741';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bannerAd == null) {
      loadAd();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  /// Loads a banner ad.
  void loadAd() async {
    if (kIsWeb) {
      debugPrint('Skipping ad load on web platform');
      return;
    }

    try {
      // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
      final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
          MediaQuery.sizeOf(context).width.truncate());
      
      if (size == null) {
        debugPrint('Failed to get ad size');
        return;
      }

      debugPrint('Loading banner ad with size: ${size.width}x${size.height}');
      
      _bannerAd = BannerAd(
        adUnitId: adUnitId,
        request: const AdRequest(),
        size: size,
        listener: BannerAdListener(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('Ad loaded successfully');
            setState(() {
              _isLoaded = true;
            });
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (ad, err) {
            debugPrint('BannerAd failed to load: $err');
            debugPrint('Error code: ${err.code}');
            debugPrint('Error message: ${err.message}');
            debugPrint('Error domain: ${err.domain}');
            // Dispose the ad here to free resources.
            ad.dispose();
          },
          onAdImpression: (ad) {
            debugPrint('Ad impression recorded');
          },
        ),
      )..load();
    } catch (e) {
      debugPrint('Error loading ad: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var counterState = context.watch<CounterState>();
    var themeState = context.watch<ThemeState>();

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        counterState.increment();
      },
      onLongPress: () {
        HapticFeedback.heavyImpact();
        counterState.reset();
      },
      child: Scaffold(
        body: Container(
          color: Theme.of(context).colorScheme.surface,
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppLogo(size: 80),
                    const SizedBox(height: 40),
                    Text(
                      '${counterState.count}',
                      style: TextStyle(
                        fontSize: 120,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 48,
                right: 16,
                child: IconButton(
                  icon: Icon(
                    themeState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () {
                    themeState.toggleTheme();
                  },
                ),
              ),
              Positioned(
                bottom: _bannerAd != null && _isLoaded ? _bannerAd!.size.height.toDouble() + 48 : 48,
                left: 0,
                right: 0,
                child: Center(
                  child: kIsWeb
                      ? InkWell(
                          onTap: () async {
                            final Uri url = Uri.parse('https://qbitservices.com');
                            try {
                              if (await canLaunchUrl(url)) {
                                await launchUrl(
                                  url,
                                  webOnlyWindowName: '_blank',
                                );
                              }
                            } catch (e) {
                              // Handle any errors silently
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface.withAlpha(25),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.onSurface.withAlpha(77),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '©2025 QBitServices',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Text(
                          '©2025 QBitServices',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
                            fontSize: 12,
                          ),
                        ),
                ),
              ),
              if (_bannerAd != null && _isLoaded)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: SizedBox(
                      width: _bannerAd!.size.width.toDouble(),
                      height: _bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd!),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 