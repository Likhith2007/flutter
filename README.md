# Shata 2.0 - Next-Gen Event Management & Service Booking Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean_Feature_First-emerald.svg)](https://github.com)
[![License](https://img.shields.io/badge/License-MIT-purple.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-lightgrey.svg)](https://flutter.dev)

A complete redesign and re-architecture of the **Shata Mobile Application** ([com.shata.user](https://play.google.com/store/apps/details?id=com.shata.user)), engineered with **Flutter**, **Clean Feature-First Architecture**, **Reactive State Management**, **Luxury Design System**, and high-performance cross-platform capabilities.

---

## 🌟 Key Upgrades & Highlights

### 1. Modern Luxury UI & UX Design System
- **Dynamic Light & Dark Themes**: Royal Amethyst primary palette, Champagne Gold highlights, and Slate surfaces.
- **Glassmorphism & Micro-animations**: Smooth page transitions, shimmer loading skeletons, and interactive card touch states.
- **Typography**: Google Fonts integration (`Outfit` for headlines, `Plus Jakarta Sans` for body readability).

### 2. Trust & Verification ("SHATA Score")
- **SHATA Score Rating**: Verified vendor rating algorithm based on past event performance, punctuality, and client feedback.
- **Verified Badging**: Background-checked partner trust badges.

### 3. Interactive Service Discovery & Explorer
- **Multi-Category Browsing**: Photography, Catering, Decor & Stage, Venues, Event Planners, and Entertainment/DJs.
- **Real-Time Instant Search**: Filter by vendor name, location, category, or experience.
- **Filter Modal**: Price range slider, minimum rating threshold, and sorting options (Recommended, Rating, Price Low/High).

### 4. End-to-End Multi-Step Booking Checkout
- **Interactive Calendar & Time Slot Picker**: Choose morning (9 AM - 2 PM), evening (4 PM - 11 PM), or full-day slots.
- **Guest Count & Add-on Customization**: Live pricing breakdown for extra photographers, 4K drone footage, live dessert counters, pyro fountains.
- **Coupon Discount Engine**: Interactive promo coupons (e.g. `SHATA2026`).
- **Payment Gateway Simulation**: UPI (GPay/PhonePe), Credit Cards, and Pay on Event Day option.

### 5. Interactive Event Budget Planner & Checklist Tool
- **Budget Allocations**: Visual tracker for Catering, Photography, Decor, Venue, DJ, and Buffer funds.
- **Real-Time Analytics**: Target Budget vs Spent vs Remaining calculation.
- **Planning Checklist**: Interactive timeline checklist (6 Months Before, 1 Month Before, 1 Week Before).

### 6. Internationalization & Localization
- **Multi-Language Switcher**: Native support for **English**, **Telugu (తెలుగు)**, **Hindi (हिंदी)**, and **Arabic (العربية)** with automatic RTL text direction support.
- **Multi-Currency Converter**: Instant formatting for **INR (₹)**, **USD ($)**, and **SAR (Saudi Riyal)**.

---

## 📁 Repository & Project Structure

```
c:\Users\ilikh\Downloads\flutter\
├── lib/
│   ├── main.dart                          # App entry point & Provider registration
│   ├── core/                              # Global utilities, theme tokens, widgets
│   │   ├── constants/app_constants.dart   # Mock vendor data & config
│   │   ├── localization/language_provider.dart # Multi-language & currency
│   │   ├── theme/
│   │   │   ├── app_theme.dart             # Light & Dark theme definitions
│   │   │   └── theme_provider.dart        # Theme mode switcher state
│   │   └── widgets/                       # Custom buttons, badges, shimmer
│   │       ├── custom_button.dart
│   │       ├── shata_badge.dart
│   │       └── shimmer_loading.dart
│   └── features/                          # Feature-First Modules
│       ├── onboarding/                    # Animated Onboarding Slider
│       ├── home/                          # Home Dashboard, Search, Banners
│       ├── vendors/                       # Catalog, Search, Detail, Reviews
│       ├── booking/                       # Checkout, My Bookings, Live Tracker
│       ├── budget_planner/                # Budget Calculator & Checklist Tool
│       ├── profile/                       # User Profile, Language, Currency
│       └── navigation/                    # Main Navigation Tab Bar
├── test/
│   └── widget_test.dart                   # Unit & Widget test suite
├── pubspec.yaml                           # Manifest & dependencies
├── ARCHITECTURE.md                        # Architectural deep-dive
└── README.md                              # Main documentation
```

---

## 🚀 How to Run & Build

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.0.0 or later)
- Android Studio / VS Code with Flutter extension
- JDK 17+ & Android SDK

### Steps

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/shata-events/shata-mobile-app.git
   cd flutter
   ```

2. **Install Dependencies:**
   ```bash
   C:\flutter\bin\flutter.bat pub get
   ```

3. **Run Static Analysis & Tests:**
   ```bash
   C:\flutter\bin\flutter.bat analyze
   C:\flutter\bin\flutter.bat test
   ```

4. **Run on Connected Device / Emulator:**
   ```bash
   C:\flutter\bin\flutter.bat run
   ```

5. **Build Release APK:**
   ```bash
   C:\flutter\bin\flutter.bat build apk --release
   ```
   *The release APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`.*

---

## 📱 Screenshots & Flow Diagram

```
[ Onboarding Screen ] ──> [ Home Dashboard ] ──> [ Vendor Catalog ]
                               │                         │
                               ▼                         ▼
                      [ Budget Planner ]        [ Vendor Detail View ]
                                                        │
                                                        ▼
                                             [ Booking Checkout Flow ]
                                                        │
                                                        ▼
                                              [ My Bookings Tracker ]
```

---

## 🛠 Tech Stack & Dependencies

- **Framework**: Flutter (Dart 3.x)
- **State Management**: Provider (`ChangeNotifier`, `MultiProvider`)
- **Typography**: Google Fonts (`Outfit`, `Plus Jakarta Sans`)
- **Formatting & I18n**: `intl`, `uuid`
- **Design Pattern**: Feature-First Clean Architecture

---

## 📄 License
This project is licensed under the MIT License.
