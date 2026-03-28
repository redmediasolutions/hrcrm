import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:red_hrcrm/models/employeemodel.dart';
import 'package:red_hrcrm/pages/employee/EmployeeDetailScreen.dart';
import 'package:red_hrcrm/pages/employee/employee_tableheader.dart';
import '../../services/api_service.dart';

class EmployeeTable extends StatefulWidget {
  const EmployeeTable({super.key});

  @override
  State<EmployeeTable> createState() => _EmployeeTableState();
}

class _EmployeeTableState extends State<EmployeeTable> {
  List<EmployeeModel> employees = [];
  int currentPage = 1;
  bool hasMore = true;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage = 1;
        employees.clear();
        hasMore = true;
      }

      if (!hasMore) return;

      setState(() => loading = true);

      final res = await ApiService.getEmployees(page: currentPage, limit: 10);

      setState(() {
        employees.addAll(res.data);

        currentPage++;
        hasMore = currentPage <= res.pagination.totalPages;

        loading = false;
      });
    } catch (e) {
      debugPrint("❌ Error fetching employees: $e");
      setState(() => loading = false);
    }
  }

  // Update function where it's set to archive.
  Future<void> deleteEmployee(int id) async {
    bool confirm =
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Delete Employee?"),
            content: const Text("This action cannot be undone."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      await ApiService.deleteEmployee(id);
      fetchEmployees();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(color: Color(0xFF0C5D6B)),
        ),
      );
    }

    return Column(
      children: [
        /// TOP BAR
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Employee Directory",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              ElevatedButton.icon(
                onPressed: () => context.push("/create-employee"),
                icon: const Icon(Icons.add, size: 18),
                label: const Text("ADD EMPLOYEE"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),

        /// TABLE CONTAINER
        Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.02),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
    border: Border.all(color: const Color(0xFFE5E7EB)),
  ),
  child: Column(
    children: [
      const EmployeeTableHeader(),

      if (employees.isEmpty)
        const Padding(
          padding: EdgeInsets.all(40.0),
          child: Text(
            "No employees found.",
            style: TextStyle(color: Colors.grey),
          ),
        ),

      ...employees.map((e) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFF3F4F6)),
            ),
          ),
          child: Row(
            children: [
              /// NAME
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFFF3F4F6),
                      child: Text(
                        (e.fullName != null && e.fullName!.isNotEmpty)
                            ? e.fullName![0]
                            : "?",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.fullName ?? "N/A",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "EMP-${e.id.toString().padLeft(4, '0')}",
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// ROLE
              const Expanded(flex: 3, child: Text("Employee")),

              /// STATUS
              const Expanded(flex: 2, child: Text("Active")),

              /// EMAIL
              Expanded(flex: 3, child: Text(e.email ?? "-")),

              /// PHONE
              Expanded(flex: 3, child: Text(e.phone ?? "-")),

              /// 🔥 ACTION BUTTON
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push(
                        '/employee-details',
                        extra: e.id,
                      );
                    },
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text("View"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0C5D6B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ],
  ),
)
      ],
    );
  }
}
