import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shata_app/core/localization/language_provider.dart';
import 'package:shata_app/features/home/presentation/screens/home_screen.dart';
import 'package:shata_app/features/vendors/presentation/screens/vendor_list_screen.dart';
import 'package:shata_app/features/booking/presentation/screens/my_bookings_screen.dart';
import 'package:shata_app/features/budget_planner/presentation/screens/budget_planner_screen.dart';
import 'package:shata_app/features/profile/presentation/screens/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = Provider.of<LanguageProvider>(context);

    final List<Widget> pages = [
      HomeScreen(onNavigateTab: _onTabSelected),
      const VendorListScreen(),
      const MyBookingsScreen(),
      const BudgetPlannerScreen(),
      const ProfileScreen(),
    ];

    return Directionality(
      textDirection: lang.textDirection,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabSelected,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: theme.primaryColor,
          unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.5),
          selectedLabelStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 11,
          ),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home_rounded),
              label: lang.getText('app_name'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.explore_outlined),
              activeIcon: const Icon(Icons.explore_rounded),
              label: lang.getText('explore'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.confirmation_number_outlined),
              activeIcon: const Icon(Icons.confirmation_number_rounded),
              label: lang.getText('my_bookings'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_balance_wallet_outlined),
              activeIcon: const Icon(Icons.account_balance_wallet_rounded),
              label: 'Planner',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person_rounded),
              label: lang.getText('profile'),
            ),
          ],
        ),
      ),
    );
  }
}
