import 'package:flutter/material.dart';

class Payrolltable extends StatelessWidget {
  const Payrolltable({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_PayrollItem>[
      _PayrollItem(
        name: "James D'souza",
        role: 'Software Engineering',
        id: '4920',
        monthLabel: 'Monthly Salary',
        period: 'Oct 2023',
        amount: 8250.00,
        status: 'Processed',
      ),
      _PayrollItem(
        name: 'Ava Patel',
        role: 'Product Designer',
        id: '5104',
        monthLabel: 'Monthly Salary',
        period: 'Oct 2023',
        amount: 6400.00,
        status: 'Pending',
      ),
      _PayrollItem(
        name: 'Noah Kim',
        role: 'QA Engineer',
        id: '4883',
        monthLabel: 'Monthly Salary',
        period: 'Oct 2023',
        amount: 5120.00,
        status: 'Processed',
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _PayrollRow(item: items[index]),
    );
  }
}

class _PayrollRow extends StatelessWidget {
  const _PayrollRow({required this.item});

  final _PayrollItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: Color(0xFFEFF3F6),
            child: Icon(Icons.person, color: Color(0xFF2D3A4B)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF222B38),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.role} · ID: ${item.id}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7B8794),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.monthLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF7B8794),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.period,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF7B8794),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatAmount(item.amount),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E2A37),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: item.status == 'Processed'
                      ? const Color(0xFFE5F5F1)
                      : const Color(0xFFFFF3D6),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  item.status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: item.status == 'Processed'
                        ? const Color(0xFF1A9278)
                        : const Color(0xFFB7791F),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _formatAmount(double value) {
  final dollars = value.toStringAsFixed(2);
  final parts = dollars.split('.');
  final whole = parts[0];
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final idxFromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (idxFromEnd > 1 && idxFromEnd % 3 == 1) {
      buffer.write(',');
    }
  }
  return '\$${buffer.toString()}.${parts[1]}';
}

class _PayrollItem {
  _PayrollItem({
    required this.name,
    required this.role,
    required this.id,
    required this.monthLabel,
    required this.period,
    required this.amount,
    required this.status,
  });

  final String name;
  final String role;
  final String id;
  final String monthLabel;
  final String period;
  final double amount;
  final String status;
}
