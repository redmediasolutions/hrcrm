import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/payroll_model.dart';
import '../../services/api_service.dart';
import 'package:red_hrcrm/component/header.dart';

// =============================================================================
// MAIN PAYROLL PAGE — lib/pages/payroll/payroll.dart
// =============================================================================

/// Indian Rupee formatting  e.g.  ₹1,00,000.00
String _inr(double v) {
  final parts = v.toStringAsFixed(2).split('.');
  final intPart = parts[0];
  final dec = parts[1];
  if (intPart.length <= 3) return '₹$intPart.$dec';
  final last3 = intPart.substring(intPart.length - 3);
  final rest = intPart.substring(0, intPart.length - 3);
  final formatted =
      rest.replaceAllMapped(RegExp(r'(\d)(?=(\d{2})+$)'), (m) => '${m[1]},');
  return '₹$formatted,$last3.$dec';
}

class Payroll extends StatefulWidget {
  const Payroll({super.key});

  @override
  State<Payroll> createState() => _PayrollState();
}

class _PayrollState extends State<Payroll> {
  // ✅ Typed list — no more raw Map casts
  List<PayrollDashboardRow> _rows = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() { _loading = true; _error = null; });
    try {
      // ApiService returns List<Map<String,dynamic>> — parse into typed rows
      final raw = await ApiService.getPayrollDashboard();
      setState(() {
        _rows = raw.map((m) => PayrollDashboardRow.fromJson(m)).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  double get _portfolioOutstanding =>
      _rows.fold(0.0, (sum, r) => sum + r.remaining);

  int get _activeCount =>
      _rows.where((r) => r.status == 'Active').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: const AppHeader(
        searchHint: "Search employee financial records...",
        searchWidth: 420,
        searchFillColor: Color(0xFFF1F3F6),
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboard,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ───────────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Payroll & Financial Assistance",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Manage employee financial assistance, track repayment schedules, and oversee automated payroll deductions.",
                            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final added = await context.push<bool>('/payroll/add-loan');
                        if (added == true) _loadDashboard();
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text("Add Loan Assistance"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004D57),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // ── Portfolio stats ──────────────────────────────────────────
                if (_loading)
                  const _LoadingCard()
                else if (_error != null)
                  _ErrorCard(message: _error!, onRetry: _loadDashboard)
                else
                  _PortfolioOverview(
                    outstanding: _portfolioOutstanding,
                    activeCount: _activeCount,
                  ),

                const SizedBox(height: 30),

                // ── Loan table ───────────────────────────────────────────────
                const Text(
                  "Active Loan Portfolio",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                if (_loading)
                  const _LoadingCard(height: 200)
                else if (_error != null)
                  const SizedBox.shrink()
                else
                  _LoanTable(rows: _rows),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// PORTFOLIO OVERVIEW
// =============================================================================
class _PortfolioOverview extends StatelessWidget {
  final double outstanding;
  final int activeCount;
  const _PortfolioOverview({required this.outstanding, required this.activeCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _stat("PORTFOLIO OUTSTANDING", _inr(outstanding), badge: "LIVE"),
            const VerticalDivider(color: Colors.black12, thickness: 1, indent: 5, endIndent: 5),
            _stat("ACTIVE DEDUCTIONS", "$activeCount", subtext: "Employees with active loans"),
            const VerticalDivider(color: Colors.black12, thickness: 1, indent: 5, endIndent: 5),
            _stat("COLLECTION RATE", "99.8%", valueColor: const Color(0xFF00A389), subtext: "Auto-recovery enabled"),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value, {String? badge, String? subtext, Color? valueColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: const TextStyle(color: Colors.black45, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
            const SizedBox(height: 12),
            Text(value, style: TextStyle(color: valueColor ?? const Color(0xFF00334E), fontSize: 26, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFE6F5F3), borderRadius: BorderRadius.circular(6)),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 6, color: Color(0xFF00A389)),
                    SizedBox(width: 4),
                    Text("LIVE", style: TextStyle(color: Color(0xFF00A389), fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            if (subtext != null)
              Text(subtext, style: const TextStyle(color: Colors.black38, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// LOAN TABLE  — uses typed PayrollDashboardRow, zero Map casts
// =============================================================================
class _LoanTable extends StatelessWidget {
  final List<PayrollDashboardRow> rows;
  const _LoanTable({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: const Row(
              children: [
                Expanded(flex: 3, child: _TH("EMPLOYEE NAME")),
                Expanded(flex: 2, child: _TH("TOTAL LOAN")),
                Expanded(flex: 2, child: _TH("DEDUCTED")),
                Expanded(flex: 2, child: _TH("OUTSTANDING")),
                Expanded(flex: 1, child: _TH("STATUS")),
                Expanded(flex: 1, child: _TH("ACTION", align: TextAlign.right)),
              ],
            ),
          ),

          // ── Rows ─────────────────────────────────────────────────────────
          if (rows.isEmpty)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.account_balance_wallet_outlined, size: 40, color: Colors.black26),
                    SizedBox(height: 12),
                    Text("No loan records found.", style: TextStyle(color: Colors.black38)),
                  ],
                ),
              ),
            )
          else
            ...rows.asMap().entries.map((e) {
              final i = e.key;
              final r = e.value;                     // ✅ typed — no casts
              final isLast   = i == rows.length - 1;
              final isActive = r.status == 'Active';

              return InkWell(
                onTap: isActive
                    ? () => context.push('/payroll/details/${r.id}')
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
                  ),
                  child: Row(
                    children: [
                      // Name + ID
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: const Color(0xFFE7F2F4),
                              child: Text(
                                r.fullName.isNotEmpty ? r.fullName[0].toUpperCase() : '?',
                                style: const TextStyle(color: Color(0xFF0C5D6B), fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.fullName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                                Text('ID: ${r.id}', style: const TextStyle(color: Colors.black45, fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Total Loan
                      Expanded(flex: 2, child: Text(_inr(r.totalLoans), style: const TextStyle(fontWeight: FontWeight.w600))),
                      // Deducted
                      Expanded(flex: 2, child: Text(_inr(r.totalDeductions), style: const TextStyle(color: Colors.black54))),
                      // Outstanding
                      Expanded(
                        flex: 2,
                        child: Text(
                          _inr(r.remaining),
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: r.remaining <= 0 ? Colors.black26 : const Color(0xFF0C5D6B),
                          ),
                        ),
                      ),
                      // Status badge
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isActive ? const Color(0xFFE6F7F4) : const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            r.status,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isActive ? const Color(0xFF00A389) : Colors.black54,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                        // Action
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: isActive
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0C5D6B),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(Icons.visibility, size: 16, color: Colors.white),
                                        SizedBox(width: 8),
                                        Text(
                                          'View',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Text(
                                    'Archive',
                                    style: TextStyle(
                                      color: Colors.black26,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}

// =============================================================================
// SHARED WIDGETS  (StatInfoCard + LoanHistoryTable imported by details page)
// =============================================================================
class _TH extends StatelessWidget {
  final String text;
  final TextAlign align;
  const _TH(this.text, {this.align = TextAlign.left});

  @override
  Widget build(BuildContext context) => Text(text,
      textAlign: align,
      style: const TextStyle(color: Colors.black45, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8));
}

class _LoadingCard extends StatelessWidget {
  final double height;
  const _LoadingCard({this.height = 120});

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
    child: const Center(child: CircularProgressIndicator(color: Color(0xFF0C5D6B))),
  );
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.red.shade100),
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline, color: Colors.red),
        const SizedBox(width: 12),
        Expanded(child: Text(message, style: const TextStyle(color: Colors.red))),
        TextButton(onPressed: onRetry, child: const Text("Retry")),
      ],
    ),
  );
}

// ─── StatInfoCard (used in payroll_details.dart) ─────────────────────────────
class StatInfoCard extends StatelessWidget {
  const StatInfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
    required Color borderColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 10, offset: Offset(0, 4))],
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600, fontSize: 11)),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18)),
            ],
          ),
        ),
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: accentColor, size: 20),
        ),
      ],
    ),
  );
}

