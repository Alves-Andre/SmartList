import 'package:flutter/material.dart';
import 'package:smartlist/Models/purchase_history.dart';
import 'package:smartlist/DesignSystem/shared/colors.dart';
import 'package:intl/intl.dart';

class HistoryDetailsView extends StatelessWidget {
  final PurchaseHistory purchase;

  const HistoryDetailsView({
    super.key,
    required this.purchase,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightTertiaryBaseColorLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: normalPrimaryBaseColorLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detalhes da Compra',
          style: TextStyle(color: normalPrimaryBaseColorLight),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  purchase.listName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: normalPrimaryBaseColorLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Data: ${DateFormat('dd/MM/yyyy HH:mm').format(purchase.purchaseDate)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: normalSecondaryBaseColorLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total: R\$ ${purchase.totalSpent.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: normalSecondaryBaseColorLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Itens',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: normalPrimaryBaseColorLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: purchase.items.length,
              itemBuilder: (context, index) {
                final item = purchase.items[index];
                return ListTile(
                  leading: Icon(
                    item.wasSelected ? Icons.check_circle : Icons.cancel,
                    color: item.wasSelected ? Colors.green : Colors.red,
                  ),
                  title: Text(
                    item.name,
                    style: TextStyle(
                      decoration: item.wasSelected ? TextDecoration.none : TextDecoration.lineThrough,
                    ),
                  ),
                  subtitle: Text('Quantidade: ${item.quantity}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 