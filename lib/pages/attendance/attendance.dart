import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:red_hrcrm/services/api_service.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

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
      setState(() {
        attendanceList = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching data: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        title: SizedBox(
          width: 400,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: "Search employee...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded, color: Colors.black)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.apps_outlined, color: Colors.black)),
          const VerticalDivider(indent: 20, endIndent: 20, thickness: 1),
          const CircleAvatar(
            backgroundColor: Color(0xFF0C5D6B),
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
        ],
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
            Text("Daily status for ${DateFormat('dd MMM, yyyy').format(DateTime.now())}", style: const TextStyle(color: Colors.grey)),
          ],
        ),
        Row(
          children: [
            _buildActionButton(label: "Export", icon: Icons.file_download_outlined, isPrimary: false),
            const SizedBox(width: 15),
            _buildActionButton(label: "Manual Entry", icon: Icons.add, isPrimary: true),
          ],
        ),
      ],
    );
  }

  Widget _buildKPISection() {
    return Row(
      children: [
        Expanded(
          child: _KPIBox(
            title: "Clocked In",
            number: attendanceList.where((e) => e['status'] != 'ABSENT').length.toString(),
            icon: Icons.access_time,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: _KPIBox(title: "On Break", number: "0", icon: Icons.coffee_outlined, color: Colors.orange),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _KPIBox(
            title: "Absent",
            number: attendanceList.where((e) => e['status'] == 'ABSENT').length.toString(),
            icon: Icons.person_off_outlined,
            color: Colors.redAccent,
          ),
        ),
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
              ? const Padding(padding: EdgeInsets.all(50), child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: attendanceList.length,
                  itemBuilder: (context, index) => _AttendanceRow(employee: attendanceList[index]),
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

// --- Internal Helper Widgets ---

class _KPIBox extends StatelessWidget {
  final String title, number;
  final IconData icon;
  final Color color;
  const _KPIBox({required this.title, required this.number, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
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
          Expanded(flex: 2, child: Text("Employee", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text("Check-In", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text("Check-Out", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text("Hours", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text("Selfie", style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

class _AttendanceRow extends StatelessWidget {
  final Map<String, dynamic> employee;
  const _AttendanceRow({required this.employee});

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
    return InkWell(
      onTap: () => _showDetails(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE)))),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(employee['name'] ?? "Unknown")),
            Expanded(child: Text(_formatTime(employee['check_in']))),
            Expanded(child: Text(_formatTime(employee['check_out']))),
            Expanded(child: Text(employee['total_hours'] ?? "0.0h")),
            Expanded(
              child: CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(employee['image'] ?? employee['avatar']),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(employee['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (employee['image'] != null)
              Image.network(employee['image'], height: 200, fit: BoxFit.cover),
            const SizedBox(height: 10),
            _row("In", _formatTime(employee['check_in'])),
            _row("Out", _formatTime(employee['check_out'])),
            _row("Lat", employee['latitude'].toString()),
            _row("Lng", employee['longitude'].toString()),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))],
      ),
    );
  }

  Widget _row(String label, String val) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label), Text(val)]),
  );
}