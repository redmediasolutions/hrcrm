import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';

// =============================================================================
// ADD LOAN PAGE — lib/pages/payroll/add_loan.dart
// =============================================================================
class AddLoan extends StatefulWidget {
  final int? employeeId;
  const AddLoan({super.key, this.employeeId});

  @override
  State<AddLoan> createState() => _AddLoanState();
}

class _AddLoanState extends State<AddLoan> {
  final _amountCtrl      = TextEditingController();
  final _interestCtrl    = TextEditingController();
  final _employeeIdCtrl  = TextEditingController();

  String? _selectedReason;
  int     _durationMonths = 12;
  DateTime? _startDate;
  bool    _submitting = false;
  String? _errorMsg;

  final List<String> _reasons = [
    'Housing Advance',
    'Vehicle Loan',
    'Personal Advance',
    'Medical Emergency',
    'Education Support',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.employeeId != null) {
      _employeeIdCtrl.text = widget.employeeId.toString();
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _interestCtrl.dispose();
    _employeeIdCtrl.dispose();
    super.dispose();
  }

  String? _validate() {
    if (_employeeIdCtrl.text.trim().isEmpty)               return 'Employee ID is required.';
    if (int.tryParse(_employeeIdCtrl.text.trim()) == null) return 'Employee ID must be a number.';
    final amt = double.tryParse(_amountCtrl.text.trim());
    if (amt == null || amt <= 0)                           return 'Enter a valid loan amount.';
    if (_selectedReason == null)                           return 'Please select a loan reason.';
    if (_startDate == null)                                return 'Please select a start date.';
    return null;
  }

  Future<void> _submit() async {
    final err = _validate();
    if (err != null) { setState(() => _errorMsg = err); return; }

    setState(() { _submitting = true; _errorMsg = null; });
    try {
      await ApiService.addLoan(
        employeeId: int.parse(_employeeIdCtrl.text.trim()),
        amount: double.parse(_amountCtrl.text.trim()),
        date: DateFormat('yyyy-MM-dd').format(_startDate!),
        reason: _selectedReason,
      );
      if (mounted) context.pop(true);
    } catch (e) {
      setState(() { _errorMsg = e.toString(); _submitting = false; });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: Color(0xFF0C5D6B))),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Back + Title ─────────────────────────────────────────────────
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Loan Authorization',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: const Color(0xFF0C5D6B), fontWeight: FontWeight.w700)),
                      Text('Create and schedule a new employee loan entry.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ── Error banner ──────────────────────────────────────────────────
              if (_errorMsg != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.red.shade200)),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 18),
                      const SizedBox(width: 10),
                      Expanded(child: Text(_errorMsg!, style: const TextStyle(color: Colors.red, fontSize: 13))),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.close, size: 16, color: Colors.red),
                        onPressed: () => setState(() => _errorMsg = null),
                      ),
                    ],
                  ),
                ),

              // ── Employee ID ───────────────────────────────────────────────────
              _SectionCard(
                icon: Icons.person_outline,
                title: 'Employee',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('EMPLOYEE ID'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _employeeIdCtrl,
                      keyboardType: TextInputType.number,
                      enabled: widget.employeeId == null,
                      decoration: InputDecoration(
                        hintText: 'Enter employee ID',
                        hintStyle: const TextStyle(color: Colors.black45),
                        filled: true,
                        fillColor: widget.employeeId != null ? const Color(0xFFE8EEF0) : const Color(0xFFF0F0F0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        prefixIcon: const Icon(Icons.badge_outlined, size: 18, color: Colors.black45),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // ── Loan Specs ────────────────────────────────────────────────────
              _SectionCard(
                icon: Icons.edit,
                title: 'Loan Specifications',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Amount + Reason
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel('LOAN AMOUNT (₹)'),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _amountCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: InputDecoration(
                                  hintText: '0.00',
                                  hintStyle: const TextStyle(color: Colors.black45),
                                  filled: true,
                                  fillColor: const Color(0xFFF0F0F0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  prefixText: '₹ ',
                                  prefixStyle: const TextStyle(color: Color(0xFF0C5D6B), fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel('LOAN REASON'),
                              const SizedBox(height: 8),
                              Container(
                                height: 48,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(10)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedReason,
                                    isExpanded: true,
                                    hint: const Text('Select Reason', style: TextStyle(color: Colors.black45)),
                                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black45),
                                    items: _reasons.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                                    onChanged: (v) => setState(() => _selectedReason = v),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Duration + Date
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel('REPAYMENT DURATION'),
                              const SizedBox(height: 8),
                              Row(
                                children: [6, 12, 24].map((mo) {
                                  final sel = _durationMonths == mo;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: InkWell(
                                      onTap: () => setState(() => _durationMonths = mo),
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: sel ? const Color(0xFF0C5D6B) : const Color(0xFFEDEDED),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text('$mo mo',
                                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: sel ? Colors.white : Colors.black54)),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel('START DATE'),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: _pickDate,
                                child: Container(
                                  height: 44,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _startDate != null ? DateFormat('MM/dd/yyyy').format(_startDate!) : 'mm/dd/yyyy',
                                          style: TextStyle(color: _startDate != null ? Colors.black87 : Colors.black45),
                                        ),
                                      ),
                                      const Icon(Icons.calendar_today, size: 16, color: Colors.black45),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Interest (optional)
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel('INTEREST RATE (ANNUAL %)'),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _interestCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: InputDecoration(
                                  hintText: 'Optional',
                                  hintStyle: const TextStyle(color: Colors.black45),
                                  filled: true,
                                  fillColor: const Color(0xFFF0F0F0),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  suffixText: '%',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Actions ────────────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _submitting ? null : () => context.pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0C5D6B),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF0C5D6B).withValues(alpha: 0.6),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: _submitting
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Authorize & Add Loan', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// LOCAL HELPERS
// =============================================================================
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  const _SectionCard({required this.icon, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(color: const Color(0xFFE7F2F4), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, size: 16, color: const Color(0xFF0C5D6B)),
              ),
              const SizedBox(width: 10),
              Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(color: Colors.black45, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.6));
}