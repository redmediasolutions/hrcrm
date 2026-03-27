import 'package:flutter/material.dart';
import 'package:red_hrcrm/component/EmployeeDetailScreen.dart';
import 'package:red_hrcrm/component/createPayroll.dart';

import 'package:red_hrcrm/component/employeeinfo.dart'; 
import '../services/api_service.dart';



class EmployeeTable extends StatefulWidget {
  const EmployeeTable({super.key});

  @override
  State<EmployeeTable> createState() => _EmployeeTableState();
}

class _EmployeeTableState extends State<EmployeeTable> {
  List<dynamic> employees = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    try {
      final data = await ApiService.getEmployees();
      setState(() {
        employees = data;
        loading = false;
      });
    } catch (e) {
      debugPrint("Error fetching employees: $e");
      setState(() => loading = false);
    }
  }

  Future<void> deleteEmployee(int id) async {
    bool confirm = await showDialog(
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
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;

    if (confirm) {
      await ApiService.deleteEmployee(id);
      fetchEmployees();
    }
  }

  void openCreatePage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateEmployeeFullPage()),
    );
    fetchEmployees();
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
                onPressed: openCreatePage,
                icon: const Icon(Icons.add, size: 18),
                label: const Text("ADD EMPLOYEE"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
              const _EmployeeTableHeader(),
              if (employees.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Text("No employees found.", style: TextStyle(color: Colors.grey)),
                ),
              ...employees.map((e) {
                return _EmployeeTableRow(
                  data: _EmployeeRowData(
                    id: e['id'],
                    name: e['full_name'] ?? 'N/A',
                    empId: "EMP-${e['id']}",
                    role: e['position_held'] ?? 'Staff',
                    status: 'Active',
                    contact: e['email'] ?? 'No Email',
                    salary: e['salary_drawn']?.toString() ?? '-',
                  ),
                  onDelete: deleteEmployee,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EmployeeDetailScreen(employeeId: e['id']),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmployeeTableHeader extends StatelessWidget {
  const _EmployeeTableHeader();

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
          _HeaderCell(text: 'CONTACT', flex: 4),
          _HeaderCell(text: 'ACTIONS', flex: 2, alignEnd: true),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.text, required this.flex, this.alignEnd = false});
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

class _EmployeeTableRow extends StatelessWidget {
  const _EmployeeTableRow({required this.data, required this.onDelete, required this.onTap});

  final _EmployeeRowData data;
  final Function(int) onDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFF3F4F6),
                    child: Text(data.name[0].toUpperCase(),
                        style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13), overflow: TextOverflow.ellipsis),
                        Text(data.empId, style: const TextStyle(color: Colors.black38, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(flex: 3, child: Text(data.role, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: Colors.green),
                  const SizedBox(width: 6),
                  Text(data.status, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            Expanded(flex: 2, child: Text(data.salary, style: const TextStyle(fontSize: 13, color: Colors.black54))),
            Expanded(flex: 4, child: Text(data.contact, style: const TextStyle(fontSize: 12, color: Colors.blueGrey), overflow: TextOverflow.ellipsis)),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_money, color: Colors.black54, size: 20),
                    tooltip: 'Salary Slip',
                    onPressed: () {
                      // Navigate to the UI we generated earlier
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CreateSalarySlipScreen()),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                    tooltip: 'Delete',
                    onPressed: () => onDelete(data.id),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmployeeRowData {
  final int id;
  final String name, empId, role, status, contact, salary;
  const _EmployeeRowData({
    required this.id, required this.name, required this.empId, 
    required this.role, required this.status, required this.contact, required this.salary,
  });
}