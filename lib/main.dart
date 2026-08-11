import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shata_app/core/localization/language_provider.dart';
import 'package:shata_app/core/theme/app_theme.dart';
import 'package:shata_app/core/theme/theme_provider.dart';
import 'package:shata_app/features/booking/presentation/providers/booking_provider.dart';
import 'package:shata_app/features/budget_planner/presentation/providers/budget_planner_provider.dart';
import 'package:shata_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:shata_app/features/vendors/presentation/providers/vendor_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => VendorProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => BudgetPlannerProvider()),
      ],
      child: const ShataUserApp(),
    ),
  );
}

class ShataUserApp extends StatelessWidget {
  const ShataUserApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Shata 2.0 - Events & Vendor Booking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const OnboardingScreen(),
    );
  }
}
