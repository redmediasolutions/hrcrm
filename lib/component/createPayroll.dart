import 'package:flutter/material.dart';

class CreateSalarySlipScreen extends StatefulWidget {
  const CreateSalarySlipScreen({super.key});

  @override
  State<CreateSalarySlipScreen> createState() => CreateSalarySlipScreenState();
}

class CreateSalarySlipScreenState extends State<CreateSalarySlipScreen> {
  final Color primaryTeal = const Color(0xFF0C5D6B);
  final Color bgGrey = const Color(0xFFF6F8FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: bgGrey,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
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
                          payInput("Basic", "0"),
                          payInput("HRA", "0"),
                          payInput("Overtime", "0"),
                          payInput("Bonus", "0"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      buildSectionCard(
                        title: "Deductions",
                        badge: "Debit Items",
                        badgeColor: Colors.red.shade50,
                        textColor: Colors.red,
                        fields: [
                          payInput("Loans", "0"),
                          payInput("Advance", "0"),
                          rowWithInfo("LOP", "0"),
                          payInput("PF", "0"),
                          payInput("ESI", "0"),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                // Right Column: Summary Preview
                Expanded(
                  child: buildSummaryCard(),
                ),
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
                  Icon(title == "Earnings" ? Icons.add_circle : Icons.remove_circle,
                      color: textColor, size: 20),
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(6)),
                child: Text(badge,
                    style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...fields,
        ],
      ),
    );
  }

  Widget payInput(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.black87))),
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
                    borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
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
                    borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
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
          const Text("Summary Preview",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          summaryRow("Gross Earnings", "₹ 0"),
          const SizedBox(height: 20),
          summaryRow("Total Deductions", "₹ 0"),
          const SizedBox(height: 30),
          const Text("NET TAKE HOME SALARY",
              style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
          const Text("₹ 0",
              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const Text("/ month", style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              // Logic to save salary slip
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: primaryTeal,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            label: const Text("SAVE", style: TextStyle(fontWeight: FontWeight.bold)),
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
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        Text(value,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}