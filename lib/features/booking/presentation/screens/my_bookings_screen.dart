import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shata_app/core/localization/language_provider.dart';
import 'package:shata_app/features/booking/domain/models/booking.dart';
import 'package:shata_app/features/booking/presentation/providers/booking_provider.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  void _showBookingDetailsModal(BuildContext context, Booking booking) {
    final theme = Theme.of(context);
    final lang = Provider.of<LanguageProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Booking #${booking.bookingId}',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
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

              // Live Status Stepper Progress
              Text(
                'Live Order Status',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStatusStep('Confirmed', true, theme),
                  _buildStepLine(true, theme),
                  _buildStatusStep(
                      'Advance Paid', booking.status != 'CANCELLED', theme),
                  _buildStepLine(booking.status == 'COMPLETED', theme),
                  _buildStatusStep('Completed', booking.status == 'COMPLETED', theme),
                ],
              ),

              const SizedBox(height: 20),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    booking.vendorImage,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  booking.vendorName,
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${booking.category} • ${booking.selectedPackageTitle}',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12),
                ),
              ),

              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),

              _buildDetailRow('Event Date:',
                  DateFormat('dd MMMM yyyy').format(booking.eventDate)),
              _buildDetailRow('Time Slot:', booking.timeSlot),
              _buildDetailRow('Guests:', '${booking.guestCount} Guests'),
              _buildDetailRow('Location:', booking.eventLocation),
              _buildDetailRow('Payment:', booking.paymentMethod),
              _buildDetailRow(
                  'Total Paid:', lang.formatPrice(booking.totalAmount),
                  isBold: true),

              const SizedBox(height: 24),

              if (booking.status == 'CONFIRMED')
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showCancelDialog(context, booking.bookingId);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel Booking',
                      style: GoogleFonts.outfit(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Cancel Booking?',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to cancel this booking? Free refund is applicable up to 48 hours prior to event date.',
            style: GoogleFonts.plusJakartaSans(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Keep Booking'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<BookingProvider>(context, listen: false)
                    .cancelBooking(bookingId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking cancelled.')),
                );
              },
              child: const Text(
                'Confirm Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusStep(String title, bool isDone, ThemeData theme) {
    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isDone ? theme.primaryColor : Colors.grey[400],
          child: Icon(
            isDone ? Icons.check : Icons.circle,
            size: 14,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isDone, ThemeData theme) {
    return Expanded(
      child: Container(
        height: 2,
        color: isDone ? theme.primaryColor : Colors.grey[300],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.outfit(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                fontSize: isBold ? 15 : 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = Provider.of<LanguageProvider>(context);
    final bookingProvider = Provider.of<BookingProvider>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Bookings',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            labelColor: theme.primaryColor,
            unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
            indicatorColor: theme.primaryColor,
            labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBookingList(
                context, bookingProvider.activeBookings, theme, lang),
            _buildBookingList(
                context, bookingProvider.completedBookings, theme, lang),
            _buildBookingList(
                context, bookingProvider.cancelledBookings, theme, lang),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList(BuildContext context, List<Booking> bookings,
      ThemeData theme, LanguageProvider lang) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No bookings found',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore vendors and place your first event booking!',
              style: GoogleFonts.plusJakartaSans(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        final isConfirmed = booking.status == 'CONFIRMED';
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor.withOpacity(0.15)),
          ),
          child: InkWell(
            onTap: () => _showBookingDetailsModal(context, booking),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ID: ${booking.bookingId}',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: theme.primaryColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isConfirmed
                              ? const Color(0xFF10B981).withOpacity(0.15)
                              : booking.status == 'COMPLETED'
                                  ? Colors.blue.withOpacity(0.15)
                                  : Colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          booking.status,
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isConfirmed
                                ? const Color(0xFF10B981)
                                : booking.status == 'COMPLETED'
                                    ? Colors.blue
                                    : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          booking.vendorImage,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.vendorName,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${booking.category} • ${booking.selectedPackageTitle}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('dd MMM yyyy').format(booking.eventDate),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: ${lang.formatPrice(booking.totalAmount)}',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'View Details >',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
