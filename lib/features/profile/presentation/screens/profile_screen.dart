import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shata_app/core/constants/app_constants.dart';
import 'package:shata_app/core/localization/language_provider.dart';
import 'package:shata_app/core/theme/theme_provider.dart';
import 'package:shata_app/features/vendors/presentation/providers/vendor_provider.dart';
import 'package:shata_app/features/vendors/presentation/screens/vendor_detail_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showWishlistModal(BuildContext context) {
    final theme = Theme.of(context);
    final vendorProvider = Provider.of<VendorProvider>(context, listen: false);
    final wishlist = vendorProvider.wishlistVendors;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Saved Wishlist Vendors (${wishlist.length})',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (wishlist.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text('No saved vendors in your wishlist.'),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: wishlist.length,
                    itemBuilder: (context, index) {
                      final vendor = wishlist[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            vendor.images.first,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(vendor.name,
                            style:
                                GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                        subtitle: Text('${vendor.category} • ${vendor.location}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () {
                            vendorProvider.toggleWishlist(vendor.id);
                            Navigator.pop(context);
                          },
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  VendorDetailScreen(vendorId: vendor.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageSelector(BuildContext context, LanguageProvider lang) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Language',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...lang.languageNames.entries.map((entry) {
                final isSelected = lang.currentLanguageCode == entry.key;
                return ListTile(
                  title: Text(
                    entry.value,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle,
                          color: Theme.of(context).primaryColor)
                      : null,
                  onTap: () {
                    lang.setLanguage(entry.key);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showCurrencySelector(BuildContext context, LanguageProvider lang) {
    final currencies = [
      {'code': 'INR', 'name': 'Indian Rupee (₹)'},
      {'code': 'USD', 'name': 'US Dollar (\$)'},
      {'code': 'SAR', 'name': 'Saudi Riyal (SAR)'},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Preferred Currency',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...currencies.map((curr) {
                final isSelected = lang.currentCurrencyCode == curr['code'];
                return ListTile(
                  title: Text(curr['name']!,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      )),
                  trailing: isSelected
                      ? Icon(Icons.check_circle,
                          color: Theme.of(context).primaryColor)
                      : null,
                  onTap: () {
                    lang.setCurrency(curr['code']!);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);
    final vendorProvider = Provider.of<VendorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          lang.getText('profile'),
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.dividerColor.withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundImage:
                        NetworkImage('https://i.pravatar.cc/150?img=68'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Likhith Imandi',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'likhith.imandi@shata.in',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'VIP Event Member',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Settings Group 1: Preferences
            _buildSectionHeader(context, 'PREFERENCES'),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor.withOpacity(0.15)),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: Icon(
                      themeProvider.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color: theme.primaryColor,
                    ),
                    title: Text(
                      'Dark Mode Theme',
                      style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600),
                    ),
                    value: themeProvider.isDarkMode,
                    activeColor: theme.primaryColor,
                    onChanged: (_) => themeProvider.toggleTheme(),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading:
                        Icon(Icons.language, color: theme.primaryColor),
                    title: Text(
                      'App Language',
                      style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          lang.languageNames[lang.currentLanguageCode] ?? 'English',
                          style: GoogleFonts.outfit(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                    onTap: () => _showLanguageSelector(context, lang),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.attach_money,
                        color: theme.primaryColor),
                    title: Text(
                      'Currency',
                      style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          lang.currentCurrencyCode,
                          style: GoogleFonts.outfit(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                    onTap: () => _showCurrencySelector(context, lang),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Settings Group 2: Account & Saved
            _buildSectionHeader(context, 'SAVED & ACTIVITY'),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor.withOpacity(0.15)),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.red),
                    title: Text(
                      'My Wishlist',
                      style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${vendorProvider.wishlistIds.length}',
                        style: GoogleFonts.outfit(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () => _showWishlistModal(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.location_on,
                        color: theme.primaryColor),
                    title: Text(
                      'Saved Event Venues',
                      style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Support & About
            _buildSectionHeader(context, 'ABOUT & SUPPORT'),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor.withOpacity(0.15)),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.help_outline,
                        color: theme.primaryColor),
                    title: Text(
                      'Help & Support FAQ',
                      style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('SHATA Support'),
                          content: const Text(
                              'Reach our 24/7 Event Concierge Team at support@theshata.com or call +91 1800-SHATA-EVENT.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.info_outline,
                        color: theme.primaryColor),
                    title: Text(
                      'App Version',
                      style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: Text(
                      'v${AppConstants.appVersion}',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
    );
  }
}
