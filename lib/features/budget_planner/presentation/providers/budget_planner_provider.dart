import 'package:flutter/material.dart';

class BudgetItem {
  final String id;
  final String categoryName;
  final IconData icon;
  double allocatedAmount;
  double actualSpent;

  BudgetItem({
    required this.id,
    required this.categoryName,
    required this.icon,
    required this.allocatedAmount,
    required this.actualSpent,
  });
}

class ChecklistItem {
  final String id;
  final String title;
  final String timeframe; // e.g. "6 Months Before", "1 Month Before"
  bool isCompleted;

  ChecklistItem({
    required this.id,
    required this.title,
    required this.timeframe,
    this.isCompleted = false,
  });
}

class BudgetPlannerProvider extends ChangeNotifier {
  double _totalBudget = 500000;

  final List<BudgetItem> _items = [
    BudgetItem(
      id: 'b_1',
      categoryName: 'Catering & Food',
      icon: Icons.restaurant,
      allocatedAmount: 180000,
      actualSpent: 134000,
    ),
    BudgetItem(
      id: 'b_2',
      categoryName: 'Photography & Film',
      icon: Icons.camera_alt,
      allocatedAmount: 90000,
      actualSpent: 92000,
    ),
    BudgetItem(
      id: 'b_3',
      categoryName: 'Decor & Stage',
      icon: Icons.auto_awesome,
      allocatedAmount: 100000,
      actualSpent: 75000,
    ),
    BudgetItem(
      id: 'b_4',
      categoryName: 'Venue Rental',
      icon: Icons.location_city,
      allocatedAmount: 80000,
      actualSpent: 0,
    ),
    BudgetItem(
      id: 'b_5',
      categoryName: 'Entertainment & DJ',
      icon: Icons.music_note,
      allocatedAmount: 30000,
      actualSpent: 25000,
    ),
    BudgetItem(
      id: 'b_6',
      categoryName: 'Contingency / Misc',
      icon: Icons.account_balance_wallet,
      allocatedAmount: 20000,
      actualSpent: 5000,
    ),
  ];

  final List<ChecklistItem> _checklist = [
    ChecklistItem(
      id: 'c_1',
      title: 'Fix Event Date & Guest Estimate',
      timeframe: '6 Months Before',
      isCompleted: true,
    ),
    ChecklistItem(
      id: 'c_2',
      title: 'Book Verified Photographer on Shata',
      timeframe: '6 Months Before',
      isCompleted: true,
    ),
    ChecklistItem(
      id: 'c_3',
      title: 'Schedule Menu Tasting with Caterer',
      timeframe: '3 Months Before',
      isCompleted: true,
    ),
    ChecklistItem(
      id: 'c_4',
      title: 'Finalize Stage Decor & Lighting Theme',
      timeframe: '1 Month Before',
      isCompleted: false,
    ),
    ChecklistItem(
      id: 'c_5',
      title: 'Confirm Playlist with DJ & Emcee',
      timeframe: '2 Weeks Before',
      isCompleted: false,
    ),
    ChecklistItem(
      id: 'c_6',
      title: 'Send Final Guest Count to Caterer',
      timeframe: '1 Week Before',
      isCompleted: false,
    ),
  ];

  double get totalBudget => _totalBudget;
  List<BudgetItem> get items => _items;
  List<ChecklistItem> get checklist => _checklist;

  double get totalAllocated =>
      _items.fold(0, (sum, item) => sum + item.allocatedAmount);

  double get totalSpent =>
      _items.fold(0, (sum, item) => sum + item.actualSpent);

  double get remainingBudget => _totalBudget - totalSpent;

  int get completedChecklistCount =>
      _checklist.where((c) => c.isCompleted).length;

  void setTotalBudget(double newBudget) {
    _totalBudget = newBudget;
    notifyListeners();
  }

  void updateAllocation(String id, double amount) {
    final item = _items.firstWhere((element) => element.id == id);
    item.allocatedAmount = amount;
    notifyListeners();
  }

  void toggleChecklist(String id) {
    final item = _checklist.firstWhere((element) => element.id == id);
    item.isCompleted = !item.isCompleted;
    notifyListeners();
  }
}
