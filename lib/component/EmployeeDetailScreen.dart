import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final int employeeId;

  const EmployeeDetailScreen({super.key, required this.employeeId});

  @override
  State<EmployeeDetailScreen> createState() =>
      _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  Map<String, dynamic>? data;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    final res = await ApiService.getEmployeeById(widget.employeeId);
    setState(() {
      data = res;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final d = data!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      /// 🔥 HEADER WITH BACK BUTTON
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.pop(); // ✅ GoRouter back
          },
        ),
        title: const Text(
          "Employee Details",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// 🔥 PROFILE HEADER
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.black,
                    child: Text(
                      d['full_name'][0],
                      style: const TextStyle(
                          color: Colors.white, fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d['full_name'] ?? '',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        d['position_held'] ?? 'Employee',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Active",
                      style: TextStyle(color: Colors.green),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 ALL DETAILS (NO TABS)
            _card("Basic Information", [
              _row("Full Name", d['full_name']),
              _row("Email", d['contact_email']),
              _row("Phone", d['contact_phone']),
              _row("Gender", d['gender']),
              _row("DOB", d['dob']),
            ]),

            _card("Job Details", [
              _row("Position", d['position_held']),
              _row("Salary", d['salary_drawn']),
              _row("Company", d['employer_name']),
            ]),

            _card("Bank Details", [
              _row("Bank", d['bank_name']),
              _row("Account No", d['account_number']),
              _row("IFSC", d['ifsc_code']),
            ]),

            _card("Address", [
              _row("Current", d['correspondence_address']),
              _row("Permanent", d['permanent_address']),
            ]),
          ],
        ),
      ),
    );
  }

  /// 🔥 CARD
  Widget _card(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  /// 🔥 ROW
  Widget _row(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label,
                style: const TextStyle(
                    color: Colors.grey, fontSize: 12)),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value?.toString() ?? "-",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}