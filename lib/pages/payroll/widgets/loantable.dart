import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoanTable extends StatelessWidget {
  const LoanTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. FILTER BAR
     

        // 2. TABLE HEADER
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Row(
            children: const [
              Expanded(flex: 3, child: _HeaderText("EMPLOYEE NAME")),
              Expanded(flex: 2, child: _HeaderText("TOTAL LOAN AMOUNT")),
              Expanded(flex: 2, child: _HeaderText("MONTHLY SALARY")),
              Expanded(flex: 2, child: _HeaderText("TOTAL DEDUCTIONS")),
              Expanded(flex: 2, child: _HeaderText("OUTSTANDING BALANCE")),
              Expanded(flex: 1, child: _HeaderText("STATUS")),
              Expanded(flex: 1, child: _HeaderText("ACTION", align: TextAlign.right)),
            ],
          ),
        ),

        // 3. TABLE ROWS
        _buildDataRow(
          context,
          name: "Marcus Chen",
          role: "Senior Architect • Engineering",
          loan: "\$12,000.00",
          salary: "\$8,500.00",
          deduction: "\$4,500.00",
          balance: "\$7,500.00",
          status: "Active",
          action: "View Details",
        ),
        _buildDataRow(
          context,
          name: "Elena Rodriguez",
          role: "Product Manager • Marketing",
          loan: "\$5,000.00",
          salary: "\$6,200.00",
          deduction: "\$4,200.00",
          balance: "\$800.00",
          status: "Active",
          action: "View Details",
        ),
        _buildDataRow(
          context,
          name: "David Sterling",
          role: "Director • Finance",
          loan: "\$25,000.00",
          salary: "\$12,000.00",
          deduction: "\$25,000.00",
          balance: "\$0.00",
          status: "Cleared",
          action: "Archive",
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildDataRow(BuildContext context,
      {required String name,
      required String role,
      required String loan,
      required String salary,
      required String deduction,
      required String balance,
      required String status,
      required String action,
      bool isLast = false}) {
    bool isActive = status == "Active";

    return InkWell(
      onTap: action == "Archive" ? null : () => context.go('/payroll/details'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          border:
              isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
        ),
        child: Row(
          children: [
            // Employee Name Cell
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFEEEEEE),
                    child: Icon(Icons.person, size: 20, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        role,
                        style:
                            const TextStyle(color: Colors.black45, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                loan,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                salary,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                deduction,
                style: const TextStyle(color: Colors.black54),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                balance,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color:
                      balance == "\$0.00" ? Colors.black26 : const Color(0xFF0C5D6B),
                ),
              ),
            ),

            // Status Badge
            Expanded(
              flex: 1,
              child: UnconstrainedBox(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFFE6F7F4)
                        : const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isActive ? Icons.circle : Icons.check_circle,
                        size: 8,
                        color: isActive ? const Color(0xFF00A389) : Colors.black45,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status,
                        style: TextStyle(
                          color: isActive
                              ? const Color(0xFF00A389)
                              : Colors.black54,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Action
            Expanded(
              flex: 1,
              child: Text(
                action,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color:
                      action == "Archive" ? Colors.black26 : const Color(0xFF0C5D6B),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  decoration: action == "Archive" ? null : TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Helper Widgets ---
}

class _HeaderText extends StatelessWidget {
  final String text;
  final TextAlign align;
  const _HeaderText(this.text, {this.align = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: const TextStyle(color: Colors.black45, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8),
    );
  }
}
