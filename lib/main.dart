import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/appointment_provider.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/step1_personal.dart';
import 'screens/step2_insurance.dart';
import 'screens/step3_doctor.dart';
import 'screens/step4_datetime.dart';
import 'screens/step5_extras.dart';
import 'screens/step6_summary.dart';

void main() {
  runApp(const MediBookApp());
}

class MediBookApp extends StatelessWidget {
  const MediBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppointmentProvider>(
          create: (_) => AppointmentProvider()..initialize(),
        ),
      ],
      child: MaterialApp(
        title: 'MediBook',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        initialRoute: LoginScreen.routeName,
        routes: <String, WidgetBuilder>{
          LoginScreen.routeName: (_) => const LoginScreen(),
          SignupScreen.routeName: (_) => const SignupScreen(),
          Step1PersonalScreen.routeName: (_) => const Step1PersonalScreen(),
          Step2InsuranceScreen.routeName: (_) => const Step2InsuranceScreen(),
          Step3DoctorScreen.routeName: (_) => const Step3DoctorScreen(),
          Step4DateTimeScreen.routeName: (_) => const Step4DateTimeScreen(),
          Step5ExtrasScreen.routeName: (_) => const Step5ExtrasScreen(),
          Step6SummaryScreen.routeName: (_) => const Step6SummaryScreen(),
        },
      ),
    );
  }

  ThemeData _buildTheme() {
    const primaryColor = Color(0xFF1E88E5);
    const backgroundColor = Color(0xFFF8F9FA);
    const surfaceColor = Color(0xFFFFFFFF);
    const successColor = Color(0xFF4CAF50);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: successColor,
      surface: surfaceColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
