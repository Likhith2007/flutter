class AppConstants {
  static const String appName = 'Shata';
  static const String appVersion = '2.0.0';

  static const List<String> availableCities = [
    'Hyderabad',
    'Bengaluru',
    'Mumbai',
    'Chennai',
    'Delhi NCR',
    'Vijayawada',
    'Visakhapatnam',
  ];

  static const List<Map<String, dynamic>> serviceCategories = [
    {
      'id': 'cat_photo',
      'name': 'Photography',
      'icon': 'camera',
      'itemCount': '480+ Vendors',
      'image': 'https://images.unsplash.com/photo-1537633552985-df8429e8048b?q=80&w=800&auto=format&fit=crop',
      'description': 'Wedding, Cinematic, Pre-wedding, Maternity & Drones',
    },
    {
      'id': 'cat_catering',
      'name': 'Catering',
      'icon': 'restaurant',
      'itemCount': '350+ Caterers',
      'image': 'https://images.unsplash.com/photo-1555244162-803834f70033?q=80&w=800&auto=format&fit=crop',
      'description': 'Buffet, Live Counters, Gourmet & Custom Menus',
    },
    {
      'id': 'cat_decor',
      'name': 'Decor & Stage',
      'icon': 'auto_awesome',
      'itemCount': '290+ Designers',
      'image': 'https://images.unsplash.com/photo-1519741497674-611481863552?q=80&w=800&auto=format&fit=crop',
      'description': 'Theme Decor, Floral Setup, Lighting & Entry Gates',
    },
    {
      'id': 'cat_venue',
      'name': 'Venues',
      'icon': 'location_city',
      'itemCount': '180+ Spaces',
      'image': 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=800&auto=format&fit=crop',
      'description': 'Banquet Halls, Lawns, Beach Resorts & Convention Centers',
    },
    {
      'id': 'cat_planner',
      'name': 'Event Planners',
      'icon': 'event_available',
      'itemCount': '140+ Teams',
      'image': 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?q=80&w=800&auto=format&fit=crop',
      'description': 'Full Event Management & Day-of Coordination',
    },
    {
      'id': 'cat_artists',
      'name': 'Entertainment',
      'icon': 'music_note',
      'itemCount': '210+ Performers',
      'image': 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?q=80&w=800&auto=format&fit=crop',
      'description': 'DJs, Live Bands, Anchors & Choreographers',
    },
  ];

  static const List<Map<String, dynamic>> promoBanners = [
    {
      'id': 'banner_1',
      'title': 'Grand Wedding Season 2026',
      'subtitle': 'Flat 20% OFF on Top Photography & Decor Packages',
      'badge': 'LIMITED OFFER',
      'colorStart': 0xFF6B21A8,
      'colorEnd': 0xFF3B0764,
    },
    {
      'id': 'banner_2',
      'title': 'Gourmet Catering Deals',
      'subtitle': 'Free Live Dessert Counter on bookings > 300 guests',
      'badge': 'POPULAR',
      'colorStart': 0xFF059669,
      'colorEnd': 0xFF064E3B,
    },
    {
      'id': 'banner_3',
      'title': 'SHATA Verified Guarantee',
      'subtitle': 'Verified vendors with 100% On-Time Service Guarantee',
      'badge': 'TRUSTED',
      'colorStart': 0xFFD97706,
      'colorEnd': 0xFF78350F,
    },
  ];
}
