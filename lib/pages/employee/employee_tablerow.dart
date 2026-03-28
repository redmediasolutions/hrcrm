
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmployeeTableRow extends StatelessWidget {
  const EmployeeTableRow({
    required this.data,
    required this.onDelete,
    required this.onTap,
  });

  final EmployeeRowData data;
  final Function(int) onDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1),
          ),
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
                    child: Text(
                      data.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          data.empId,
                          style: const TextStyle(
                            color: Colors.black38,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                data.role,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: Colors.green),
                  const SizedBox(width: 6),
                  Text(
                    data.status,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                data.salary,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                data.email,
                style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                data.phone,
                style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
  flex: 2,
  child: Align(
    alignment: Alignment.centerRight,
    child: ElevatedButton.icon(
   onPressed: () {
  print("🟡 BUTTON CLICKED");

  print("📦 RAW DATA ID: ${data.id}");
  print("📦 TYPE OF ID: ${data.id.runtimeType}");

  if (data.id != null) {
    try {
      final int empId = data.id;

      print("✅ VALID ID: $empId");
      print("🚀 NAVIGATING TO /employee-details");

      context.push(
        '/employee-details',
        extra: empId,
      );

      print("➡️ PUSH CALLED SUCCESSFULLY");
    } catch (e) {
      print("❌ TYPE CAST ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid employee ID type")),
      );
    }
  } else {
    print("❌ ID IS NULL");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Invalid employee ID")),
    );
  }
},
      icon: const Icon(Icons.visibility, size: 16),
      label: const Text("View"),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0C5D6B),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  ),
),
          ],
        ),
      ),
    );
  }
}

class EmployeeRowData {
  final int id;
  final String name, empId, role, status, email, phone, salary;
  const EmployeeRowData({
    required this.id,
    required this.name,
    required this.empId,
    required this.role,
    required this.status,
    required this.email,
    required this.phone,
    required this.salary,
  });
}
