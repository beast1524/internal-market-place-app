import 'package:flutter/material.dart';

enum HistoryFilter { bought, sold, donated }

class HistoryPage extends StatelessWidget {
  final HistoryFilter filter;
  final List<Map<String, dynamic>> history;

  const HistoryPage({
    super.key,
    required this.filter,
    required this.history,
  });

  String _title() {
    switch (filter) {
      case HistoryFilter.bought:
        return 'Bought Items';
      case HistoryFilter.sold:
        return 'Sold Items';
      case HistoryFilter.donated:
        return 'Donated Items';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = history.where((e) => e['type'] == filter).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_title()),
      ),
      body: filtered.isEmpty
          ? const Center(child: Text('No items available.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final item = filtered[index];
                final amount = item['amount'] as double;

                return Card(
                  child: ListTile(
                    title: Text(item['title']),
                    subtitle: Text('Date: ${item['date']}'),
                    trailing: amount > 0
                        ? Text('₹${amount.toStringAsFixed(0)}')
                        : const Text('Free'),
                  ),
                );
              },
            ),
    );
  }
}
