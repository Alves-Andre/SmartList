import 'package:flutter/material.dart';
import 'package:smartlist/DesignSystem/shared/colors.dart';
import 'package:smartlist/Models/purchase_history.dart';
import 'package:smartlist/Database/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:smartlist/Views/HistoryDetails/history_details_view.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  List<PurchaseHistory> _history = [];

  @override
  void initState() {
    super.initState();
    _refreshHistory();
  }

  Future<void> _refreshHistory() async {
    final history = await DatabaseHelper.instance.getPurchaseHistory();
    setState(() {
      _history = history;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightTertiaryBaseColorLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Histórico de Compras',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: normalPrimaryBaseColorLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: _history.isEmpty
                  ? const Center(
                      child: Text('Nenhuma compra registrada'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _history.length,
                      itemBuilder: (context, index) {
                        final purchase = _history[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          shadowColor: normalPurpleBrandColor.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(
                              color: normalPurpleBrandColor,
                              width: 1,
                            ),
                          ),
                          color: Colors.white,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HistoryDetailsView(
                                    purchase: purchase,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: darkPurpleBrandColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.history,
                                      color: darkPurpleBrandColor,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          purchase.listName,
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: normalPrimaryBaseColorLight,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          DateFormat('dd/MM/aaaa HH:mm').format(purchase.purchaseDate),
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: normalSecondaryBaseColorLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'R\$ ${purchase.totalSpent.toStringAsFixed(2)}',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: darkPurpleBrandColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
} 