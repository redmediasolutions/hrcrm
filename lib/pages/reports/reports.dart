import 'package:flutter/material.dart';
import 'package:red_hrcrm/models/reports_model.dart';
import 'package:red_hrcrm/services/api_service.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  static const Color primaryTeal = Color(0xFF0C5D6B);
  static const Color bgGrey      = Color(0xFFF3F4F6);
  static const Color accentBlue  = Color(0xFF2196F3);

  List<DailyReportModel> _allReports     = [];
  List<DailyReportModel> _filteredReports = [];
  DailyReportModel?      _selected;

  bool   _isLoading    = true;
  String _searchQuery  = '';
  String _statusFilter = 'All';

  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Data ─────────────────────────────────────────────────────────────────

  Future<void> _fetchReports() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService.getDailyReports();
      setState(() {
        _allReports      = data;
        _filteredReports = data;
        _selected        = data.isNotEmpty ? data.first : null;
        _isLoading       = false;
      });
    } catch (e) {
      debugPrint("Report fetch error: $e");
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    final q = _searchQuery.toLowerCase();
    setState(() {
      _filteredReports = _allReports.where((r) {
        final matchesSearch = q.isEmpty ||
            r.fullName.toLowerCase().contains(q) ||
            r.todaysTasks.toLowerCase().contains(q);
        final matchesStatus = _statusFilter == 'All' ||
            r.status.toLowerCase() == _statusFilter.toLowerCase();
        return matchesSearch && matchesStatus;
      }).toList();

      // Keep selected in sync
      if (_selected != null &&
          !_filteredReports.any((r) => r.id == _selected!.id)) {
        _selected = _filteredReports.isNotEmpty ? _filteredReports.first : null;
      }
    });
  }

  Future<void> _markReviewed(DailyReportModel report) async {
    try {
      await ApiService.updateReportStatus(report.id, 'reviewed');
      await _fetchReports();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Report marked as reviewed"),
            backgroundColor: primaryTeal,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ── KPI counts ────────────────────────────────────────────────────────────

  int get _totalCount    => _allReports.length;
  int get _reviewedCount => _allReports.where((r) => r.status == 'reviewed').length;
  int get _pendingCount  => _allReports.where((r) => r.status == 'submitted').length;
  int get _flaggedCount  => _allReports.where((r) => r.status == 'flagged').length;

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      body: Row(
        children: [
          // ── Main panel ──────────────────────────────────────────────────
          Expanded(
            flex: 4,
            child: RefreshIndicator(
              onRefresh: _fetchReports,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32),
                    _buildKPIGrid(),
                    const SizedBox(height: 32),
                    _buildFilterBar(),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(color: primaryTeal),
                          )
                        : _filteredReports.isEmpty
                            ? _buildEmpty()
                            : _buildReportList(),
                  ],
                ),
              ),
            ),
          ),

          // ── Inspection panel ────────────────────────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _selected != null
                ? Container(
                    key: ValueKey(_selected!.id),
                    width: 380,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        left: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: _buildInspectionPanel(_selected!),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Daily Reports",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: primaryTeal,
                letterSpacing: -1,
              ),
            ),
            Text(
              "Organisation-wide output and blockers",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
            ),
          ],
        ),
        IconButton(
          onPressed: _fetchReports,
          icon: const Icon(Icons.refresh_rounded, color: primaryTeal),
          tooltip: "Refresh",
        ),
      ],
    );
  }

  // ── KPI Grid ──────────────────────────────────────────────────────────────

  Widget _buildKPIGrid() {
    return Row(
      children: [
        _kpiCard("TOTAL",    _totalCount.toString(),    "All time",     accentBlue),
        const SizedBox(width: 16),
        _kpiCard("PENDING",  _pendingCount.toString(),  "Need review",  Colors.orange),
        const SizedBox(width: 16),
        _kpiCard("REVIEWED", _reviewedCount.toString(), "Completed",    primaryTeal),
        const SizedBox(width: 16),
        _kpiCard("FLAGGED",  _flaggedCount.toString(),  "High priority",Colors.red),
      ],
    );
  }

  Widget _kpiCard(String title, String value, String sub, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(22),
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.grey,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Container(height: 3, width: 24, color: color),
                const SizedBox(width: 8),
                Text(
                  sub,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Filter bar ────────────────────────────────────────────────────────────

  Widget _buildFilterBar() {
    const statuses = ['All', 'Submitted', 'Reviewed', 'Flagged'];

    return Row(
      children: [
        // Search
        Expanded(
          child: TextField(
            controller: _searchCtrl,
            onChanged: (v) {
              _searchQuery = v;
              _applyFilters();
            },
            decoration: InputDecoration(
              hintText: "Search by name or task...",
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Status dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _statusFilter,
              items: statuses
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  _statusFilter = v;
                  _applyFilters();
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // ── Report list ───────────────────────────────────────────────────────────

  Widget _buildReportList() {
    return Column(
      children: _filteredReports.map((report) {
        final isSelected = _selected?.id == report.id;
        return GestureDetector(
          onTap: () => setState(() => _selected = report),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? primaryTeal : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                _avatar(report.initials),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        report.todaysTasks,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _statusBadge(report.status),
                    const SizedBox(height: 4),
                    Text(
                      report.formattedTime,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Inspection panel ──────────────────────────────────────────────────────

  Widget _buildInspectionPanel(DailyReportModel report) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + name
          Center(
            child: Column(
              children: [
                _avatar(report.initials, radius: 36),
                const SizedBox(height: 14),
                Text(
                  report.fullName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  report.email,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 8),
                _statusBadge(report.status),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Divider(color: Colors.grey.shade100, thickness: 1.5),
          const SizedBox(height: 20),

          // Date
          Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 6),
              Text(
                "${report.formattedDate}  •  ${report.formattedTime}",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Today's tasks
          _sectionLabel("TODAY'S FOCUS"),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryTeal.withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryTeal.withOpacity(0.1)),
            ),
            child: Text(
              report.todaysTasks.isNotEmpty
                  ? report.todaysTasks
                  : "No tasks listed.",
              style: const TextStyle(fontSize: 14, height: 1.65),
            ),
          ),

          const SizedBox(height: 24),

          // Challenges
          _sectionLabel("CHALLENGES & BLOCKERS"),
          const SizedBox(height: 10),
          report.hasChallenges
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.12)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: Colors.red, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          report.challenges!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline,
                          color: Colors.green, size: 18),
                      const SizedBox(width: 8),
                      const Text(
                        "No blockers reported",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),

          const SizedBox(height: 32),

          // Mark reviewed button (only if still submitted)
          if (report.status == 'submitted')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _markReviewed(report),
                icon: const Icon(Icons.check_rounded, size: 18),
                label: const Text(
                  "Mark as Reviewed",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryTeal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),

          const SizedBox(height: 12),

          // Footer note
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.phone_android_rounded,
                    color: primaryTeal, size: 16),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    "Submitted via the mobile app",
                    style: TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty state ───────────────────────────────────────────────────────────

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              "No reports found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Try adjusting your search or filter",
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _avatar(String initials, {double radius = 22}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: primaryTeal.withOpacity(0.1),
      child: Text(
        initials,
        style: TextStyle(
          color: primaryTeal,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.65,
        ),
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bg;
    Color fg;
    String label;

    switch (status.toLowerCase()) {
      case 'reviewed':
        bg = Colors.green.withOpacity(0.1);
        fg = Colors.green.shade700;
        label = 'Reviewed';
        break;
      case 'flagged':
        bg = Colors.red.withOpacity(0.1);
        fg = Colors.red.shade700;
        label = 'Flagged';
        break;
      default:
        bg = accentBlue.withOpacity(0.1);
        fg = accentBlue;
        label = 'New';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: fg,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: Colors.grey,
        letterSpacing: 1.2,
      ),
    );
  }
}