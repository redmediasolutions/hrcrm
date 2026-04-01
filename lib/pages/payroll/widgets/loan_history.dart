import 'package:flutter/material.dart';

class LoanHistoryTable extends StatelessWidget {
  const LoanHistoryTable({
    super.key,
    required this.items,
  });

  final List<LoanHistoryItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LoanHistoryHeader(),
        const SizedBox(height: 10),
        ...items.map(
          (item) => _LoanHistoryRow(item: item),
        ),
      ],
    );
  }
}

class LoanHistoryItem {
  LoanHistoryItem({
    required this.date,
    required this.amount,
    required this.reason,
    required this.status,
    required this.statusColor,
    this.reference,
  });

  final String date;
  final String amount;
  final String reason;
  final String status;
  final Color statusColor;
  final String? reference;
}

class _LoanHistoryHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HeaderCell(label: 'DATE', flex: 2),
        _HeaderCell(label: 'AMOUNT', flex: 2),
        _HeaderCell(label: 'REASON', flex: 2),
        _HeaderCell(label: 'STATUS', flex: 1),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.label, this.flex = 1});

  final String label;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              letterSpacing: 0.6,
              color: Colors.black54,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _LoanHistoryRow extends StatelessWidget {
  const _LoanHistoryRow({required this.item});

  final LoanHistoryItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0x11000000)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                if (item.reference != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.reference!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black45,
                        ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.amount,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.reason,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black54,
                  ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: item.statusColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.status,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: item.statusColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
