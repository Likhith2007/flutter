class Booking {
  final String bookingId;
  final String vendorId;
  final String vendorName;
  final String vendorImage;
  final String category;
  final DateTime eventDate;
  final String timeSlot;
  final int guestCount;
  final String selectedPackageTitle;
  final double packagePrice;
  final List<String> addOns;
  final double addOnsCost;
  final double discountAmount;
  final double totalAmount;
  final String status; // CONFIRMED, IN_PROGRESS, COMPLETED, CANCELLED
  final String eventLocation;
  final String specialNotes;
  final String paymentMethod;
  final DateTime createdDate;

  Booking({
    required this.bookingId,
    required this.vendorId,
    required this.vendorName,
    required this.vendorImage,
    required this.category,
    required this.eventDate,
    required this.timeSlot,
    required this.guestCount,
    required this.selectedPackageTitle,
    required this.packagePrice,
    required this.addOns,
    required this.addOnsCost,
    required this.discountAmount,
    required this.totalAmount,
    required this.status,
    required this.eventLocation,
    required this.specialNotes,
    required this.paymentMethod,
    required this.createdDate,
  });
}
