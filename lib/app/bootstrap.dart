import 'dart:async';

import 'package:anime_deduction_tower/app/firebase_app_initializer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseAppInitializer.initializeIfConfigured();
  final app = await builder();
  runApp(ProviderScope(child: app));
}
