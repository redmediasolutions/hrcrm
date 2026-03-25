import 'package:flutter/material.dart';

class EmployeeTable extends StatelessWidget {
  const EmployeeTable({super.key});

  static const List<_EmployeeRowData> _dummyRows = [
    _EmployeeRowData(
      name: 'Alex Rivera',
      empId: 'Emp #ID-4029',
      department: 'Design',
      role: 'Senior Product Designer',
      status: 'Active',
      statusColor: Color(0xFF0BB39C),
      contact: 'alex.r@workspace.com',
    ),
    _EmployeeRowData(
      name: 'Sarah Jenkins',
      empId: 'Emp #ID-5110',
      department: 'Engineering',
      role: 'Lead Dev-Ops',
      status: 'On Leave',
      statusColor: Color(0xFFFFA552),
      contact: 's.jenkins@workspace.com',
    ),
    _EmployeeRowData(
      name: 'David Wu',
      empId: 'Emp #ID-2098',
      department: 'Operations',
      role: 'Head of Growth',
      status: 'Active',
      statusColor: Color(0xFF0BB39C),
      contact: 'd.wu@workspace.com',
    ),
    _EmployeeRowData(
      name: 'Elena Kovic',
      empId: 'Emp #ID-3312',
      department: 'Marketing',
      role: 'Social Lead',
      status: 'Active',
      statusColor: Color(0xFF0BB39C),
      contact: 'e.kovic@workspace.com',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          const _EmployeeTableHeader(),
          ..._dummyRows.map((row) => _EmployeeTableRow(data: row)),
        ],
      ),
    );
  }
}

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

class _EmployeeTableRow extends StatelessWidget {
  const _EmployeeTableRow({required this.data});

  final _EmployeeRowData data;

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
                child: Text(
                  data.department,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF4B6E6E),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              data.role,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF111827),
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
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
          const Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.more_vert, color: Color(0xFF6B7280)),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmployeeRowData {
  final String name;
  final String empId;
  final String department;
  final String role;
  final String status;
  final Color statusColor;
  final String contact;

  const _EmployeeRowData({
    required this.name,
    required this.empId,
    required this.department,
    required this.role,
    required this.status,
    required this.statusColor,
    required this.contact,
  });
}
