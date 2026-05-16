import 'package:anime_deduction_tower/app/app.dart';
import 'package:anime_deduction_tower/app/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
