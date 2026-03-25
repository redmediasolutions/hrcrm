import 'package:flutter/material.dart';

class KpiBox extends StatelessWidget {
  const KpiBox({
    super.key,
    required this.title,
    required this.value,
    required this.deltaText,
    this.backgroundColor = const Color(0xFF0B5D6B),
    this.icon = Icons.group,
  });

  final String title;
  final String value;
  final String deltaText;
  final Color backgroundColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: const Color.fromARGB(180, 196, 224, 229),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color.fromARGB(255, 215, 236, 240),
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                deltaText,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color.fromARGB(170, 185, 214, 220),
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Icon(
              icon,
              size: 46,
              color: const Color.fromARGB(80, 255, 255, 255),
            ),
          ),
        ],
      ),
    );
  }
}
