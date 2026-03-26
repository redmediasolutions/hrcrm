import 'package:flutter/material.dart';

class AttendanceTable extends StatelessWidget {
  final Map<String, dynamic> employee; 

  const AttendanceTable({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
  
    final String status = employee['status'] ?? 'REGULAR';
    final bool isSickLeave = status == "SICK LEAVE";

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        // Changes background if status is Sick Leave
        color: isSickLeave ? const Color(0xFFF1F3F4) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Profile Image with Status Indicator
          _buildProfileImage(employee['image_url'], employee['dot_color']),
          const SizedBox(width: 16),

          // Name & Designation
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(employee['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(employee['designation']?.toString().toUpperCase() ?? '', 
                     style: const TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          // Time Details
          _buildInfoColumn(employee['time'] ?? '--:--', employee['time_label'] ?? 'CLOCKED IN', 
              isRed: employee['time'] == "--:--"),

          // Duration Details
          _buildInfoColumn(employee['duration'] ?? '0h 00m', 'TOTAL DURATION'),

          // Status Chip
          _buildStatusChip(status),

          if (isSickLeave) const Icon(Icons.more_vert, color: Colors.black45),
        ],
      ),
    );
  }

  Widget _buildProfileImage(String? url, String? colorHex) {
    return Stack(
      children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
            image: url != null ? DecorationImage(image: NetworkImage(url), fit: BoxFit.cover) : null,
          ),
          child: url == null ? const Icon(Icons.person, color: Colors.white) : null,
        ),
        Positioned(
          right: 0, bottom: 0,
          child: Container(
            width: 12, height: 12,
            decoration: BoxDecoration(
              color: Color(int.parse(colorHex ?? "0xFF4CAF50")),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoColumn(String value, String label, {bool isRed = false}) {
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: isRed ? Colors.redAccent : const Color(0xFF1D5D72))),
          Text(label.toUpperCase(), style: const TextStyle(color: Colors.black45, fontSize: 9, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    // Dynamic color logic based on status string
    Color bgColor = const Color(0xFFE8E9EB);
    Color textColor = const Color(0xFF7E8489);

    if (status == "REGULAR") {
      bgColor = const Color(0xFFD6E9EE);
      textColor = const Color(0xFF538D9E);
    } else if (status == "SICK LEAVE") {
      bgColor = const Color(0xFFFDE2E1);
      textColor = const Color(0xFFE57373);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(color: textColor, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }
}