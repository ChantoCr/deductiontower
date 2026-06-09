import 'package:anime_deduction_tower/core/config/firebase_runtime_config.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAppInitializer {
  FirebaseAppInitializer._();

  static bool _attempted = false;
  static bool _initialized = false;

  static Future<bool> initializeIfConfigured() async {
    if (_initialized || Firebase.apps.isNotEmpty) {
      _initialized = true;
      return true;
    }

    if (_attempted) {
      return _initialized;
    }

    _attempted = true;
    final config = FirebaseRuntimeConfig.fromEnvironment();
    if (!config.isConfigured) {
      return false;
    }

    await Firebase.initializeApp(options: config.toOptions());
    _initialized = true;
    return true;
  }

  static Future<void> ensureInitializedForOnlineBackend() async {
    final didInitialize = await initializeIfConfigured();
    if (didInitialize) {
      return;
    }

    throw StateError(
      'Firebase backend is not configured. Provide FIREBASE_API_KEY, '
      'FIREBASE_APP_ID, FIREBASE_MESSAGING_SENDER_ID, and '
      'FIREBASE_PROJECT_ID via --dart-define before using the Firebase backend.',
    );
  }
}