// ─── LoanHistoryTable (used in payroll_details.dart) ─────────────────────────
class LoanHistoryTable extends StatelessWidget {
  const LoanHistoryTable({super.key, required this.items});
  final List<LoanHistoryItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text("No history.", style: TextStyle(color: Colors.black38))),
      );
    }
    return Column(
      children: [
        const _LoanHistoryHeader(),
        const SizedBox(height: 10),
        ...items.map((item) => _LoanHistoryRow(item: item)),
      ],
    );
  }
}

class LoanHistoryItem {
  final String date;
  final String amount;
  final String reason;
  final String status;
  final Color statusColor;
  final String? reference;

  LoanHistoryItem({
    required this.date,
    required this.amount,
    required this.reason,
    required this.status,
    required this.statusColor,
    this.reference,
  });
}

class _LoanHistoryHeader extends StatelessWidget {
  const _LoanHistoryHeader();
  @override
  Widget build(BuildContext context) => const Row(
    children: [
      Expanded(flex: 2, child: _HistoryHeaderCell('DATE')),
      Expanded(flex: 2, child: _HistoryHeaderCell('AMOUNT')),
      Expanded(flex: 3, child: _HistoryHeaderCell('REASON')),
      Expanded(flex: 1, child: _HistoryHeaderCell('STATUS')),
    ],
  );
}

class _HistoryHeaderCell extends StatelessWidget {
  const _HistoryHeaderCell(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Text(label,
      style: const TextStyle(color: Colors.black45, fontSize: 10, fontWeight: FontWeight.w800));
}

class _LoanHistoryRow extends StatelessWidget {
  const _LoanHistoryRow({required this.item});
  final LoanHistoryItem item;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF1F1F1)))),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.date, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              if (item.reference != null)
                Text(item.reference!, style: const TextStyle(color: Colors.black45, fontSize: 11)),
            ],
          ),
        ),
        Expanded(flex: 2, child: Text(item.amount, style: const TextStyle(fontWeight: FontWeight.w700))),
        Expanded(flex: 3, child: Text(item.reason, style: const TextStyle(color: Colors.black54, fontSize: 13))),
        Expanded(
          flex: 1,
          child: UnconstrainedBox(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: item.statusColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
              child: Text(item.status, style: TextStyle(color: item.statusColor, fontWeight: FontWeight.w700, fontSize: 10)),
            ),
          ),
        ),
      ],
    ),
  );
}
