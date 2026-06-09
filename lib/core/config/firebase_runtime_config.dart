import 'package:firebase_core/firebase_core.dart';

class FirebaseRuntimeConfig {
  const FirebaseRuntimeConfig({
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
    this.authDomain,
    this.storageBucket,
    this.measurementId,
    this.iosBundleId,
  });

  factory FirebaseRuntimeConfig.fromEnvironment() {
    return const FirebaseRuntimeConfig(
      apiKey: String.fromEnvironment('FIREBASE_API_KEY'),
      appId: String.fromEnvironment('FIREBASE_APP_ID'),
      messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
      projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
      authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
      storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
      measurementId: String.fromEnvironment('FIREBASE_MEASUREMENT_ID'),
      iosBundleId: String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID'),
    );
  }

  final String apiKey;
  final String appId;
  final String messagingSenderId;
  final String projectId;
  final String? authDomain;
  final String? storageBucket;
  final String? measurementId;
  final String? iosBundleId;

  bool get isConfigured =>
      apiKey.isNotEmpty &&
      appId.isNotEmpty &&
      messagingSenderId.isNotEmpty &&
      projectId.isNotEmpty;

  FirebaseOptions toOptions() {
    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      authDomain: _nullable(authDomain),
      storageBucket: _nullable(storageBucket),
      measurementId: _nullable(measurementId),
      iosBundleId: _nullable(iosBundleId),
    );
  }

  String? _nullable(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    return value.trim();
  }
}
