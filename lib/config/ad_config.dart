class AdConfig {
  static const bool isRelease = bool.fromEnvironment('dart.vm.product');
  
  // Test ad unit IDs (for debug builds)
  static const String testBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  
  // Production ad unit IDs (for release builds)
  static const String productionBannerAdUnitId = 'ca-app-pub-1009677311497002/5155331165';
  
  // Get the appropriate ad unit ID based on build type
  static String get bannerAdUnitId => isRelease ? productionBannerAdUnitId : testBannerAdUnitId;
} 