import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/home/home_screen.dart';
import '../features/search/search_screen.dart';
import '../features/favorites/favorites_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/recipe/recipe_detail_screen.dart';
import '../features/recipe/cooking_mode_screen.dart';
import '../features/categories/categories_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/onboarding/splash_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../shared/widgets/app_navigation.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppNavigation(shell: shell),
      branches: [
        StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (context, state) => const HomeScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/search', builder: (context, state) => const SearchScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/favorites', builder: (context, state) => const FavoritesScreen())]),
        StatefulShellBranch(routes: [GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen())]),
      ],
    ),
    GoRoute(path: '/categories', builder: (context, state) => const CategoriesScreen()),
    GoRoute(path: '/recipe/:id', builder: (context, state) => RecipeDetailScreen(recipeId: state.pathParameters['id']!)),
    GoRoute(path: '/cook/:id', builder: (context, state) => CookingModeScreen(recipeId: state.pathParameters['id']!)),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
  ],
);
