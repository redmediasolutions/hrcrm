import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:red_hrcrm/models/employeemodel.dart';

import 'package:red_hrcrm/pages/employee/employee_tableheader.dart';
import '../../services/api_service.dart';
import 'package:red_hrcrm/component/kpiboxes.dart';

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
  String searchQuery = "";
  List<dynamic> departments = [];
  int? selectedDepartmentId; // 🔥 main filter

  @override
  void initState() {
    super.initState();
    fetchDepartments();
    fetchEmployees();
  }

  Future<void> fetchDepartments() async {
  try {
    final res = await ApiService.getDepartments();
    setState(() {
      departments = res;
    });
  } catch (e) {
    debugPrint("❌ Error fetching departments: $e");
  }
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

  // 🔍 FILTERED LIST (search ready)
 final filteredEmployees = employees.where((e) {
  final name = e.fullName?.toLowerCase() ?? "";
  final email = e.email?.toLowerCase() ?? "";
  final query = searchQuery.toLowerCase();

  final matchesSearch =
      name.contains(query) || email.contains(query);

  final matchesDepartment =
      selectedDepartmentId == null ||
      e.department == selectedDepartmentId;

  return matchesSearch && matchesDepartment;
}).toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      /// 🔥 HEADER (Moved from Homepage)
      Text(
        "Staff Directory",
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),

      const SizedBox(height: 6),

      Text(
        "Manage your global workforce, roles, and departmental access.",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),

      const SizedBox(height: 20),

      /// 🔥 FILTER + KPI ROW
      Row(
        children: [
          Expanded(
            child: Container(
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  /// FILTER CHIP
                  Wrap(
  spacing: 10,
  runSpacing: 10,
  children: [
    /// ALL
    ChoiceChip(
      label: const Text("All"),
      selected: selectedDepartmentId == null,
      onSelected: (_) {
        setState(() {
          selectedDepartmentId = null;
        });
      },
    ),

    /// DYNAMIC DEPARTMENTS
    ...departments.map((dept) {
      return ChoiceChip(
        label: Text(dept.name),
        selected: selectedDepartmentId == dept.id,
        onSelected: (_) {
          setState(() {
            selectedDepartmentId = dept.id;
          });
        },
      );
    }),
  ],
),

                  const Spacer(),

                  const Row(
                    children: [
                      Icon(Icons.filter_alt),
                      SizedBox(width: 5),
                      Text('Advance Filters'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          const SizedBox(
            width: 300,
            height: 150,
            child: KpiBox(
              title: 'Total Workforce',
              value: '1284',
              deltaText: '+12 this month',
            ),
          ),
        ],
      ),

      const SizedBox(height: 20),

      /// 🔍 SEARCH BAR
      TextFormField(
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: "Search employees...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),

      const SizedBox(height: 20),

      /// 🔥 TOP BAR
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Employee Directory",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          ElevatedButton.icon(
            onPressed: () => context.push("/employees/simple-create"),
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

      const SizedBox(height: 15),

      /// 🔥 TABLE
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

            if (filteredEmployees.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Text(
                  "No employees found.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),

            ...filteredEmployees.map((e) {
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

                    const Expanded(flex: 3, child: Text("Employee")),
                    const Expanded(flex: 2, child: Text("Active")),
                    Expanded(flex: 4, child: Text(e.email ?? "-")),
                    Expanded(flex: 4, child: Text(e.phone ?? "-")),

                    /// ACTION
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.go('/employees/${e.id}');
                          },
                          icon: const Icon(Icons.visibility, size: 16),
                          label: const Text("View"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0C5D6B),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    ],
  );
}
}