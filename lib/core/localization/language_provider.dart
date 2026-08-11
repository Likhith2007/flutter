import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguageCode = 'en';
  String _currentCurrencyCode = 'INR';

  String get currentLanguageCode => _currentLanguageCode;
  String get currentCurrencyCode => _currentCurrencyCode;

  TextDirection get textDirection =>
      _currentLanguageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;

  final Map<String, String> _languageNames = {
    'en': 'English',
    'te': 'తెలుగు (Telugu)',
    'hi': 'हिंदी (Hindi)',
    'ar': 'العربية (Arabic)',
  };

  Map<String, String> get languageNames => _languageNames;

  void setLanguage(String code) {
    if (_languageNames.containsKey(code)) {
      _currentLanguageCode = code;
      notifyListeners();
    }
  }

  void setCurrency(String currencyCode) {
    _currentCurrencyCode = currencyCode;
    notifyListeners();
  }

  String formatPrice(double amountInINR) {
    switch (_currentCurrencyCode) {
      case 'USD':
        return '\$${(amountInINR / 83.5).toStringAsFixed(0)}';
      case 'SAR':
        return '${(amountInINR / 22.2).toStringAsFixed(0)} SAR';
      case 'INR':
      default:
        return '₹${amountInINR.toStringAsFixed(0)}';
    }
  }

  // Translation dictionary mapping key -> text
  final Map<String, Map<String, String>> _localizedStrings = {
    'en': {
      'app_name': 'Shata',
      'tagline': 'Premium Events & Vendor Booking',
      'explore': 'Explore',
      'search_placeholder': 'Search photographers, caterers, venues...',
      'categories': 'Categories',
      'popular_vendors': 'Popular Verified Vendors',
      'budget_calculator': 'Event Budget Planner',
      'shata_score': 'SHATA Score',
      'book_now': 'Book Now',
      'my_bookings': 'My Bookings',
      'profile': 'Profile',
      'favorites': 'Wishlist',
    },
    'te': {
      'app_name': 'షాటా',
      'tagline': 'ప్రీమియం ఈవెంట్స్ & వెండర్ బుకింగ్',
      'explore': 'శోధించండి',
      'search_placeholder': 'ఫొటోగ్రాఫర్‌లు, క్యాటరర్లు, వేదికలను వెతకండి...',
      'categories': 'వర్గాలు',
      'popular_vendors': 'జనాదరణ పొందిన వెండర్లు',
      'budget_calculator': 'ఈవెంట్ బడ్జెట్ ప్లానర్',
      'shata_score': 'షాటా స్కోర్',
      'book_now': 'ఇప్పుడే బుక్ చేయండి',
      'my_bookings': 'నా బుకింగ్‌లు',
      'profile': 'ప్రొఫైల్',
      'favorites': 'ఇష్టమైనవి',
    },
    'hi': {
      'app_name': 'शाटा',
      'tagline': 'प्रीमियम इवेंट्स और वेंडर बुकिंग',
      'explore': 'खोजें',
      'search_placeholder': 'फोटोग्राफर, कैटरर्स, वेन्यू खोजें...',
      'categories': 'श्रेणियाँ',
      'popular_vendors': 'लोकप्रिय सत्यापित वेंडर',
      'budget_calculator': 'इवेंट बजट प्लानर',
      'shata_score': 'शाटा स्कोर',
      'book_now': 'अभी बुक करें',
      'my_bookings': 'मेरी बुकिंग',
      'profile': 'प्रोफ़ाइल',
      'favorites': 'पसंदीदा',
    },
    'ar': {
      'app_name': 'شاطا',
      'tagline': 'حجز الفعاليات والموردين المميزين',
      'explore': 'استكشف',
      'search_placeholder': 'ابحث عن مصورين، طهاة، قاعات...',
      'categories': 'الفئات',
      'popular_vendors': 'الموردون المعتمدون',
      'budget_calculator': 'مخطط ميزانية الفعالية',
      'shata_score': 'تقييم شاطا',
      'book_now': 'احجز الآن',
      'my_bookings': 'حجوزاتي',
      'profile': 'الملف الشخصي',
      'favorites': 'المفضلة',
    },
  };

  String getText(String key) {
    return _localizedStrings[_currentLanguageCode]?[key] ??
        _localizedStrings['en']?[key] ??
        key;
  }
}
