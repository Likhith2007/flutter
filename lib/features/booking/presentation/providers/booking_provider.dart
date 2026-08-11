import 'package:flutter/material.dart';
import '../../domain/models/booking.dart';

class BookingProvider extends ChangeNotifier {
  final List<Booking> _bookings = [];

  BookingProvider() {
    _initMockBookings();
  }

  List<Booking> get allBookings => _bookings;

  List<Booking> get activeBookings =>
      _bookings.where((b) => b.status == 'CONFIRMED' || b.status == 'IN_PROGRESS').toList();

  List<Booking> get completedBookings =>
      _bookings.where((b) => b.status == 'COMPLETED').toList();

  List<Booking> get cancelledBookings =>
      _bookings.where((b) => b.status == 'CANCELLED').toList();

  void createBooking(Booking booking) {
    _bookings.insert(0, booking);
    notifyListeners();
  }

  void cancelBooking(String bookingId) {
    final index = _bookings.indexWhere((b) => b.bookingId == bookingId);
    if (index != -1) {
      final old = _bookings[index];
      _bookings[index] = Booking(
        bookingId: old.bookingId,
        vendorId: old.vendorId,
        vendorName: old.vendorName,
        vendorImage: old.vendorImage,
        category: old.category,
        eventDate: old.eventDate,
        timeSlot: old.timeSlot,
        guestCount: old.guestCount,
        selectedPackageTitle: old.selectedPackageTitle,
        packagePrice: old.packagePrice,
        addOns: old.addOns,
        addOnsCost: old.addOnsCost,
        discountAmount: old.discountAmount,
        totalAmount: old.totalAmount,
        status: 'CANCELLED',
        eventLocation: old.eventLocation,
        specialNotes: old.specialNotes,
        paymentMethod: old.paymentMethod,
        createdDate: old.createdDate,
      );
      notifyListeners();
    }
  }

  void _initMockBookings() {
    _bookings.addAll([
      Booking(
        bookingId: 'SHATA-88910',
        vendorId: 'v_1',
        vendorName: 'Aura Lens Studios',
        vendorImage:
            'https://images.unsplash.com/photo-1519741497674-611481863552?auto=format&fit=crop&w=800&q=80',
        category: 'Photography',
        eventDate: DateTime.now().add(const Duration(days: 14)),
        timeSlot: 'Evening Slot (4 PM - 11 PM)',
        guestCount: 350,
        selectedPackageTitle: 'Royal Cinematic Wedding',
        packagePrice: 85000,
        addOns: ['4K Drone Coverage', 'Pre-Wedding Teaser Reel'],
        addOnsCost: 12000,
        discountAmount: 5000,
        totalAmount: 92000,
        status: 'CONFIRMED',
        eventLocation: 'Novotel Convention Centre, Hitec City, Hyderabad',
        specialNotes: 'Please focus on candid moments during the Jaimala ritual.',
        paymentMethod: 'UPI (GPay / PhonePe)',
        createdDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Booking(
        bookingId: 'SHATA-77412',
        vendorId: 'v_2',
        vendorName: 'Royal Feast Caterers',
        vendorImage:
            'https://images.unsplash.com/photo-1555244162-803834f70033?auto=format&fit=crop&w=800&q=80',
        category: 'Catering',
        eventDate: DateTime.now().subtract(const Duration(days: 30)),
        timeSlot: 'Lunch Slot (12 PM - 4 PM)',
        guestCount: 200,
        selectedPackageTitle: 'Silver Deluxe Buffet',
        packagePrice: 130000,
        addOns: ['Live Kulfi Counter'],
        addOnsCost: 8000,
        discountAmount: 4000,
        totalAmount: 134000,
        status: 'COMPLETED',
        eventLocation: 'Banjara Function Hall, Road No. 12, Hyderabad',
        specialNotes: 'Strictly Halal & Pure Ghee preparation requested.',
        paymentMethod: 'Credit Card',
        createdDate: DateTime.now().subtract(const Duration(days: 35)),
      ),
    ]);
  }
}
