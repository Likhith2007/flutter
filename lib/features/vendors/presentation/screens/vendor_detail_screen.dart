import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shata_app/core/localization/language_provider.dart';
import 'package:shata_app/core/widgets/custom_button.dart';
import 'package:shata_app/core/widgets/shata_badge.dart';
import 'package:shata_app/features/vendors/domain/models/vendor.dart';
import 'package:shata_app/features/vendors/presentation/providers/vendor_provider.dart';
import 'package:shata_app/features/booking/presentation/screens/booking_checkout_screen.dart';

class VendorDetailScreen extends StatefulWidget {
  final String vendorId;

  const VendorDetailScreen({
    super.key,
    required this.vendorId,
  });

  @override
  State<VendorDetailScreen> createState() => _VendorDetailScreenState();
}

class _VendorDetailScreenState extends State<VendorDetailScreen> {
  int _selectedPackageIndex = 0;
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = Provider.of<LanguageProvider>(context);
    final vendorProvider = Provider.of<VendorProvider>(context);
    final vendor = vendorProvider.getVendorById(widget.vendorId);

    if (vendor == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Vendor Details')),
        body: const Center(child: Text('Vendor not found.')),
      );
    }

    final selectedPackage = vendor.packages.isNotEmpty
        ? vendor.packages[_selectedPackageIndex]
        : null;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Hero Image Gallery App Bar
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      PageView.builder(
                        itemCount: vendor.images.length,
                        onPageChanged: (idx) {
                          setState(() => _currentImageIndex = idx);
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            vendor.images[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        },
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_currentImageIndex + 1} / ${vendor.images.length}',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      vendorProvider.isWishlisted(vendor.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: vendorProvider.isWishlisted(vendor.id)
                          ? Colors.red
                          : Colors.white,
                    ),
                    onPressed: () {
                      vendorProvider.toggleWishlist(vendor.id);
                    },
                  ),
                ],
              ),

              // Content Body
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShataScoreBadge(score: vendor.shataScore),
                          const VerifiedBadge(),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        vendor.name,
                        style: GoogleFonts.outfit(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 16, color: theme.primaryColor),
                          const SizedBox(width: 4),
                          Text(
                            vendor.location,
                            style: GoogleFonts.plusJakartaSans(
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.work_history,
                              size: 16, color: theme.colorScheme.secondary),
                          const SizedBox(width: 4),
                          Text(
                            '${vendor.experienceYears} Yrs Exp',
                            style: GoogleFonts.plusJakartaSans(
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 16),

                      Text(
                        'About Vendor',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        vendor.description,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          height: 1.6,
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Package Selection Section
                      Text(
                        'Select Package',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: List.generate(
                          vendor.packages.length,
                          (index) {
                            final pkg = vendor.packages[index];
                            final isSelected = _selectedPackageIndex == index;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? theme.primaryColor.withOpacity(0.08)
                                    : theme.cardTheme.color,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? theme.primaryColor
                                      : theme.dividerColor.withOpacity(0.2),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: RadioListTile<int>(
                                value: index,
                                groupValue: _selectedPackageIndex,
                                activeColor: theme.primaryColor,
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedPackageIndex = val);
                                  }
                                },
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      pkg.title,
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      lang.formatPrice(pkg.price),
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.bold,
                                        color: theme.primaryColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pkg.description,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 4,
                                        children: pkg.highlights.map((h) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: theme.primaryColor
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              '• $h',
                                              style: GoogleFonts.outfit(
                                                fontSize: 11,
                                                color: theme.primaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Deliverables & Inclusions
                      Text(
                        'What\'s Included',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: vendor.inclusions.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_rounded,
                                    color: Color(0xFF10B981), size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      // Customer Reviews
                      Text(
                        'Verified Reviews (${vendor.reviews.length})',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (vendor.reviews.isEmpty)
                        Text(
                          'No reviews yet for this vendor.',
                          style: GoogleFonts.plusJakartaSans(
                              color: Colors.grey),
                        )
                      else
                        Column(
                          children: vendor.reviews.map((rev) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: theme.cardTheme.color,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: theme.dividerColor.withOpacity(0.15),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(rev.userAvatar),
                                        radius: 18,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              rev.userName,
                                              style: GoogleFonts.outfit(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              rev.date,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                fontSize: 11,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.star,
                                              color: Colors.amber, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${rev.rating}',
                                            style: GoogleFonts.outfit(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    rev.comment,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                      const SizedBox(height: 100), // Spacing for bottom CTA bar
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Floating Bottom CTA Booking Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected Package',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                        Text(
                          selectedPackage != null
                              ? lang.formatPrice(selectedPackage.price)
                              : lang.formatPrice(vendor.price),
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: PrimaryButton(
                        text: 'Proceed to Book',
                        onPressed: () {
                          if (selectedPackage != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingCheckoutScreen(
                                  vendor: vendor,
                                  selectedPackage: selectedPackage,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
