class VendorPackage {
  final String id;
  final String title;
  final String description;
  final double price;
  final List<String> highlights;
  final bool isPopular;

  VendorPackage({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.highlights,
    this.isPopular = false,
  });
}

class VendorReview {
  final String id;
  final String userName;
  final String userAvatar;
  final double rating;
  final String date;
  final String comment;

  VendorReview({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.date,
    required this.comment,
  });
}

class Vendor {
  final String id;
  final String name;
  final String category;
  final String categoryId;
  final double rating;
  final double shataScore;
  final int reviewCount;
  final double price;
  final String priceUnit;
  final String location;
  final int experienceYears;
  final bool verified;
  final bool isFeatured;
  final List<String> images;
  final String description;
  final List<VendorPackage> packages;
  final List<VendorReview> reviews;
  final List<String> inclusions;
  final String contactPhone;

  Vendor({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryId,
    required this.rating,
    required this.shataScore,
    required this.reviewCount,
    required this.price,
    required this.priceUnit,
    required this.location,
    required this.experienceYears,
    this.verified = true,
    this.isFeatured = false,
    required this.images,
    required this.description,
    required this.packages,
    required this.reviews,
    required this.inclusions,
    required this.contactPhone,
  });
}
