# Shata 2.0 - Architecture Overview & Engineering Guide

## Architectural Philosophy

The **Shata 2.0 Mobile Application** is constructed using **Clean Architecture** organized by **Feature-First Modules**. This design enforces strict separation of concerns, high testability, scalable state management, and seamless maintainability.

---

## 🏗 Layered Architecture Breakdown

Each feature module within `lib/features/` follows a three-tier layer model:

```
                  ┌─────────────────────────────────────┐
                  │          Presentation Layer         │
                  │   (Screens, Widgets, Providers)     │
                  └──────────────────┬──────────────────┘
                                     │
                                     ▼
                  ┌─────────────────────────────────────┐
                  │            Domain Layer             │
                  │      (Entities, Business Logic)     │
                  └──────────────────┬──────────────────┘
                                     │
                                     ▼
                  ┌─────────────────────────────────────┐
                  │             Data Layer              │
                  │   (Repositories, Models, Mock API)  │
                  └─────────────────────────────────────┘
```

### 1. Presentation Layer (`presentation/`)
- **Screens**: Pure, declarative UI components built using Flutter Material 3 widgets (`HomeScreen`, `VendorListScreen`, `VendorDetailScreen`, `BookingCheckoutScreen`, `BudgetPlannerScreen`, `ProfileScreen`).
- **State Notifiers / Providers**: Subclasses of `ChangeNotifier` (`VendorProvider`, `BookingProvider`, `BudgetPlannerProvider`, `ThemeProvider`, `LanguageProvider`).
- **Widgets**: Reusable presentational components (`ShataScoreBadge`, `PrimaryButton`, `ShimmerBox`).

### 2. Domain Layer (`domain/`)
- **Entities**: Core business models (`Vendor`, `VendorPackage`, `VendorReview`, `Booking`, `BudgetItem`, `ChecklistItem`).
- **Rules**: Business validations, price calculations, coupon discount computations, and search/filter predicates.

### 3. Data Layer (`data/`)
- Mock data providers, reactive data stores, and future API client interfaces designed for seamless REST/GraphQL integration.

---

## ⚡ State Management Flow

State management across Shata 2.0 is powered by **Provider** using `ChangeNotifier` streams registered at the root level via `MultiProvider` in `lib/main.dart`.

```
[ User Action (e.g. Search / Filter / Add Booking) ]
                         │
                         ▼
             [ Provider Method Invocations ]
                         │
                         ▼
              [ Internal State Update ]
                         │
                         ▼
                [ notifyListeners() ]
                         │
                         ▼
       [ Re-render Selective Listening Widgets ]
```

### Core Providers:
1. **`ThemeProvider`**: Manages Light, Dark, and System theme modes with persistent theme tokens.
2. **`LanguageProvider`**: Handles internationalization (EN, TE, HI, AR), text direction LTR/RTL, and currency conversions (INR, USD, SAR).
3. **`VendorProvider`**: Reactive catalog manager handling category filters, instant fuzzy search, price/rating sorting, and user wishlist persistence.
4. **`BookingProvider`**: Manages active, completed, and cancelled event bookings with real-time order status updates.
5. **`BudgetPlannerProvider`**: Manages user's total event budget, category percentage allocations, spent totals, and timeline checklist items.

---

## 🎨 Theme & Design Token Architecture

The design system in `lib/core/theme/app_theme.dart` provides standardized color tokens and typography:

| Token | Light Theme | Dark Theme | Purpose |
| :--- | :--- | :--- | :--- |
| `primaryColor` | `#6B21A8` (Royal Purple) | `#A855F7` (Amethyst Accent) | Primary actions, buttons, active icons |
| `secondaryColor` | `#F59E0B` (Amber Gold) | `#F59E0B` (Amber Gold) | SHATA Score, badges, special highlights |
| `surfaceColor` | `#FFFFFF` | `#1E293B` (Slate Dark) | Card backgrounds & bottom sheets |
| `backgroundColor` | `#F8FAFC` | `#0F172A` (Midnight Navy) | Scaffold backgrounds |

---

## 🧪 Testing & Verification Strategy

- **Widget Smoke Tests**: Ensures all providers initialize correctly and screen trees build without errors.
- **Provider Unit Tests**: Validates category filtering logic, search queries, budget calculations, and booking workflows.
- **Static Analysis**: Verified with `flutter analyze` adhering to `flutter_lints` standards.

---

## 🚀 Performance Optimizations Implemented

1. **`IndexedStack` Navigation**: Preserves state across tab switches to prevent costly re-initializations.
2. **Lazy List Rendering**: `ListView.builder` and `GridView.builder` used across all catalogs and feeds.
3. **Const Constructors**: Extensive use of `const` widgets to minimize unnecessary widget rebuilds.
4. **Shimmer Skeletons**: Smooth non-blocking UI placeholder animations during data loading.
