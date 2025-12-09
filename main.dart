import 'package:flutter/material.dart';

// Login page (your existing one)
import 'package:flutter_application_1/features/listings/presentation/pages/login_page.dart';

// Themed app + navigation
import 'package:flutter_application_1/features/listings/presentation/pages/main_navigation.dart';
import 'package:flutter_application_1/features/listings/presentation/pages/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('APP START: Theme toggle enabled');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Company Marketplace',

      // Use your custom themes
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // 🔹 Start at LoginPage (from code1)
      home: LoginPage(
          // if you later want, you can pass callbacks/params here
          // but for now we keep it simple
          ),
    );
  }
}

/// Wrapper widget to pass theme toggle to MainNavigation
/// You will use this AFTER login, e.g. from LoginPage:
/// Navigator.pushReplacement(
///   context,
///   MaterialPageRoute(
///     builder: (_) => MainNavigationWithTheme(
///       isDarkMode: isDarkMode,
///       onThemeToggle: toggleFn,
///     ),
///   ),
/// );
class MainNavigationWithTheme extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const MainNavigationWithTheme({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    // ⛔ REMOVE themeToggleButton parameter completely
    return const MainNavigation();
  }
}


/// Theme Toggle Button Widget (from code2)
class ThemeToggleButton extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggle;

  const ThemeToggleButton({
    Key? key,
    required this.isDarkMode,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: 70,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDarkMode
                ? const Color(0xFFB19F91) // warmTaupe for dark mode
                : const Color(0xFF48494B), // smokedCharcoal for light mode
            width: 2.5,
          ),
          color: isDarkMode
              ? const Color(0xFF1C1C1C) // deepOnyx for dark mode
              : const Color(0xFFF8F4F0), // porcelainWhite for light mode
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.4)
                  : Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment:
                  isDarkMode ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkMode
                      ? const Color(0xFFB19F91) // warmTaupe
                      : const Color(0xFF48494B), // smokedCharcoal
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? const Color(0xFFB19F91).withOpacity(0.5)
                          : const Color(0xFF48494B).withOpacity(0.3),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  isDarkMode ? Icons.nights_stay : Icons.wb_sunny,
                  size: 16,
                  color: isDarkMode
                      ? const Color(0xFF1C1C1C) // deepOnyx on taupe
                      : const Color(0xFFF8F4F0), // porcelainWhite on charcoal
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
