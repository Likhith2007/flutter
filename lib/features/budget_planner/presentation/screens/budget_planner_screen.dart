import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shata_app/core/localization/language_provider.dart';
import 'package:shata_app/features/budget_planner/presentation/providers/budget_planner_provider.dart';

class BudgetPlannerScreen extends StatelessWidget {
  const BudgetPlannerScreen({super.key});

  void _showEditBudgetDialog(BuildContext context, BudgetPlannerProvider provider) {
    final controller = TextEditingController(
      text: provider.totalBudget.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Edit Total Event Budget',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixText: '₹ ',
              labelText: 'Total Budget (INR)',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final val = double.tryParse(controller.text.trim());
                if (val != null && val > 0) {
                  provider.setTotalBudget(val);
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = Provider.of<LanguageProvider>(context);
    final budgetProvider = Provider.of<BudgetPlannerProvider>(context);

    final totalBudget = budgetProvider.totalBudget;
    final totalSpent = budgetProvider.totalSpent;
    final remaining = budgetProvider.remainingBudget;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Event Budget Planner',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            labelColor: theme.primaryColor,
            unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
            indicatorColor: theme.primaryColor,
            labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Budget Breakdown'),
              Tab(text: 'Planning Checklist'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Budget Breakdown & Allocation
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Budget Header Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.primaryColor,
                          theme.primaryColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'TOTAL BUDGET',
                              style: GoogleFonts.outfit(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.white, size: 20),
                              onPressed: () =>
                                  _showEditBudgetDialog(context, budgetProvider),
                            ),
                          ],
                        ),
                        Text(
                          lang.formatPrice(totalBudget),
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Actual Spent',
                                  style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white70, fontSize: 12),
                                ),
                                Text(
                                  lang.formatPrice(totalSpent),
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Remaining',
                                  style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white70, fontSize: 12),
                                ),
                                Text(
                                  lang.formatPrice(remaining),
                                  style: GoogleFonts.outfit(
                                    color: remaining >= 0
                                        ? const Color(0xFF10B981)
                                        : Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Category Allocations',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Column(
                    children: budgetProvider.items.map((item) {
                      final percentage = totalBudget > 0
                          ? (item.allocatedAmount / totalBudget * 100)
                          : 0.0;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.cardTheme.color,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.dividerColor.withOpacity(0.15),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    item.icon,
                                    color: theme.primaryColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.categoryName,
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        'Spent: ${lang.formatPrice(item.actualSpent)}',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  lang.formatPrice(item.allocatedAmount),
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: (percentage / 100).clamp(0.0, 1.0),
                                      backgroundColor:
                                          theme.primaryColor.withOpacity(0.1),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          theme.primaryColor),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '${percentage.toStringAsFixed(0)}%',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Tab 2: Planning Checklist
            ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: budgetProvider.checklist.length,
              itemBuilder: (context, index) {
                final item = budgetProvider.checklist[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: theme.dividerColor.withOpacity(0.15),
                    ),
                  ),
                  child: CheckboxListTile(
                    value: item.isCompleted,
                    activeColor: theme.primaryColor,
                    onChanged: (_) => budgetProvider.toggleChecklist(item.id),
                    title: Text(
                      item.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        decoration: item.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Text(
                      item.timeframe,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
