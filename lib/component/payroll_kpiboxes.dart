import 'package:flutter/material.dart';

class PayrollKpiboxes extends StatelessWidget {
  final String heading;
  final String amount;
  final String subheading;
  final Color amtcolor;
  const PayrollKpiboxes({
    super.key,
    required this.heading,
    required this.amount,
    required this.subheading, 
    required this.amtcolor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      width: 520,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        border: const Border(
          left: BorderSide(color: Color(0xFF7A4E16), width: 4),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF6F7A83),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            amount,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: amtcolor,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            subheading,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF2F2F2F),
                  fontWeight: FontWeight.w500,
                ),
          )
        ],
      ),
    );
  }
}
