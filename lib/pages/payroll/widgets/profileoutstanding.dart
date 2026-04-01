import 'package:flutter/material.dart';

class Profileoutstanding extends StatelessWidget {
  const Profileoutstanding({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // 1. Statistics Card (White)
    Expanded(
      flex: 3, // Takes more space as seen in the image
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Portfolio Outstanding
              _buildStatItem(
                context,
                "PORTFOLIO OUTSTANDING",
                "\$428,500.00",
                isCurrency: true,
                badge: "+4.2% VS LAST MONTH",
              ),
              const VerticalDivider(color: Colors.black12, thickness: 1, indent: 10, endIndent: 10),
              // Active Deductions
              _buildStatItem(
                context,
                "ACTIVE DEDUCTIONS",
                "142",
                subtext: "Spanning 14 departments",
              ),
              const VerticalDivider(color: Colors.black12, thickness: 1, indent: 10, endIndent: 10),
              // Collection Rate
              _buildStatItem(
                context,
                "COLLECTION RATE",
                "99.8%",
                valueColor: const Color(0xFF00A389), // Teal color
                subtext: "Auto-recovery enabled",
              ),
            ],
          ),
        ),
      ),
    ),
  ],
);

// Helper method to build the stat columns

  }

  Widget _buildStatItem(BuildContext context, String title, String value,
    {bool isCurrency = false, String? badge, String? subtext, Color? valueColor}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        value,
        style: TextStyle(
          color: valueColor ?? const Color(0xFF00334E),
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(height: 8),
      if (badge != null)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F5F3),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.trending_up, size: 12, color: Color(0xFF00A389)),
              const SizedBox(width: 4),
              Text(
                badge,
                style: const TextStyle(color: Color(0xFF00A389), fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      if (subtext != null)
        Text(
          subtext,
          style: const TextStyle(color: Colors.black38, fontSize: 11),
        ),
    ],
  );
}
}
