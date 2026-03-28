
import 'package:flutter/material.dart';

class EmployeeTableHeader extends StatelessWidget {
  const EmployeeTableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: const Row(
        children: [
          _HeaderCell(text: 'EMPLOYEE', flex: 4),
          _HeaderCell(text: 'POSITION', flex: 3),
          _HeaderCell(text: 'STATUS', flex: 2),
          _HeaderCell(text: 'SALARY', flex: 2),
          _HeaderCell(text: 'EMAIL', flex: 4),
          _HeaderCell(text: 'PHONE', flex: 4),
          _HeaderCell(text: 'ACTIONS', flex: 2, alignEnd: true),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({
    required this.text,
    required this.flex,
    this.alignEnd = false,
  });
  final String text;
  final int flex;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black45,
            fontWeight: FontWeight.w800,
            fontSize: 10,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}
