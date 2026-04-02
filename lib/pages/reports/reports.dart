import 'package:flutter/material.dart';
import 'package:red_hrcrm/services/api_service.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  final Color primaryTeal = const Color(0xFF0C5D6B);
  final Color bgGrey = const Color(0xFFF3F4F6); 
  final Color accentBlue = const Color(0xFF2196F3);

  List<Map<String, dynamic>> submissions = [];
  bool isLoading = true;
  Map<String, dynamic>? selectedReport;

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    try {
      final data = await ApiService.getDailyReports();
      final formatted = data.map<Map<String, dynamic>>((item) {
        return {
          "name": item['full_name'] ?? "Unknown",
          "role": "TEAM MEMBER",
          "focus": item['todays_tasks'] ?? "No tasks listed",
          "challenges": item['challenges'],
          "time": item['created_at'] ?? "Just now",
          "status": "NEW",
          "id": item['id'],
        };
      }).toList();

      setState(() {
        submissions = formatted;
        selectedReport = formatted.isNotEmpty ? formatted[0] : null;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      body: Row(
        children: [
          // MAIN DASHBOARD
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildKPIGrid(),
                  const SizedBox(height: 40),
                  _buildFilterBar(),
                  const SizedBox(height: 24),
                  isLoading
                      ? Center(child: CircularProgressIndicator(color: primaryTeal))
                      : _buildReportList(),
                ],
              ),
            ),
          ),

          // SIDE INSPECTION PANEL (Clean SaaS Style)
          if (selectedReport != null)
            Container(
              width: 380,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(left: BorderSide(color: Colors.grey.shade200)),
              ),
              child: _buildInspectionPanel(selectedReport!),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Daily Reports Monitoring",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: primaryTeal, letterSpacing: -1)),
        const SizedBox(height: 4),
        Text("Overview of organization-wide output and blockers.",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
      ],
    );
  }

  Widget _buildKPIGrid() {
    return Row(
      children: [
        _kpiCard("TOTAL SUBMISSIONS", "142", "+12%", accentBlue),
        const SizedBox(width: 20),
        _kpiCard("PENDING REVIEW", "28", "Active", Colors.orange),
        const SizedBox(width: 20),
        _kpiCard("CRITICAL BLOCKERS", "04", "High Priority", Colors.red),
        const SizedBox(width: 20),
        _kpiCard("AVG. TIME LOGGED", "7.2h", "Target 6.5h", Colors.blueGrey),
      ],
    );
  }

  Widget _kpiCard(String title, String value, String tag, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1.1)),
            const SizedBox(height: 16),
            Text(value, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1)),
            const SizedBox(height: 4),
            Container(height: 3, width: 30, color: color), 
          ],
        ),
      ),
    );
  }

  Widget _buildReportList() {
    return Column(
      children: submissions.map((data) {
        final bool isSelected = selectedReport == data;
        return GestureDetector(
          onTap: () => setState(() => selectedReport = data),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? primaryTeal : Colors.transparent, width: 2),
            ),
            child: Row(
              children: [
                _buildAvatar(data['name']),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['name'], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                      Text(data['focus'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  ),
                ),
                Text(data['status'], style: TextStyle(color: accentBlue, fontWeight: FontWeight.bold, fontSize: 11)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInspectionPanel(Map<String, dynamic> data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(data['name'], radius: 35),
          const SizedBox(height: 16),
          Text(data['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          Text(data['role'], style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 32),
          _sectionTitle("TODAY'S FOCUS"),
          const SizedBox(height: 12),
          Text(data['focus'], style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87)),
          const SizedBox(height: 32),
          _sectionTitle("CHALLENGES"),
          const SizedBox(height: 12),
          if (data['challenges'] != null && data['challenges'].toString().isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.1)),
              ),
              child: Text(data['challenges'], style: const TextStyle(color: Colors.red, fontSize: 14, height: 1.5)),
            )
          else
            const Text("No blockers reported.", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
          
          const SizedBox(height: 60),
          // SaaS Context Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: primaryTeal.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: primaryTeal, size: 20),
                const SizedBox(width: 12),
                const Expanded(child: Text("This report was submitted via the mobile gateway.", style: TextStyle(fontSize: 12, color: Colors.black54))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1.2));
  }

  Widget _buildFilterBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Filter by name...",
              prefixIcon: const Icon(Icons.search, size: 20),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        _dropdown("Departments"),
        const SizedBox(width: 12),
        _dropdown("Status"),
      ],
    );
  }

  Widget _dropdown(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [Text(label, style: const TextStyle(fontWeight: FontWeight.w600)), const Icon(Icons.arrow_drop_down)]),
    );
  }

  Widget _buildAvatar(String name, {double radius = 22}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: primaryTeal.withOpacity(0.1),
      child: Text(name[0].toUpperCase(), style: TextStyle(color: primaryTeal, fontWeight: FontWeight.bold)),
    );
  }
}