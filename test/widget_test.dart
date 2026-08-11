import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shata_app/core/theme/theme_provider.dart';
import 'package:shata_app/core/localization/language_provider.dart';
import 'package:shata_app/features/vendors/presentation/providers/vendor_provider.dart';
import 'package:shata_app/features/booking/presentation/providers/booking_provider.dart';
import 'package:shata_app/features/budget_planner/presentation/providers/budget_planner_provider.dart';
import 'package:shata_app/core/widgets/shata_badge.dart';

void main() {
  testWidgets('ShataScoreBadge widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ShataScoreBadge(score: 4.9),
        ),
      ),
    );

    expect(find.text('4.9'), findsOneWidget);
    expect(find.text('SHATA'), findsOneWidget);
  });

  testWidgets('VerifiedBadge widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VerifiedBadge(),
        ),
      ),
    );

    expect(find.text('Verified'), findsOneWidget);
  });

  test('ThemeProvider toggle test', () {
    final themeProvider = ThemeProvider();
    expect(themeProvider.themeMode, ThemeMode.system);
    themeProvider.setThemeMode(ThemeMode.dark);
    expect(themeProvider.themeMode, ThemeMode.dark);
    themeProvider.toggleTheme();
    expect(themeProvider.themeMode, ThemeMode.light);
  });

  test('LanguageProvider multi-language and currency formatting test', () {
    final lang = LanguageProvider();
    expect(lang.currentLanguageCode, 'en');
    expect(lang.formatPrice(1000), '₹1000');

    lang.setCurrency('USD');
    expect(lang.formatPrice(8350), '\$100');

    lang.setLanguage('te');
    expect(lang.getText('app_name'), 'షాటా');
  });

  test('VendorProvider filtering & search unit tests', () {
    final vendorProvider = VendorProvider();
    expect(vendorProvider.filteredVendors.isNotEmpty, true);

    // Test category filtering
    vendorProvider.setCategory('cat_photo');
    expect(
      vendorProvider.filteredVendors.every((v) => v.categoryId == 'cat_photo'),
      true,
    );

    // Test search query
    vendorProvider.setCategory('ALL');
    vendorProvider.setSearchQuery('Aura Lens');
    expect(vendorProvider.filteredVendors.length, 1);
    expect(vendorProvider.filteredVendors.first.name, 'Aura Lens Studios');
  });

  test('BookingProvider active bookings test', () {
    final bookingProvider = BookingProvider();
    expect(bookingProvider.allBookings.isNotEmpty, true);
    expect(bookingProvider.activeBookings.length, 1);
    expect(bookingProvider.completedBookings.length, 1);
  });

  test('BudgetPlanner calculation unit tests', () {
    final budgetProvider = BudgetPlannerProvider();
    expect(budgetProvider.totalBudget, 500000);
    expect(budgetProvider.totalSpent > 0, true);
    expect(budgetProvider.remainingBudget, budgetProvider.totalBudget - budgetProvider.totalSpent);
  });
}
