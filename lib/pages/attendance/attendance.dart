import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:red_hrcrm/services/api_service.dart';
import 'package:red_hrcrm/component/header.dart';

class Attendance extends StatefulWidget {
  final int? targetEmployeeId; 
  
  const Attendance({super.key, this.targetEmployeeId});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  List<Map<String, dynamic>> attendanceList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    try {
      final data = await ApiService.getRealTimeActivity();
      if (mounted) {
        setState(() {
          attendanceList = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });

        // --- AUTO-OPEN LOGIC ---
        if (widget.targetEmployeeId != null) {
          final target = attendanceList.firstWhere(
            (e) => e['employee_id'] == widget.targetEmployeeId,
            orElse: () => {},
          );

          if (target.isNotEmpty) {
            // Slight delay to ensure the list is rendered before popping the dialog
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) _showDetailsManual(context, target);
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showDetailsManual(BuildContext context, Map<String, dynamic> employee) {
    String format(dynamic time) {
      if (time == null || time == "") return "--:--";
      try {
        return DateFormat('hh:mm a').format(DateTime.parse(time.toString()));
      } catch (e) {
        return "--:--";
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(employee['name'] ?? "Attendance Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                employee['image'] ?? employee['avatar'] ?? 'https://via.placeholder.com/150',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 100),
              ),
            ),
            const SizedBox(height: 20),
            _dialogRow("Check-In", format(employee['check_in'])),
            _dialogRow("Check-Out", format(employee['check_out'])),
            const Divider(),
            _dialogRow("Total Hours", employee['total_hours'] ?? "0.0h"),
            _dialogRow("Latitude", employee['latitude']?.toString() ?? "N/A"),
            _dialogRow("Longitude", employee['longitude']?.toString() ?? "N/A"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: Color(0xFF0C5D6B))),
          )
        ],
      ),
    );
  }

  Widget _dialogRow(String label, String val) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
            Text(val, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const AppHeader(
        searchHint: "Search employee...",
        searchWidth: 400,
        searchFillColor: Color(0xFFF5F5F5),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 25),
              _buildKPISection(),
              const SizedBox(height: 25),
              _buildActivityTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Attendance Monitoring", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
            Text("Daily status for ${DateFormat('dd MMM, yyyy').format(DateTime.now())}",
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
        Row(
          // children: [
          //   _buildActionButton(label: "Export", icon: Icons.file_download_outlined, isPrimary: false),
          //   const SizedBox(width: 15),
          //   _buildActionButton(label: "Manual Entry", icon: Icons.add, isPrimary: true),
          // ],
        ),
      ],
    );
  }

  Widget _buildKPISection() {
    int clockedIn = attendanceList.where((e) => e['status'] != 'ABSENT').length;
    int absent = attendanceList.where((e) => e['status'] == 'ABSENT').length;

    return Row(
      children: [
        Expanded(child: _KPIBox(title: "Clocked In", number: "$clockedIn", icon: Icons.access_time, color: Colors.blue)),
        const SizedBox(width: 12),
        const Expanded(child: _KPIBox(title: "On Break", number: "0", icon: Icons.coffee_outlined, color: Colors.orange)),
        const SizedBox(width: 12),
        Expanded(child: _KPIBox(title: "Absent", number: "$absent", icon: Icons.person_off_outlined, color: Colors.redAccent)),
      ],
    );
  }

  Widget _buildActivityTable() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Real-time Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.filter_list), label: const Text("Filter")),
            ],
          ),
          const SizedBox(height: 20),
          const _TableHeader(),
          const Divider(height: 1),
          _isLoading
              ? const Padding(padding: EdgeInsets.all(50), child: CircularProgressIndicator(color: Color(0xFF0C5D6B)))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: attendanceList.length,
                  itemBuilder: (context, index) {
                    final emp = attendanceList[index];
                    return InkWell(
                      onTap: () => _showDetailsManual(context, emp),
                      child: _AttendanceRowContent(employee: emp),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required String label, required IconData icon, required bool isPrimary}) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? const Color(0xFF0C5D6B) : const Color(0xFFD1F0F5),
        foregroundColor: isPrimary ? Colors.white : const Color(0xFF0C5D6B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

class _AttendanceRowContent extends StatelessWidget {
  final Map<String, dynamic> employee;
  const _AttendanceRowContent({required this.employee});

  String _formatTime(dynamic time) {
    if (time == null || time == "") return "--:--";
    try {
      return DateFormat('hh:mm a').format(DateTime.parse(time.toString()));
    } catch (e) {
      return "--:--";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE)))),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(employee['name'] ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(_formatTime(employee['check_in']))),
          Expanded(child: Text(_formatTime(employee['check_out']))),
          Expanded(child: Text(employee['total_hours'] ?? "0.0h")),
          Expanded(
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(employee['image'] ?? employee['avatar'] ?? 'https://via.placeholder.com/150'),
            ),
          ),
        ],
      ),
    );
  }
}

class _KPIBox extends StatelessWidget {
  final String title, number;
  final IconData icon;
  final Color color;
  const _KPIBox({required this.title, required this.number, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12)),
          Text(number, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text("Employee", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(child: Text("Check-In", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(child: Text("Check-Out", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(child: Text("Hours", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(child: Text("Selfie", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
        ],
      ),
    );
  }
}
