import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/progress/presentation/progress_screen.dart';
import '../features/modules/presentation/modules_screen.dart';
import '../features/modules/presentation/select_topic_screen.dart';
import '../features/modules/presentation/module_story_screen.dart';
import '../features/modules/presentation/module_decision_screen.dart';
import '../features/modules/presentation/module_warning_screen.dart';
import '../features/modules/presentation/module_result_screen.dart';
import '../features/community/presentation/community_screen.dart';
import '../features/community/presentation/community_group_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/profile/presentation/edit_profile_screen.dart';
import '../features/profile/presentation/security_screen.dart';
import '../features/profile/presentation/help_center_screen.dart';
import '../features/protection/presentation/connect_guardian_screen.dart';
import '../features/home/presentation/streak_screen.dart';
import '../features/modules/presentation/game_screen.dart';
import '../features/modules/presentation/module_list_screen.dart';
import '../features/progress/presentation/certificate_screen.dart';
import '../features/chatbot/presentation/chatbot_screen.dart';
import 'main_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

// Fungsi helper untuk memberikan animasi transisi Fade+Scale secara global pada setiap rute
CustomTransitionPage<void> _buildPageWithAnimation(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Fade & Scale Transition premium ala iOS modern
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeOutQuart).animate(animation),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutQuart),
          ),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => '/splash',
    ),
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => _buildPageWithAnimation(context, state, const SplashScreen()),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => _buildPageWithAnimation(context, state, const LoginScreen()),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) => _buildPageWithAnimation(context, state, const RegisterScreen()),
    ),
    GoRoute(
      path: '/select_topic',
      pageBuilder: (context, state) => _buildPageWithAnimation(context, state, const SelectTopicScreen()),
    ),
    GoRoute(
      path: '/module_story',
      pageBuilder: (context, state) {
        final moduleId = state.extra as int? ?? 1;
        return _buildPageWithAnimation(context, state, ModuleStoryScreen(moduleId: moduleId));
      }
    ),
    GoRoute(
      path: '/module_decision',
      pageBuilder: (context, state) => _buildPageWithAnimation(context, state, const ModuleDecisionScreen()),
    ),
    GoRoute(
      path: '/module_warning',
      pageBuilder: (context, state) => _buildPageWithAnimation(context, state, const ModuleWarningScreen()),
    ),
    GoRoute(
      path: '/module_result',
      pageBuilder: (context, state) => _buildPageWithAnimation(context, state, const ModuleResultScreen()),
    ),
    GoRoute(
      path: '/connect_guardian',
      pageBuilder: (context, state) => _buildPageWithAnimation(context, state, const ConnectGuardianScreen()),
    ),
    GoRoute(
      path: '/community_group',
      pageBuilder: (context, state) {
        final groupData = state.extra as Map<String, dynamic>? ?? {};
        return _buildPageWithAnimation(context, state, CommunityGroupScreen(groupData: groupData));
      }
    ),
    GoRoute(
      path: '/edit_profile',
      pageBuilder: (context, state) => _buildPageWithAnimation(context, state, const EditProfileScreen()),
    ),
    GoRoute(
      path: '/security',
      pageBuilder: (context, state) => _buildPageWithAnimation(context, state, const SecurityScreen()),
    ),
    GoRoute(
      path: '/help_center',
      pageBuilder: (context, state) => _buildPageWithAnimation(context, state, const HelpCenterScreen()),
    ),
    GoRoute(
      path: '/streak',
      pageBuilder: (context, state) => _buildPageWithAnimation(context, state, const StreakScreen()),
    ),
    GoRoute(
      path: '/certificate',
      pageBuilder: (context, state) => _buildPageWithAnimation(context, state, const CertificateScreen()),
    ),
    GoRoute(
      path: '/game',
      pageBuilder: (context, state) => _buildPageWithAnimation(context, state, const GameScreen()),
    ),
    GoRoute(
      path: '/module_list',
      pageBuilder: (context, state) => _buildPageWithAnimation(context, state, const ModuleListScreen()),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (context, state, child) {
        // MainScaffold (Navigasi Bawah) tidak perlu transisi berlebihan, tapi biarkan fade
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: MainScaffold(child: child),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => _buildPageWithAnimation(context, state, const HomeScreen()),
        ),
        GoRoute(
          path: '/chatbot',
          pageBuilder: (context, state) => _buildPageWithAnimation(context, state, const ChatbotScreen()),
        ),
        GoRoute(
          path: '/modules',
          pageBuilder: (context, state) => _buildPageWithAnimation(context, state, const ModulesScreen()),
        ),
        GoRoute(
          path: '/community',
          pageBuilder: (context, state) => _buildPageWithAnimation(context, state, const CommunityScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => _buildPageWithAnimation(context, state, const ProfileScreen()),
        ),
      ],
    ),
  ],
);
