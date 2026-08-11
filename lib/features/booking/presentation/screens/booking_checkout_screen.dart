import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:shata_app/core/localization/language_provider.dart';
import 'package:shata_app/core/widgets/custom_button.dart';
import 'package:shata_app/features/vendors/domain/models/vendor.dart';
import 'package:shata_app/features/booking/domain/models/booking.dart';
import 'package:shata_app/features/booking/presentation/providers/booking_provider.dart';

class BookingCheckoutScreen extends StatefulWidget {
  final Vendor vendor;
  final VendorPackage selectedPackage;

  const BookingCheckoutScreen({
    super.key,
    required this.vendor,
    required this.selectedPackage,
  });

  @override
  State<BookingCheckoutScreen> createState() => _BookingCheckoutScreenState();
}

class _BookingCheckoutScreenState extends State<BookingCheckoutScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 7));
  String _selectedTimeSlot = 'Evening Slot (4 PM - 11 PM)';
  double _guestCount = 250;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _couponController = TextEditingController();

  final List<String> _selectedAddOns = [];
  double _addOnsCost = 0.0;
  double _discountAmount = 0.0;
  String _paymentMethod = 'UPI (Google Pay / PhonePe)';
  bool _isProcessing = false;

  final Map<String, double> _availableAddOns = {
    '4K Drone Cinematography': 8000.0,
    'Live Dessert / Kulfi Counter': 5000.0,
    'Pre-Wedding Teaser Reel (3 mins)': 6000.0,
    'Extra Senior Photographer': 7500.0,
    'Cold Pyro Fountain Entry': 3500.0,
  };

  @override
  void initState() {
    super.initState();
    _locationController.text = widget.vendor.location;
  }

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final code = _couponController.text.trim().toUpperCase();
    if (code == 'SHATA2026' || code == 'SHATA20') {
      setState(() {
        _discountAmount = 5000.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Coupon SHATA2026 applied! ₹5,000 Discount added.'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid coupon code. Try "SHATA2026"'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _confirmBooking() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulate API network call

    final bookingId = 'SHATA-${const Uuid().v4().substring(0, 6).toUpperCase()}';
    final total = widget.selectedPackage.price + _addOnsCost - _discountAmount;

    final newBooking = Booking(
      bookingId: bookingId,
      vendorId: widget.vendor.id,
      vendorName: widget.vendor.name,
      vendorImage: widget.vendor.images.first,
      category: widget.vendor.category,
      eventDate: _selectedDate,
      timeSlot: _selectedTimeSlot,
      guestCount: _guestCount.toInt(),
      selectedPackageTitle: widget.selectedPackage.title,
      packagePrice: widget.selectedPackage.price,
      addOns: List.from(_selectedAddOns),
      addOnsCost: _addOnsCost,
      discountAmount: _discountAmount,
      totalAmount: total > 0 ? total : 0,
      status: 'CONFIRMED',
      eventLocation: _locationController.text.trim().isEmpty
          ? widget.vendor.location
          : _locationController.text.trim(),
      specialNotes: _notesController.text.trim(),
      paymentMethod: _paymentMethod,
      createdDate: DateTime.now(),
    );

    if (mounted) {
      Provider.of<BookingProvider>(context, listen: false).createBooking(newBooking);
      setState(() => _isProcessing = false);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF10B981),
              size: 64,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Booking Confirmed!',
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your booking ref ID is $bookingId',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Paid:',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹${total.toStringAsFixed(0)}',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              PrimaryButton(
                text: 'Go to My Bookings',
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Close checkout
                  Navigator.pop(context); // Close detail
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = Provider.of<LanguageProvider>(context);
    final totalAmount =
        widget.selectedPackage.price + _addOnsCost - _discountAmount;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout & Book',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vendor Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor.withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.vendor.images.first,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.vendor.name,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Package: ${widget.selectedPackage.title}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lang.formatPrice(widget.selectedPackage.price),
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Step 1: Select Event Date & Time Slot
            Text(
              '1. Event Date & Slot',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _selectDate(context),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: theme.dividerColor.withOpacity(0.15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: theme.primaryColor, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          DateFormat('EEEE, dd MMMM yyyy').format(_selectedDate),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Change',
                      style: GoogleFonts.outfit(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _selectedTimeSlot,
              decoration: InputDecoration(
                labelText: 'Preferred Time Slot',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                filled: true,
                fillColor: theme.cardTheme.color,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Morning Slot (9 AM - 2 PM)',
                  child: Text('Morning Slot (9 AM - 2 PM)'),
                ),
                DropdownMenuItem(
                  value: 'Evening Slot (4 PM - 11 PM)',
                  child: Text('Evening Slot (4 PM - 11 PM)'),
                ),
                DropdownMenuItem(
                  value: 'Full Day Event (24 Hours)',
                  child: Text('Full Day Event (24 Hours)'),
                ),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedTimeSlot = val);
              },
            ),

            const SizedBox(height: 24),

            // Step 2: Guest Count Slider & Add-ons
            Text(
              '2. Guest Count & Add-ons',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Estimated Guests:',
                  style: GoogleFonts.plusJakartaSans(fontSize: 14),
                ),
                Text(
                  '${_guestCount.toInt()} Guests',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
            Slider(
              value: _guestCount,
              min: 50,
              max: 2000,
              divisions: 39,
              activeColor: theme.primaryColor,
              onChanged: (val) => setState(() => _guestCount = val),
            ),

            const SizedBox(height: 8),
            Text(
              'Optional Add-on Services',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: _availableAddOns.entries.map((entry) {
                final isSelected = _selectedAddOns.contains(entry.key);
                return CheckboxListTile(
                  title: Text(
                    entry.key,
                    style: GoogleFonts.plusJakartaSans(fontSize: 13),
                  ),
                  subtitle: Text(
                    '+${lang.formatPrice(entry.value)}',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  value: isSelected,
                  activeColor: theme.primaryColor,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedAddOns.add(entry.key);
                        _addOnsCost += entry.value;
                      } else {
                        _selectedAddOns.remove(entry.key);
                        _addOnsCost -= entry.value;
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Step 3: Event Venue Address & Notes
            Text(
              '3. Venue Location & Notes',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Venue Address',
                hintText: 'Enter full venue address or function hall name',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                filled: true,
                fillColor: theme.cardTheme.color,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Special Requests / Instructions',
                hintText: 'e.g. Traditional entrance song, specific color codes',
                prefixIcon: const Icon(Icons.note),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                filled: true,
                fillColor: theme.cardTheme.color,
              ),
            ),

            const SizedBox(height: 24),

            // Step 4: Promo Coupon Code
            Text(
              '4. Promo Coupon Discount',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _couponController,
                    decoration: InputDecoration(
                      hintText: 'Enter coupon (Try SHATA2026)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      filled: true,
                      fillColor: theme.cardTheme.color,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _applyCoupon,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                  ),
                  child: const Text('Apply'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Step 5: Payment Method
            Text(
              '5. Payment Method',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                'UPI (Google Pay / PhonePe)',
                'Credit / Debit Card',
                'Pay 20% Advance & Balance on Event Day',
              ].map((method) {
                return RadioListTile<String>(
                  title: Text(method, style: GoogleFonts.plusJakartaSans()),
                  value: method,
                  groupValue: _paymentMethod,
                  activeColor: theme.primaryColor,
                  onChanged: (val) {
                    if (val != null) setState(() => _paymentMethod = val);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Price Summary Breakdown Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Base Package:',
                          style: GoogleFonts.plusJakartaSans()),
                      Text(lang.formatPrice(widget.selectedPackage.price),
                          style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Add-ons Cost:',
                          style: GoogleFonts.plusJakartaSans()),
                      Text('+${lang.formatPrice(_addOnsCost)}',
                          style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  if (_discountAmount > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Coupon Discount:',
                            style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF10B981))),
                        Text('-${lang.formatPrice(_discountAmount)}',
                            style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF10B981))),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Payable:',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        lang.formatPrice(totalAmount > 0 ? totalAmount : 0),
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            PrimaryButton(
              text: 'Confirm & Complete Booking',
              isLoading: _isProcessing,
              onPressed: _confirmBooking,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
