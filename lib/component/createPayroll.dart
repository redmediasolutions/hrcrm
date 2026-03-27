import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class CreateSalarySlipScreen extends StatefulWidget {
  final int employeeId;
  final String token;

  const CreateSalarySlipScreen({
    super.key,
    required this.employeeId,
    this.token = '',
  });

  @override
  State<CreateSalarySlipScreen> createState() => CreateSalarySlipScreenState();
}

class CreateSalarySlipScreenState extends State<CreateSalarySlipScreen> {
  final Color primaryTeal = const Color(0xFF0C5D6B);
  final Color bgGrey = const Color(0xFFF6F8FA);
  final basicCtrl = TextEditingController();
  final hraCtrl = TextEditingController();
  final overtimeCtrl = TextEditingController();
  final bonusCtrl = TextEditingController();

  final loansCtrl = TextEditingController();
  final advanceCtrl = TextEditingController();
  final lopCtrl = TextEditingController();
  final pfCtrl = TextEditingController();
  final esiCtrl = TextEditingController();

  double getValue(TextEditingController c) {
  return double.tryParse(c.text) ?? 0;
}

double get grossEarnings =>
    getValue(basicCtrl) +
    getValue(hraCtrl) +
    getValue(overtimeCtrl) +
    getValue(bonusCtrl);

double get totalDeductions =>
    getValue(loansCtrl) +
    getValue(advanceCtrl) +
    getValue(lopCtrl) +
    getValue(pfCtrl) +
    getValue(esiCtrl);

double get netSalary => grossEarnings - totalDeductions;

Future<void> savePayroll() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user!.getIdToken();

    final response = await http.post(
      Uri.parse('https://api.hr.rd-crm.in/api/remuneration'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
      "employee_id": widget.employeeId,
        "basic_pay": getValue(basicCtrl).toString(),
        "Bonus": getValue(bonusCtrl).toString(),
        "pf_deduction": getValue(pfCtrl).toString(),
        "professional_tax": getValue(esiCtrl).toString(),
      }),
    );

    print("RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Salary saved successfully")),
      );
    } else {
      throw Exception("Failed");
    }
  } catch (e) {
    print("ERROR: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error saving salary")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: bgGrey,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create Salary Slip",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Configure individual employee earnings and deductions for the current cycle.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Earnings and Deductions
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      buildSectionCard(
                        title: "Earnings",
                        badge: "Credit Items",
                        badgeColor: Colors.teal.shade50,
                        textColor: Colors.teal,
                        fields: [
                          payInput("Basic", basicCtrl),
                          payInput("HRA", hraCtrl),
                          payInput("Overtime", overtimeCtrl),
                          payInput("Bonus", bonusCtrl),
                        ],
                      ),
                      const SizedBox(height: 20),
                      buildSectionCard(
                        title: "Deductions",
                        badge: "Debit Items",
                        badgeColor: Colors.red.shade50,
                        textColor: Colors.red,
                        fields: [
                          payInput("Loans", loansCtrl),
                          payInput("Advance", advanceCtrl),
                          payInput("LOP", lopCtrl),
                          payInput("PF", pfCtrl),
                          payInput("ESI", esiCtrl),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                // Right Column: Summary Preview
                Expanded(child: buildSummaryCard()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionCard({
    required String title,
    required String badge,
    required Color badgeColor,
    required Color textColor,
    required List<Widget> fields,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    title == "Earnings"
                        ? Icons.add_circle
                        : Icons.remove_circle,
                    color: textColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...fields,
        ],
      ),
    );
  }

  Widget payInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          SizedBox(
            width: 140,
            height: 40,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}), // 🔥 live update
              decoration: InputDecoration(
                prefixText: "₹ ",
                filled: true,
                fillColor: bgGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowWithInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.black87)),
          const SizedBox(width: 4),
          const Icon(Icons.info_outline, size: 14, color: Colors.grey),
          const Spacer(),
          SizedBox(
            width: 140,
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                prefixText: "₹ ",
                hintText: value,
                filled: true,
                fillColor: bgGrey,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryTeal,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Summary Preview",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          summaryRow("Gross Earnings", "₹ ${grossEarnings.toStringAsFixed(2)}"),
          const SizedBox(height: 20),
          summaryRow("Total Deductions", "₹ ${totalDeductions.toStringAsFixed(2)}"),
          const SizedBox(height: 30),
          const Text(
            "NET TAKE HOME SALARY",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
         Text("₹ ${netSalary.toStringAsFixed(2)}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "/ month",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: savePayroll,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: primaryTeal,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            label: const Text(
              "SAVE",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
