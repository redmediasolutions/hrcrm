import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../models/payroll_model.dart';
import '../../services/api_service.dart';
import 'payroll.dart'; // StatInfoCard, LoanHistoryTable, LoanHistoryItem
import 'package:red_hrcrm/component/header.dart';

// =============================================================================
// PAYROLL DETAILS PAGE — lib/pages/payroll/payroll_details.dart
//
// Router: GoRoute(path: '/payroll/details/:employeeId', ...)
// =============================================================================

/// ✅ Safely converts ANY MySQL value (String/int/double/null) → double
double _toDouble(dynamic v) =>
    double.tryParse(v?.toString() ?? '0') ?? 0.0;

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

class PayrollDetails extends StatefulWidget {
  final int employeeId;
  const PayrollDetails({super.key, required this.employeeId});

  @override
  State<PayrollDetails> createState() => _PayrollDetailsState();
}

class _PayrollDetailsState extends State<PayrollDetails> {
  PayrollModel? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await ApiService.getPayroll(widget.employeeId);
      setState(() { _data = data; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  String _fmtDate(String raw) {
    try {
      return DateFormat('MMM dd, yyyy').format(DateTime.parse(raw));
    } catch (_) {
      return raw;
    }
  }

  double get _repaymentPct {
    if (_data == null) return 0;
    final total = _data!.summary.totalLoans;
    if (total <= 0) return 1;
    return (_data!.summary.totalDeductions / total).clamp(0.0, 1.0);
  }

  // ── Build ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: const AppHeader(
        searchHint: "Search",
        searchWidth: 420,
        searchFillColor: Color(0xFFEFEFEF),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF0C5D6B)))
          : _error != null
              ? _buildError()
              : _buildBody(),
    );
  }

  Widget _buildError() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 48),
        const SizedBox(height: 12),
        Text(_error!, style: const TextStyle(color: Colors.red)),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _load,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0C5D6B), foregroundColor: Colors.white),
          child: const Text("Retry"),
        ),
      ],
    ),
  );

  Widget _buildBody() {
    final d = _data!;
    final pct = _repaymentPct;

    final historyItems = d.loans.map((loan) {
      final isClosed = d.summary.remaining <= 0;
      return LoanHistoryItem(
        date: _fmtDate(loan.date),
        reference: 'Ref: LN-${loan.id}',
        amount: _inr(loan.amount),
        reason: loan.reason ?? 'General Advance',
        status: isClosed ? 'Closed' : 'Active',
        statusColor: isClosed ? const Color(0xFF9E9E9E) : const Color(0xFF4C8C86),
      );
    }).toList();

    return RefreshIndicator(
      onRefresh: _load,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Back + Title ────────────────────────────────────────────────
              Row(
                children: [
                  InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.arrow_back_ios_new, size: 16),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    "Employee Loan Details",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF0C5D6B), fontSize: 28, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Profile + Balance ───────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile card
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 12, offset: Offset(0, 6))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Employee #${widget.employeeId}",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 20)),
                          const SizedBox(height: 6),
                          Text("ID: ${widget.employeeId}  •  Loan Account",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54)),
                          const SizedBox(height: 10),
                          // Progress bar
                          Text("${(pct * 100).toStringAsFixed(1)}% repaid",
                              style: const TextStyle(fontSize: 11, color: Colors.black45, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: pct,
                              minHeight: 6,
                              backgroundColor: const Color(0xFFEEEEEE),
                              valueColor: const AlwaysStoppedAnimation(Color(0xFF00A389)),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => _showAddDeductionDialog(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0C5D6B),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text("Add Deduction", style: TextStyle(fontWeight: FontWeight.w700)),
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton.icon(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF0C5D6B),
                                  side: const BorderSide(color: Color(0xFF0C5D6B)),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                icon: const Icon(Icons.upload_file, size: 18),
                                label: const Text("Export History", style: TextStyle(fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Balance card
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: d.summary.remaining > 0 ? const Color(0xFFFAD7D7) : const Color(0xFFDFF5EE),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "REMAINING BALANCE",
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: d.summary.remaining > 0 ? const Color(0xFFB04A4A) : const Color(0xFF1A7A5E),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _inr(d.summary.remaining),
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: d.summary.remaining > 0 ? const Color(0xFF9E1B1B) : const Color(0xFF1A7A5E),
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                d.summary.remaining > 0 ? Icons.info_outline : Icons.check_circle_outline,
                                size: 16,
                                color: d.summary.remaining > 0 ? const Color(0xFFB04A4A) : const Color(0xFF1A7A5E),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  d.summary.remaining > 0
                                      ? "Repayment is ${(pct * 100).toStringAsFixed(0)}% complete"
                                      : "Loan fully repaid",
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: d.summary.remaining > 0 ? const Color(0xFFB04A4A) : const Color(0xFF1A7A5E),
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Stat cards ──────────────────────────────────────────────────
              Row(
                children: [
                  Expanded(child: StatInfoCard(title: 'Total Loan Taken', value: _inr(d.summary.totalLoans), icon: Icons.account_balance, accentColor: const Color(0xFF0C5D6B), borderColor: const Color(0xFF0C5D6B))),
                  const SizedBox(width: 16),
                  Expanded(child: StatInfoCard(title: 'Total Deducted', value: _inr(d.summary.totalDeductions), icon: Icons.attach_money, accentColor: const Color(0xFF4C8C86), borderColor: const Color(0xFF4C8C86))),
                  const SizedBox(width: 16),
                  Expanded(child: StatInfoCard(title: 'Deduction Records', value: '${d.deductions.length}', icon: Icons.calendar_today, accentColor: const Color(0xFFF3A85B), borderColor: const Color(0xFFF3A85B))),
                ],
              ),
              const SizedBox(height: 20),

              // ── Loan History ────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 12, offset: Offset(0, 6))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Loans History',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                        const Spacer(),
                        Text('${historyItems.length} RECORDS',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.black45, letterSpacing: 0.6, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    LoanHistoryTable(items: historyItems),
                  ],
                ),
              ),

              // ── Deduction History ───────────────────────────────────────────
              if (d.deductions.isNotEmpty) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 12, offset: Offset(0, 6))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Deduction History',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                          const Spacer(),
                          Text('${d.deductions.length} RECORDS',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Colors.black45, letterSpacing: 0.6, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      LoanHistoryTable(
                        items: d.deductions.map((ded) => LoanHistoryItem(
                          date: _fmtDate(ded.date),
                          reference: ded.source != null ? 'Source: ${ded.source}' : null,
                          amount: _inr(ded.amount),
                          reason: ded.notes ?? 'Salary Deduction',
                          status: 'Deducted',
                          statusColor: const Color(0xFF4C8C86),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── Add Deduction Dialog ────────────────────────────────────────────────────
  void _showAddDeductionDialog(BuildContext context) {
    final amountCtrl = TextEditingController();
    final notesCtrl  = TextEditingController();
    final sourceCtrl = TextEditingController();
    DateTime selectedDate = DateTime.now();
    bool submitting = false;
    String? errorMsg;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add Deduction', style: TextStyle(fontWeight: FontWeight.w700)),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (errorMsg != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Text(errorMsg!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                _DialogField(label: 'AMOUNT (₹)', controller: amountCtrl, hint: '0.00', keyboardType: TextInputType.number),
                const SizedBox(height: 14),
                _DialogField(label: 'SOURCE', controller: sourceCtrl, hint: 'e.g. Payroll, Manual'),
                const SizedBox(height: 14),
                _DialogField(label: 'NOTES', controller: notesCtrl, hint: 'Optional notes'),
                const SizedBox(height: 14),
                // Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('DATE', style: TextStyle(color: Colors.black45, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.6)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final p = await showDatePicker(
                          context: ctx,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (p != null) setS(() => selectedDate = p);
                      },
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Expanded(child: Text(DateFormat('MM/dd/yyyy').format(selectedDate))),
                            const Icon(Icons.calendar_today, size: 16, color: Colors.black45),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: submitting ? null : () => ctx.pop(), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: submitting
                  ? null
                  : () async {
                      final amt = double.tryParse(amountCtrl.text);
                      if (amt == null || amt <= 0) {
                        setS(() => errorMsg = 'Enter a valid amount.');
                        return;
                      }
                      setS(() { submitting = true; errorMsg = null; });
                      try {
                        await ApiService.addDeduction(
                          employeeId: widget.employeeId,
                          amount: amt,
                          date: DateFormat('yyyy-MM-dd').format(selectedDate),
                          source: sourceCtrl.text.isNotEmpty ? sourceCtrl.text : null,
                          notes: notesCtrl.text.isNotEmpty ? notesCtrl.text : null,
                        );
                        if (ctx.mounted) ctx.pop();
                        _load();
                      } catch (e) {
                        setS(() { errorMsg = e.toString(); submitting = false; });
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C5D6B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: submitting
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Save Deduction', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dialog field helper ───────────────────────────────────────────────────────
class _DialogField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;

  const _DialogField({required this.label, required this.controller, required this.hint, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black45, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.6)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black38),
            filled: true,
            fillColor: const Color(0xFFF0F0F0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}
