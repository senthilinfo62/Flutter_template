// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/settings/presentation/pages/notification_settings_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/todos/presentation/pages/add_edit_todo_page.dart';
import '../../features/todos/presentation/pages/todos_page.dart';
import '../widgets/main_navigation.dart';

/// App router configuration using GoRouter
class AppRouter {
  static const String home = '/';
  static const String todos = '/todos';
  static const String addTodo = '/add-todo';
  static const String editTodo = '/edit-todo';
  static const String settings = '/settings';
  static const String notificationSettings = '/notification-settings';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String profile = '/profile';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainNavigation(child: child),
        routes: [
          GoRoute(path: home, builder: (context, state) => const TodosPage()),
          GoRoute(path: todos, builder: (context, state) => const TodosPage()),
          GoRoute(
            path: settings,
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: profile,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
      GoRoute(
        path: addTodo,
        builder: (context, state) => const AddEditTodoPage(),
      ),
      GoRoute(
        path: editTodo,
        builder: (context, state) => AddEditTodoPage(todo: state.extra),
      ),
      GoRoute(
        path: notificationSettings,
        builder: (context, state) => const NotificationSettingsPage(),
      ),
      GoRoute(path: login, builder: (context, state) => const LoginPage()),
      GoRoute(path: signup, builder: (context, state) => const SignupPage()),
    ],
  );
}
