import 'package:anime_deduction_tower/features/characters/presentation/screens/character_library_screen.dart';
import 'package:anime_deduction_tower/features/game/presentation/screens/category_selection_screen.dart';
import 'package:anime_deduction_tower/features/game/presentation/screens/game_setup_screen.dart';
import 'package:anime_deduction_tower/features/game/presentation/screens/match_screen.dart';
import 'package:anime_deduction_tower/features/game/presentation/screens/result_screen.dart';
import 'package:anime_deduction_tower/features/game/presentation/screens/turn_transition_screen.dart';
import 'package:anime_deduction_tower/features/home/presentation/screens/home_screen.dart';
import 'package:anime_deduction_tower/features/home/presentation/screens/splash_screen.dart';
import 'package:anime_deduction_tower/features/profile/presentation/screens/profile_screen.dart';
import 'package:anime_deduction_tower/features/settings/presentation/screens/settings_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  const AppRoutes._();

  static const splash = '/';
  static const home = '/home';
  static const setup = '/setup';
  static const categorySelection = '/category-selection';
  static const turnTransition = '/turn-transition';
  static const match = '/match';
  static const result = '/result';
  static const characters = '/characters';
  static const settings = '/settings';
  static const profile = '/profile';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashScreen()),
    GoRoute(path: AppRoutes.home, builder: (context, state) => const HomeScreen()),
    GoRoute(path: AppRoutes.setup, builder: (context, state) => const GameSetupScreen()),
    GoRoute(
      path: AppRoutes.categorySelection,
      builder: (context, state) => const CategorySelectionScreen(),
    ),
    GoRoute(
      path: AppRoutes.turnTransition,
      builder: (context, state) => const TurnTransitionScreen(),
    ),
    GoRoute(path: AppRoutes.match, builder: (context, state) => const MatchScreen()),
    GoRoute(path: AppRoutes.result, builder: (context, state) => const ResultScreen()),
    GoRoute(
      path: AppRoutes.characters,
      builder: (context, state) => const CharacterLibraryScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(path: AppRoutes.profile, builder: (context, state) => const ProfileScreen()),
  ],
);
