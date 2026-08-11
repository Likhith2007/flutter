import 'package:flutter/material.dart';
import '../../domain/models/vendor.dart';

class VendorProvider extends ChangeNotifier {
  String _selectedCategory = 'ALL';
  String _searchQuery = '';
  String _sortBy = 'RECOMMENDED'; // RECOMMENDED, RATING, PRICE_LOW, PRICE_HIGH
  double _maxPriceFilter = 500000;
  double _minRatingFilter = 0.0;
  final Set<String> _wishlistIds = {'v_1', 'v_3'};

  List<Vendor> _allVendors = [];

  VendorProvider() {
    _initMockVendors();
  }

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  double get maxPriceFilter => _maxPriceFilter;
  double get minRatingFilter => _minRatingFilter;
  Set<String> get wishlistIds => _wishlistIds;

  List<Vendor> get wishlistVendors {
    return _allVendors.where((v) => _wishlistIds.contains(v.id)).toList();
  }

  List<Vendor> get featuredVendors {
    return _allVendors.where((v) => v.isFeatured).toList();
  }

  List<Vendor> get filteredVendors {
    return _allVendors.where((vendor) {
      // Category filter
      if (_selectedCategory != 'ALL' &&
          vendor.categoryId != _selectedCategory) {
        return false;
      }
      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesName = vendor.name.toLowerCase().contains(query);
        final matchesCategory = vendor.category.toLowerCase().contains(query);
        final matchesLocation = vendor.location.toLowerCase().contains(query);
        if (!matchesName && !matchesCategory && !matchesLocation) {
          return false;
        }
      }
      // Price & Rating filters
      if (vendor.price > _maxPriceFilter) return false;
      if (vendor.rating < _minRatingFilter) return false;

      return true;
    }).toList()
      ..sort((a, b) {
        switch (_sortBy) {
          case 'RATING':
            return b.shataScore.compareTo(a.shataScore);
          case 'PRICE_LOW':
            return a.price.compareTo(b.price);
          case 'PRICE_HIGH':
            return b.price.compareTo(a.price);
          case 'RECOMMENDED':
          default:
            return b.shataScore.compareTo(a.shataScore);
        }
      });
  }

  void setCategory(String catId) {
    _selectedCategory = catId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortBy(String sortOption) {
    _sortBy = sortOption;
    notifyListeners();
  }

  void setFilters({required double maxPrice, required double minRating}) {
    _maxPriceFilter = maxPrice;
    _minRatingFilter = minRating;
    notifyListeners();
  }

  void toggleWishlist(String vendorId) {
    if (_wishlistIds.contains(vendorId)) {
      _wishlistIds.remove(vendorId);
    } else {
      _wishlistIds.add(vendorId);
    }
    notifyListeners();
  }

  bool isWishlisted(String vendorId) => _wishlistIds.contains(vendorId);

  Vendor? getVendorById(String id) {
    try {
      return _allVendors.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }

  void _initMockVendors() {
    _allVendors = [
      Vendor(
        id: 'v_1',
        name: 'Aura Lens Studios',
        category: 'Photography',
        categoryId: 'cat_photo',
        rating: 4.9,
        shataScore: 4.95,
        reviewCount: 142,
        price: 45000,
        priceUnit: 'per day',
        location: 'Banjara Hills, Hyderabad',
        experienceYears: 8,
        verified: true,
        isFeatured: true,
        images: [
          'https://images.unsplash.com/photo-1519741497674-611481863552?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1583939003579-730e3918a45a?auto=format&fit=crop&w=800&q=80',
        ],
        description:
            'Aura Lens Studios specializes in luxury cinematic wedding films, high-resolution candid portraiture, and 4K drone cinematography. Over 500+ successful events captured.',
        contactPhone: '+91 98765 43210',
        inclusions: [
          '2 Senior Candid Photographers',
          '1 Cinematic Drone Operator',
          'Unlimited Edited Digital Photos',
          'Premium Hardcover Photo Album (40 Pages)',
          'Teaser Video (3 mins) & Full Feature (30 mins)',
        ],
        packages: [
          VendorPackage(
            id: 'pkg_1_1',
            title: 'Essential Ceremony Package',
            description: '1 Day coverage for traditional rituals & reception.',
            price: 45000,
            highlights: ['Full HD Video', '300 Edited Photos', '1 Album'],
          ),
          VendorPackage(
            id: 'pkg_1_2',
            title: 'Royal Cinematic Wedding',
            description: '2 Days complete wedding & sangeet 4K production.',
            price: 85000,
            isPopular: true,
            highlights: ['4K Drone Shots', 'Same Day Edit Teaser', '2 Luxe Albums'],
          ),
        ],
        reviews: [
          VendorReview(
            id: 'r_1',
            userName: 'Ananya & Vikram',
            userAvatar: 'https://i.pravatar.cc/150?img=32',
            rating: 5.0,
            date: '2 weeks ago',
            comment:
                'Aura Lens team delivered beyond expectations! The drone shots of our outdoor reception were breathtaking. Highly recommend Shata for booking verified photographers!',
          ),
          VendorReview(
            id: 'r_2',
            userName: 'Rahul Sharma',
            userAvatar: 'https://i.pravatar.cc/150?img=12',
            rating: 4.8,
            date: '1 month ago',
            comment:
                'Super punctual, professional crew. The album quality is premium.',
          ),
        ],
      ),
      Vendor(
        id: 'v_2',
        name: 'Royal Feast Caterers',
        category: 'Catering',
        categoryId: 'cat_catering',
        rating: 4.8,
        shataScore: 4.88,
        reviewCount: 98,
        price: 650,
        priceUnit: 'per plate',
        location: 'Jubilee Hills, Hyderabad',
        experienceYears: 12,
        verified: true,
        isFeatured: true,
        images: [
          'https://images.unsplash.com/photo-1555244162-803834f70033?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&q=80',
        ],
        description:
            'Crafting authentic culinary masterpieces ranging from Hyderabadi Dum Biryani, Mughlai, South Indian Traditional Leaf Feasts, to Continental Live Stalls.',
        contactPhone: '+91 91234 56789',
        inclusions: [
          'Live Counter Setup with Uniformed Chefs',
          'Premium Cutlery & Tableware',
          'Welcome Drink Counter (3 Varieties)',
          'Dedicated Waste Management & Clean Up',
        ],
        packages: [
          VendorPackage(
            id: 'pkg_2_1',
            title: 'Silver Deluxe Buffet',
            description: '3 Starter, 6 Main Course, 3 Desserts + Live Naan counter.',
            price: 650,
            highlights: ['Veg & Non-Veg', 'Mocktail Counter'],
          ),
          VendorPackage(
            id: 'pkg_2_2',
            title: 'Gold Royal Feast',
            description: '5 Starters, 10 Main Courses, 5 Desserts + 3 Live Stalls.',
            price: 950,
            isPopular: true,
            highlights: ['Chef Signature Dishes', 'Ice Sculptures', 'Live Pasta Stall'],
          ),
        ],
        reviews: [
          VendorReview(
            id: 'r_3',
            userName: 'Srinivas Rao',
            userAvatar: 'https://i.pravatar.cc/150?img=60',
            rating: 5.0,
            date: '3 weeks ago',
            comment:
                'The food was the highlight of our daughter\'s wedding! Every guest praised the live chaat and biryani.',
          ),
        ],
      ),
      Vendor(
        id: 'v_3',
        name: 'Velvet Dreams Decorators',
        category: 'Decor & Stage',
        categoryId: 'cat_decor',
        rating: 4.9,
        shataScore: 4.92,
        reviewCount: 76,
        price: 75000,
        priceUnit: 'per setup',
        location: 'Gachibowli, Hyderabad',
        experienceYears: 7,
        verified: true,
        isFeatured: true,
        images: [
          'https://images.unsplash.com/photo-1519225421980-715cb0215aed?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1465495976277-4387d4b0b4c6?auto=format&fit=crop&w=800&q=80',
        ],
        description:
            'Transforming venues with breathtaking floral mandaps, LED ceiling lights, aesthetic photo booths, and bespoke entrance archways.',
        contactPhone: '+91 99887 76655',
        inclusions: [
          'Custom 3D Stage Layout Design',
          'Fresh Exotic Flower Arrangement',
          'Ambient LED Spotlights & Par Lights',
          'Bridal Entry Canopy Decor',
        ],
        packages: [
          VendorPackage(
            id: 'pkg_3_1',
            title: 'Contemporary Floral Elegance',
            description: 'Pastel flower mandap with fairy light backdrop.',
            price: 75000,
            highlights: ['Fresh Roses', 'Photo Archway'],
          ),
          VendorPackage(
            id: 'pkg_3_2',
            title: 'Grand Palace Theme',
            description: 'Royal golden pillar stage setup with chandelier ceilings.',
            price: 150000,
            isPopular: true,
            highlights: ['3D Mirror Runway', 'Hydraulic Flower Shower'],
          ),
        ],
        reviews: [
          VendorReview(
            id: 'r_4',
            userName: 'Priya & Karthik',
            userAvatar: 'https://i.pravatar.cc/150?img=47',
            rating: 4.9,
            date: '2 months ago',
            comment:
                'The mandap looked straight out of a fairytale movie! Exceptional attention to detail.',
          ),
        ],
      ),
      Vendor(
        id: 'v_4',
        name: 'Grand Imperial Convention Centre',
        category: 'Venues',
        categoryId: 'cat_venue',
        rating: 4.7,
        shataScore: 4.82,
        reviewCount: 110,
        price: 120000,
        priceUnit: 'per slot',
        location: 'Kondapur, Hyderabad',
        experienceYears: 10,
        verified: true,
        isFeatured: false,
        images: [
          'https://images.unsplash.com/photo-1545232979-fbfd42e000b9?auto=format&fit=crop&w=800&q=80',
        ],
        description:
            'Air-conditioned banquet hall with 1500+ seating capacity, landscaped lawn, dedicated bridal suites, and ample parking for 400 vehicles.',
        contactPhone: '+91 97766 55443',
        inclusions: [
          'Central AC Hall + Outdoor Lawn',
          'Bridal & Groom AC Suite Rooms',
          'In-house Genset Power Backup',
          'Valet Parking Staff',
        ],
        packages: [
          VendorPackage(
            id: 'pkg_4_1',
            title: 'Day / Night Booking Slot',
            description: '12 Hours hall usage + Green rooms.',
            price: 120000,
            highlights: ['1500 Seating', 'In-house Generator'],
          ),
        ],
        reviews: [],
      ),
      Vendor(
        id: 'v_5',
        name: 'Sparkle Beats Entertainment & DJ',
        category: 'Entertainment',
        categoryId: 'cat_artists',
        rating: 4.8,
        shataScore: 4.85,
        reviewCount: 64,
        price: 25000,
        priceUnit: 'per event',
        location: 'Madhapur, Hyderabad',
        experienceYears: 6,
        verified: true,
        isFeatured: false,
        images: [
          'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=800&q=80',
        ],
        description:
            'Top celebrity DJ, concert-grade JBL sound system, cold pyros, smoke machines, and interactive emcee anchoring for Sangeet & Cocktail nights.',
        contactPhone: '+91 95544 33221',
        inclusions: [
          'Professional DJ + Emcee Anchor',
          'Line Array 10000W Sound System',
          'Cold Pyro Fountains (4 Nos)',
          'Intelligent Beam Moving Head Lights',
        ],
        packages: [
          VendorPackage(
            id: 'pkg_5_1',
            title: 'Sangeet Party Rocker',
            description: '4 Hours non-stop music, DJ & Pyro entry.',
            price: 25000,
            highlights: ['Live Emcee', 'Cold Pyros Included'],
          ),
        ],
        reviews: [],
      ),
    ];
  }
}
