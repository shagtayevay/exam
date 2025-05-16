import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/splash_screen.dart';
import 'bloc/auth/auth_bloc.dart';
import 'services/firebase_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'bloc/theme/theme_bloc.dart';
import 'bloc/theme/theme_event.dart';
import 'bloc/theme/theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru'), Locale('kk')],
      path: 'lib/l10n',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => AuthBloc(firebaseService: FirebaseService())),
        BlocProvider(create: (_) => ThemeBloc()..add(LoadTheme())),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Quotes App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.grey.shade900,
                brightness:
                    themeState.isDarkMode ? Brightness.dark : Brightness.light,
                primary: Colors.grey.shade900,
                secondary: Colors.grey.shade700,
                background: themeState.isDarkMode
                    ? const Color(0xFF181818)
                    : Colors.white,
                surface: themeState.isDarkMode
                    ? const Color(0xFF232323)
                    : Colors.white,
                onPrimary: Colors.white,
                onSecondary: Colors.white,
                onBackground:
                    themeState.isDarkMode ? Colors.white : Colors.black,
                onSurface: themeState.isDarkMode ? Colors.white : Colors.black,
              ),
              useMaterial3: true,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: themeState.isDarkMode
                    ? const Color(0xFF232323)
                    : Colors.white,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade700, width: 2),
                ),
                labelStyle: TextStyle(
                  color: themeState.isDarkMode
                      ? Colors.white70
                      : Colors.grey.shade900,
                ),
              ),
              scaffoldBackgroundColor: themeState.isDarkMode
                  ? const Color(0xFF181818)
                  : Colors.white,
              appBarTheme: AppBarTheme(
                backgroundColor:
                    themeState.isDarkMode ? Colors.black : Colors.grey.shade900,
                foregroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                titleTextStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/home': (context) => const HomeScreen(),
            },
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          );
        },
      ),
    );
  }
}
