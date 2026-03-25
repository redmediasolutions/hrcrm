import 'package:flutter/material.dart';
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
      final data = await ApiService.getEmployees(); // ✅ FIXED
      setState(() {
        employees = data;
        loading = false;
      });
    }catch (e) {
  print("Error: $e");
  setState(() {
    loading = false; 
  });
}
  }

  Future<void> deleteEmployee(int id) async {
    await ApiService.deleteEmployee(id);
    fetchEmployees();
  }

  void openCreatePage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateEmployeeFullPage()),
    );

    fetchEmployees(); // 🔥 auto refresh after create
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        /// 🔥 ADD BUTTON
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: openCreatePage,
            child: const Text("Add Employee"),
          ),
        ),

        const SizedBox(height: 10),

        /// TABLE
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: [
              const _EmployeeTableHeader(),

              ...employees.map((e) {
                return _EmployeeTableRow(
                  data: _EmployeeRowData(
                    id: e['id'],
                    name: e['full_name'] ?? '',
                    empId: "EMP-${e['id']}",

                    status: 'Active',
                    statusColor: Colors.green,
                    contact: e['email'] ?? '',
                  ),
                  onDelete: deleteEmployee,
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}
/* ================= HEADER ================= */

class _EmployeeTableHeader extends StatelessWidget {
  const _EmployeeTableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF3F4F6),
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: const Row(
        children: [
          _HeaderCell(text: 'EMPLOYEE', flex: 3),
          _HeaderCell(text: 'DEPARTMENT', flex: 2),
          _HeaderCell(text: 'ROLE', flex: 3),
          _HeaderCell(text: 'STATUS', flex: 2),
          _HeaderCell(text: 'CONTACT', flex: 3),
          _HeaderCell(text: 'ACTIONS', flex: 1, alignEnd: true),
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
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: const Color(0xFF6B7280),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
        ),
      ),
    );
  }
}

/* ================= ROW ================= */

class _EmployeeTableRow extends StatelessWidget {
  const _EmployeeTableRow({
    required this.data,
    required this.onDelete,
  });

  final _EmployeeRowData data;
  final Function(int) onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFF1F2937),
                  child: Icon(Icons.person, size: 18, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF111827),
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.empId,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF6B7280),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F4F1),
                  borderRadius: BorderRadius.circular(16),
                ),
                // child: Text(
                //   data.department,
                //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
                //         color: const Color(0xFF4B6E6E),
                //         fontWeight: FontWeight.w600,
                //       ),
                // ),
              ),
            ),
          ),
          // Expanded(
          //   flex: 3,
          //   child: Text(
          //     data.role,
          //     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          //           color: const Color(0xFF111827),
          //           fontWeight: FontWeight.w600,
          //         ),
          //   ),
          // ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(Icons.circle, size: 8, color: data.statusColor),
                const SizedBox(width: 8),
                Text(
                  data.status,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF111827),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              data.contact,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF4B5563),
                  ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(data.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= MODEL ================= */

class _EmployeeRowData {
  final int id;
  final String name;
  final String empId;

  final String status;
  final Color statusColor;
  final String contact;

  const _EmployeeRowData({
    required this.id,
    required this.name,
    required this.empId,

    required this.status,
    required this.statusColor,
    required this.contact,
  });
}