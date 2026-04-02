// =============================================================================
// PAYROLL MODEL — lib/models/payroll_model.dart
//
// ✅ Every numeric field uses double.tryParse(v?.toString()) so it never
//    crashes when MySQL returns decimals as Strings like "0.00".
// =============================================================================

/// Safe helper — converts String / int / double / null → double
double _d(dynamic v) => double.tryParse(v?.toString() ?? '0') ?? 0.0;

/// Safe helper — converts anything → int
int _i(dynamic v) => int.tryParse(v?.toString() ?? '0') ?? 0;

// ─────────────────────────────────────────────────────────────────────────────
// LOAN MODEL  (maps one row from emp_loans)
// ─────────────────────────────────────────────────────────────────────────────
class LoanModel {
  final int id;
  final double amount;
  final String date;
  final String? reason;

  LoanModel({
    required this.id,
    required this.amount,
    required this.date,
    this.reason,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: _i(json['id']),
      amount: _d(json['amount']),   // ✅ safe — handles "1500.00" string
      date: json['date']?.toString() ?? '',
      reason: json['reason']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'date': date,
    'reason': reason,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// DEDUCTION MODEL  (maps one row from emp_deductions)
// ─────────────────────────────────────────────────────────────────────────────
class DeductionModel {
  final int id;
  final double amount;
  final String date;
  final String? source;
  final String? notes;

  DeductionModel({
    required this.id,
    required this.amount,
    required this.date,
    this.source,
    this.notes,
  });

  factory DeductionModel.fromJson(Map<String, dynamic> json) {
    return DeductionModel(
      id: _i(json['id']),
      amount: _d(json['amount']),   // ✅ safe
      date: json['date']?.toString() ?? '',
      source: json['source']?.toString(),
      notes: json['notes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'date': date,
    'source': source,
    'notes': notes,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// PAYROLL SUMMARY  (the `summary` object in /api/payroll/:id response)
// ─────────────────────────────────────────────────────────────────────────────
class PayrollSummary {
  final double totalLoans;
  final double totalDeductions;
  final double remaining;

  PayrollSummary({
    required this.totalLoans,
    required this.totalDeductions,
    required this.remaining,
  });

  factory PayrollSummary.fromJson(Map<String, dynamic> json) {
    return PayrollSummary(
      totalLoans:      _d(json['totalLoans']),       // ✅ safe
      totalDeductions: _d(json['totalDeductions']),  // ✅ safe
      remaining:       _d(json['remaining']),         // ✅ safe
    );
  }

  Map<String, dynamic> toJson() => {
    'totalLoans': totalLoans,
    'totalDeductions': totalDeductions,
    'remaining': remaining,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// PAYROLL MODEL  (full response from /api/payroll/:id)
// ─────────────────────────────────────────────────────────────────────────────
class PayrollModel {
  final List<LoanModel> loans;
  final List<DeductionModel> deductions;
  final PayrollSummary summary;

  PayrollModel({
    required this.loans,
    required this.deductions,
    required this.summary,
  });

  factory PayrollModel.fromJson(Map<String, dynamic> json) {
    return PayrollModel(
      loans: ((json['loans'] as List?) ?? [])
          .map((e) => LoanModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      deductions: ((json['deductions'] as List?) ?? [])
          .map((e) => DeductionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: PayrollSummary.fromJson(
          json['summary'] as Map<String, dynamic>? ?? {}),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DASHBOARD ROW  (one item from /api/payroll list response)
//
// The backend returns a plain list of objects — not wrapped models.
// We parse them here so payroll.dart can use typed objects instead of
// raw Map<String,dynamic> with unsafe casts.
// ─────────────────────────────────────────────────────────────────────────────
class PayrollDashboardRow {
  final int id;
  final String fullName;
  final double totalLoans;
  final double totalDeductions;
  final double remaining;
  final String status;

  PayrollDashboardRow({
    required this.id,
    required this.fullName,
    required this.totalLoans,
    required this.totalDeductions,
    required this.remaining,
    required this.status,
  });

  factory PayrollDashboardRow.fromJson(Map<String, dynamic> json) {
    final totalLoans      = _d(json['total_loans']);
    final totalDeductions = _d(json['total_deductions']);
    // Recalculate remaining safely in case backend sends wrong value
    final remaining       = _d(json['remaining'] ?? (totalLoans - totalDeductions));
    final status          = json['status']?.toString() ?? (remaining > 0 ? 'Active' : 'Cleared');

    return PayrollDashboardRow(
      id:               _i(json['id']),
      fullName:         json['full_name']?.toString() ?? '—',
      totalLoans:       totalLoans,
      totalDeductions:  totalDeductions,
      remaining:        remaining,
      status:           status,
    );
  }
}