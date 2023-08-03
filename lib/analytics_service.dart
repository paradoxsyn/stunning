import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:firebase_analytics_web/firebase_analytics_web.dart';
import 'package:flutter/widgets.dart';

class AnalyticsService {
  late dynamic _analytics;

  // Constructor
  AnalyticsService() {
    // Initialize analytics based on platform
    if (kIsWeb) {
      //_analytics = FirebaseAnalyticsWeb();
    } else {
      _analytics = FirebaseAnalytics.instance;
    }
  }

  // Custom methods for tracking events, screens, etc.
  Future<void> trackEvent(String name, Map<String, dynamic> parameters) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  Future<void> trackCommerce() async {
    // A pair of boots
    final boots = AnalyticsEventItem(
      itemId: "SKU_456",
      itemName: "boots",
      itemCategory: "shoes",
      itemVariant: "brown",
      itemBrand: "Google",
      price: 24.99,
    );
    await _analytics.logSelectItem(
        itemListId: "L001", itemListName: "Related", items: [boots]);
  }

  // Custom method to log screen views
  void logScreen(String screenName, String screenClassOverride) {
    if (!kIsWeb) {
      // For mobile, use the Firebase Analytics screen view logging
      _analytics.setCurrentScreen(
        screenName: screenName,
        screenClassOverride: screenClassOverride,
      );
    } else {
      // For web, manually log page views (you can use your preferred analytics library for web)
      // For example, if you use Google Analytics for web:
      // ga.sendPageView(pageName: screenName);
      // or
      // gtag('config', 'GA_MEASUREMENT_ID', {'page_path': '/screenName'});
    }
  }

  // Get the analytics observer for navigation tracking (mobile only)
  FirebaseAnalyticsObserver getAnalyticsObserver() {
    if (_analytics is FirebaseAnalytics) {
      return FirebaseAnalyticsObserver(analytics: _analytics);
    } else {
      // Return an empty observer for web
      return NoOpObserver(_analytics);
    }
  }
}

class NoOpObserver extends FirebaseAnalyticsObserver {
  NoOpObserver(FirebaseAnalytics analytics) : super(analytics: analytics);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Do nothing when analytics is not available
  }
}
