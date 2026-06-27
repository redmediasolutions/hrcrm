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

        if (widget.targetEmployeeId != null) {
          final target = attendanceList.firstWhere(
            (e) => e['employee_id'] == widget.targetEmployeeId,
            orElse: () => {},
          );
          if (target.isNotEmpty) {
            _showDetailsManual(context, target);
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _format(dynamic time) {
    if (time == null || time == "") return "--:--";
    try {
      return DateFormat('hh:mm a').format(DateTime.parse(time.toString()));
    } catch (e) {
      return "--:--";
    }
  }

  void _showDetailsManual(BuildContext context, Map<String, dynamic> employee) {
  Future.delayed(Duration.zero, () {
    if (!mounted) return;

    final String status = employee['status']?.toString() ?? 'ABSENT';
    final bool isPresent = status != 'ABSENT';
    final selfie = employee['selfie_url']?.toString();
    final profile = employee['image']?.toString();
    final imageUrl = (selfie != null && selfie.isNotEmpty)
        ? selfie
        : (profile != null && profile.isNotEmpty)
            ? profile
            : null;

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          // --- CONSTRAINT ADDED HERE ---
          constraints: const BoxConstraints(maxWidth: 420), 
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Hero image / avatar ──────────────────────────
              Stack(
                children: [
                  Container(
                    height: 240, // Slightly taller for better image visibility
                    width: double.infinity,
                    color: const Color(0xFF0C5D6B),
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            errorBuilder: (_, _, _) =>
                                _avatarPlaceholder(employee['full_name']),
                          )
                        : _avatarPlaceholder(employee['full_name']),
                  ),
                  
                  // Gradient overlay to make text/icons pop
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Status badge top-right
                  Positioned(
                    top: 16,
                    right: 16,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ColorFilter.mode(Colors.black.withValues(alpha: 0.1), BlendMode.darken),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          color: isPresent ? Colors.green.shade600 : Colors.red.shade600,
                          child: Text(
                            status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Close button
                  Positioned(
                    top: 16,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.of(ctx).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),

              // ── Details Section ────────────────────────────
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      employee['full_name']?.toString() ?? "Unknown",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Employee ID: ${employee['employee_id'] ?? 'N/A'}",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    
                    const SizedBox(height: 24),

                    // ── Time cards ──────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: _timeCard(
                            icon: Icons.login_rounded,
                            label: "CHECK-IN",
                            value: _format(employee['check_in']),
                            color: const Color(0xFF0C5D6B),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _timeCard(
                            icon: Icons.logout_rounded,
                            label: "CHECK-OUT",
                            value: _format(employee['check_out']),
                            color: const Color(0xFF6B3B0C),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ── Stats row ───────────────────────────────────
                    Row(
                      children: [
                        Expanded(child: _statChip(Icons.access_time_filled_rounded, "Hours", employee['total_hours']?.toString() ?? "0.0h")),
                        const SizedBox(width: 8),
                        Expanded(child: _statChip(Icons.explore_rounded, "Lat", _formatCoord(employee['latitude']))),
                        const SizedBox(width: 8),
                        Expanded(child: _statChip(Icons.explore_outlined, "Lng", _formatCoord(employee['longitude']))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  });
}

// Helper for coordinate formatting to keep the UI clean
String _formatCoord(dynamic val) {
  if (val == null) return "N/A";
  return double.tryParse(val.toString())?.toStringAsFixed(4) ?? "N/A";
}

  Widget _avatarPlaceholder(dynamic name) {
    final initials = (name?.toString() ?? "?")
        .trim()
        .split(" ")
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : "")
        .join();
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 64,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _timeCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade400),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

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
            const Text(
              "Attendance Monitoring",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            Text(
              "Daily status for ${DateFormat('dd MMM, yyyy').format(DateTime.now())}",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        // Refresh button
        IconButton(
          onPressed: () {
            setState(() => _isLoading = true);
            fetchAttendance();
          },
          icon: const Icon(Icons.refresh_rounded),
          tooltip: "Refresh",
        ),
      ],
    );
  }

  Widget _buildKPISection() {
    int clockedIn = attendanceList.where((e) => e['status'] != 'ABSENT').length;
    int absent = attendanceList.where((e) => e['status'] == 'ABSENT').length;
    int checkedOut = attendanceList
        .where((e) => e['check_out'] != null && e['check_out'] != "")
        .length;

    return Row(
      children: [
        Expanded(
          child: _KPIBox(
            title: "Clocked In",
            number: "$clockedIn",
            icon: Icons.access_time,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _KPIBox(
            title: "Checked Out",
            number: "$checkedOut",
            icon: Icons.check_circle_outline,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _KPIBox(
            title: "Absent",
            number: "$absent",
            icon: Icons.person_off_outlined,
            color: Colors.redAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Real-time Activity",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const _TableHeader(),
              _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(50),
                      child: CircularProgressIndicator(
                          color: Color(0xFF0C5D6B)),
                    )
                  : attendanceList.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(40),
                          child: Text(
                            "No attendance data for today",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: attendanceList.length,
                          itemBuilder: (context, index) {
                            final emp = attendanceList[index];
                            return InkWell(
                              // ✅ FIXED: wrap in Future.delayed
                              onTap: () => Future.delayed(
                                Duration.zero,
                                () => _showDetailsManual(context, emp),
                              ),
                              borderRadius: BorderRadius.circular(0),
                              child: _AttendanceRowContent(employee: emp),
                            );
                          },
                        ),
            ],
          ),
        ),
      ],
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
    final bool isAbsent = employee['status'] == 'ABSENT';
    final selfie = employee['selfie_url']?.toString();
    final profile = employee['image']?.toString();
    final url = (selfie != null && selfie.isNotEmpty)
        ? selfie
        : (profile != null && profile.isNotEmpty)
            ? profile
            : null;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isAbsent
                  ? Colors.red.shade50
                  : const Color(0xFF0C5D6B).withValues(alpha: 0.1),
            ),
            clipBehavior: Clip.antiAlias,
            child: url != null
                ? Image.network(
                    url,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.person,
                      size: 20,
                      color: isAbsent
                          ? Colors.red.shade300
                          : const Color(0xFF0C5D6B),
                    ),
                  )
                : Icon(
                    Icons.person,
                    size: 20,
                    color: isAbsent
                        ? Colors.red.shade300
                        : const Color(0xFF0C5D6B),
                  ),
          ),

          // Name
          Expanded(
            flex: 2,
            child: Text(
              employee['full_name']?.toString() ?? "Unknown",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isAbsent ? Colors.redAccent : Colors.black,
                fontSize: 14,
              ),
            ),
          ),

          Expanded(
            child: Text(
              _formatTime(employee['check_in']),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              _formatTime(employee['check_out']),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              employee['total_hours']?.toString() ?? "0.0h",
              style: const TextStyle(fontSize: 13),
            ),
          ),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isAbsent
                  ? Colors.red.shade50
                  : Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isAbsent ? "Absent" : "Present",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isAbsent
                    ? Colors.red.shade600
                    : Colors.green.shade600,
              ),
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

  const _KPIBox({
    required this.title,
    required this.number,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          Text(
            number,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: const Row(
        children: [
          SizedBox(width: 48), // avatar space
          Expanded(flex: 2, child: _TH("EMPLOYEE")),
          Expanded(child: _TH("CHECK-IN")),
          Expanded(child: _TH("CHECK-OUT")),
          Expanded(child: _TH("HOURS")),
          _TH("STATUS"),
        ],
      ),
    );
  }
}

class _TH extends StatelessWidget {
  final String text;
  const _TH(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          color: Colors.black45,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      );
}