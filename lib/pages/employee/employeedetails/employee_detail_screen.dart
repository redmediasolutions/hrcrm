import 'package:flutter/material.dart';
import 'package:red_hrcrm/models/employment_model.dart';
import 'package:red_hrcrm/pages/attendance/attendance.dart';
import 'package:go_router/go_router.dart';
import 'employee_detail_controller.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final int employeeId;

  const EmployeeDetailScreen({super.key, required this.employeeId});

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  late EmployeeDetailController _ctrl;

  final Color primaryTeal = const Color(0xFF0C5D6B);
  final Color bgGrey = const Color(0xFFF7F8FA);

  @override
  void initState() {
    super.initState();
    _ctrl = EmployeeDetailController(
      employeeId: widget.employeeId,
      context: context,
    );
    _ctrl.addListener(() => setState(() {}));
    _ctrl.fetch();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_ctrl.loading || _ctrl.employee == null) {
      return Scaffold(
        backgroundColor: bgGrey,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: bgGrey,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/home');
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildHeroHeader(),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildPersonalSection(),
                      _buildFamilySection(),
                      _buildContactSection(),
                      _buildRemunerationSection(),
                      _buildEmploymentSection(),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            _buildOfficeUseSection(),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // SECTION BUILDERS
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildPersonalSection() {
    return _buildSectionCard(
      title: "Personal Information",
      icon: Icons.person_outline,
      isEditing: _ctrl.isPersonalEditing,
      onEdit: () => setState(() => _ctrl.isPersonalEditing = true),
      onSave: _ctrl.savePersonal,
      children: [
        _dateField("Date of Birth", _ctrl.dobCtrl, _ctrl.isPersonalEditing),
        _infoField(
          "Mother Tongue",
          _ctrl.motherTongueCtrl,
          _ctrl.isPersonalEditing,
        ),
        _infoField(
          "Blood Group",
          _ctrl.bloodGroupCtrl,
          _ctrl.isPersonalEditing,
        ),
        _infoField(
          "Marital Status",
          _ctrl.maritalStatusCtrl,
          _ctrl.isPersonalEditing,
        ),
        _infoField(
          "Spouse Name",
          _ctrl.spouseNameCtrl,
          _ctrl.isPersonalEditing,
        ),
        _infoField(
          "Aadhaar No",
          _ctrl.aadhaarCtrl,
          _ctrl.isPersonalEditing,
          isFullWidth: true,
        ),
        _infoField(
          "PAN No",
          _ctrl.panCtrl,
          _ctrl.isPersonalEditing,
          isFullWidth: true,
        ),
        _infoField(
          "Disability Info",
          _ctrl.disabilityCtrl,
          _ctrl.isPersonalEditing,
          isFullWidth: true,
        ),
      ],
    );
  }

  Widget _buildFamilySection() {
    return _buildSectionCard(
      title: "Family Details",
      icon: Icons.family_restroom_outlined,
      isEditing: _ctrl.isFamilyEditing,
      onEdit: () => setState(() => _ctrl.isFamilyEditing = true),
      onSave: _ctrl.saveFamily,
      children: [
        _infoField("Father Name", _ctrl.fatherNameCtrl, _ctrl.isFamilyEditing),
        _infoField(
          "Father Contact",
          _ctrl.fatherContactCtrl,
          _ctrl.isFamilyEditing,
        ),
        _infoField("Mother Name", _ctrl.motherNameCtrl, _ctrl.isFamilyEditing),
        _infoField(
          "Mother Contact",
          _ctrl.motherContactCtrl,
          _ctrl.isFamilyEditing,
        ),
        _infoField(
          "Spouse Name",
          _ctrl.spouseNameFamilyCtrl,
          _ctrl.isFamilyEditing,
        ),
        _infoField(
          "Spouse Contact",
          _ctrl.spouseContactCtrl,
          _ctrl.isFamilyEditing,
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return _buildSectionCard(
      title: "Contact Information",
      icon: Icons.alternate_email,
      isEditing: _ctrl.isContactEditing,
      onEdit: () => setState(() => _ctrl.isContactEditing = true),
      onSave: _ctrl.saveContact,
      children: [
        _infoField(
          "Work Email",
          _ctrl.emailCtrl,
          _ctrl.isContactEditing,
          isFullWidth: true,
        ),
        _infoField(
          "Phone Number",
          _ctrl.phoneCtrl,
          _ctrl.isContactEditing,
          isFullWidth: true,
        ),
        _infoField(
          "Residential Address",
          _ctrl.addressCtrl,
          _ctrl.isContactEditing,
          isFullWidth: true,
        ),
      ],
    );
  }

  Widget _buildRemunerationSection() {
    return _buildSectionCard(
      title: "Remuneration Breakdown",
      icon: Icons.account_balance_wallet_outlined,
      isEditing: _ctrl.isRemunerationEditing,
      onEdit: () => setState(() => _ctrl.isRemunerationEditing = true),
      onSave: _ctrl.saveRemuneration,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _subHeader("EARNINGS"),
                    _moneyField(
                      "Basic Pay",
                      _ctrl.basicCtrl,
                      _ctrl.isRemunerationEditing,
                    ),
                    _moneyField(
                      "HRA",
                      _ctrl.hraCtrl,
                      _ctrl.isRemunerationEditing,
                    ),
                    _moneyField(
                      "Overtime",
                      _ctrl.overtimeCtrl,
                      _ctrl.isRemunerationEditing,
                    ),
                    _moneyField(
                      "Bonus",
                      _ctrl.bonusCtrl,
                      _ctrl.isRemunerationEditing,
                    ),
                  ],
                ),
              ),
              Container(
                width: 2,
                height: 200,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                color: Colors.grey.shade100,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _subHeader("DEDUCTIONS"),
                    _moneyField(
                      "Loans",
                      _ctrl.loansCtrl,
                      _ctrl.isRemunerationEditing,
                      isDeduction: true,
                    ),
                    _moneyField(
                      "Advance Pay",
                      _ctrl.advanceCtrl,
                      _ctrl.isRemunerationEditing,
                      isDeduction: true,
                    ),
                    _moneyField(
                      "LOP Days",
                      _ctrl.lopCtrl,
                      _ctrl.isRemunerationEditing,
                      isDeduction: true,
                    ),
                    _moneyField(
                      "PF Contribution",
                      _ctrl.pfCtrl,
                      _ctrl.isRemunerationEditing,
                      isDeduction: true,
                    ),
                    _moneyField(
                      "ESI",
                      _ctrl.esiCtrl,
                      _ctrl.isRemunerationEditing,
                      isDeduction: true,
                    ),
                    _moneyField(
                      "Professional Tax",
                      _ctrl.taxCtrl,
                      _ctrl.isRemunerationEditing,
                      isDeduction: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        _buildSummaryFooter(),
      ],
    );
  }

  Widget _buildEmploymentSection() {
    return _buildListSection<EmploymentModel>(
      title: "Previous Employment Details",
      icon: Icons.badge_outlined,
      items: _ctrl.employments,
      onAdd: () => setState(() => _ctrl.isAddingJob = true),
      itemBuilder: (job) => _buildDetailTile(
        job.employerName,
        job.positionHeld,
        "₹ ${job.salaryDrawn}",
      ),
      extraWidget: _ctrl.isAddingJob ? _buildInlineJobForm() : null,
    );
  }

  /// Office Use — full-width card placed at the bottom of the scroll view.
  Widget _buildOfficeUseSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Header ──────────────────────────────────────────────────
          Row(
            children: [
              Icon(
                Icons.admin_panel_settings_outlined,
                size: 20,
                color: primaryTeal,
              ),
              const SizedBox(width: 12),
              const Text(
                "For Office Use Only",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 40),

          // ── Dates — three chips in one row ──────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _officeDateTile(
                  "Received Date",
                  _ctrl.receivedDate,
                  () => _ctrl.pickDate(context, (d) => _ctrl.receivedDate = d),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _officeDateTile(
                  "Checked Date",
                  _ctrl.checkedDate,
                  () => _ctrl.pickDate(context, (d) => _ctrl.checkedDate = d),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _officeDateTile(
                  "Date of Joining",
                  _ctrl.joiningDate,
                  () => _ctrl.pickDate(context, (d) => _ctrl.joiningDate = d),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ── Checklist ───────────────────────────────────────────────────────
          Text(
            "Checklist",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade500,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // Using Wrap so items reflow on narrow screens instead of overflowing
          Wrap(
            spacing: 0,
            runSpacing: 0,
            children: [
              _checkItem(
                "PAN Card",
                _ctrl.pan,
                (v) => setState(() => _ctrl.pan = v!),
              ),
              _checkItem(
                "Aadhaar",
                _ctrl.aadhaar,
                (v) => setState(() => _ctrl.aadhaar = v!),
              ),
              _checkItem(
                "Experience Certificate",
                _ctrl.experience,
                (v) => setState(() => _ctrl.experience = v!),
              ),
              _checkItem(
                "Salary Proof",
                _ctrl.salary,
                (v) => setState(() => _ctrl.salary = v!),
              ),
              _checkItem(
                "Educational Certificates",
                _ctrl.education,
                (v) => setState(() => _ctrl.education = v!),
              ),
              _checkItem(
                "Bank Passbook",
                _ctrl.bank,
                (v) => setState(() => _ctrl.bank = v!),
              ),
              _checkItem(
                "Recommendation Letter",
                _ctrl.recommendation,
                (v) => setState(() => _ctrl.recommendation = v!),
              ),
              _checkItem(
                "Medical Certificate",
                _ctrl.medical,
                (v) => setState(() => _ctrl.medical = v!),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ── Approval + Employee ID — side by side ───────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HR Sign / Approval radio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "HR Sign / Approval",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade500,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            value: true,
                            groupValue: _ctrl.approved,
                            onChanged: (v) =>
                                setState(() => _ctrl.approved = true),
                            title: const Text("Approved"),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            value: false,
                            groupValue: _ctrl.approved,
                            onChanged: (v) =>
                                setState(() => _ctrl.approved = false),
                            title: const Text("Not Approved"),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 32),

              // Employee ID field
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Employee ID Allotted",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade500,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _ctrl.empIdNumberCtrl,
                      decoration: const InputDecoration(
                        hintText: "e.g. EMP-0042",
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ── Save Button ─────────────────────────────────────────────────────
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _ctrl.isOfficeSaving ? null : _ctrl.saveOfficeUse,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryTeal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _ctrl.isOfficeSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Save Office Section",
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // REUSABLE CARD SHELLS
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required bool isEditing,
    required VoidCallback onEdit,
    required Future<void> Function() onSave,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: primaryTeal),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              isEditing
                  ? TextButton(
                      onPressed: () async => await onSave(),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  : OutlinedButton(
                      onPressed: onEdit,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: const Text(
                        "Edit",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
            ],
          ),
          const Divider(height: 40),
          Wrap(spacing: 32, runSpacing: 24, children: children),
        ],
      ),
    );
  }

  Widget _buildListSection<T>({
    required String title,
    required IconData icon,
    required List<T> items,
    required VoidCallback onAdd,
    required Widget Function(T) itemBuilder,
    Widget? extraWidget,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: primaryTeal),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: onAdd,
                icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
              ),
            ],
          ),
          const Divider(height: 40),
          ...items.map(itemBuilder),
          ?extraWidget,
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // HERO HEADER
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildHeroHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: primaryTeal.withValues(alpha: 0.1),
            child: Text(
              _ctrl.employee!.fullName.isNotEmpty
                  ? _ctrl.employee!.fullName[0]
                  : "?",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: primaryTeal,
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "ACTIVE EMPLOYEE",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.teal,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  _ctrl.employee!.fullName,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  "${_ctrl.employee!.positionHeld ?? 'Staff Member'} • ${_ctrl.employee!.email}",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),


          //this button is used to navigate to the attendance page of the employee whose details are being viewed
          FittedBox(
            child: ElevatedButton(
              onPressed: () {
                if (_ctrl.employee?.id != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Attendance(targetEmployeeId: _ctrl.employee!.id),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Employee ID not found")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryTeal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "View Attendance",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // INLINE JOB FORM
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildInlineJobForm() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _inlineTextField("Company Name", _ctrl.newCompanyCtrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _inlineTextField("Position", _ctrl.newPositionCtrl),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _inlineTextField("Salary Drawn", _ctrl.newSalaryCtrl),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.check_circle, color: Colors.green),
                onPressed: () async => await _ctrl.addEmployment(),
              ),
              IconButton(
                icon: const Icon(Icons.cancel, color: Colors.red),
                onPressed: () => setState(() => _ctrl.isAddingJob = false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // REMUNERATION HELPERS
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildSummaryFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: bgGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem("Total Earnings", _ctrl.totalEarnings, Colors.teal),
          Text(
            "-",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w200,
              color: Colors.grey.shade400,
            ),
          ),
          _summaryItem("Total Deductions", _ctrl.totalDeductions, Colors.red),
          Text(
            "=",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w200,
              color: Colors.grey.shade400,
            ),
          ),
          _summaryItem(
            "NET SALARY",
            _ctrl.netSalary,
            Colors.teal,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(
    String label,
    double value,
    Color color, {
    bool isBold = false,
  }) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Colors.grey.shade500,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "₹ ${value.toStringAsFixed(0)}",
          style: TextStyle(
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            color: isBold ? primaryTeal : color.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // OFFICE USE HELPERS
  // ════════════════════════════════════════════════════════════════════════════

  Widget _officeDateTile(String label, DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _ctrl.formatDate(date),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: date == null ? Colors.grey : primaryTeal,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.calendar_today, size: 16, color: primaryTeal),
          ],
        ),
      ),
    );
  }

  Widget _checkItem(String label, bool value, ValueChanged<bool?> onChanged) {
    return SizedBox(
      width: 220,
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Text(label, style: const TextStyle(fontSize: 13)),
        dense: true,
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // SHARED FIELD WIDGETS
  // ════════════════════════════════════════════════════════════════════════════

  Widget _subHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Colors.grey,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _moneyField(
    String label,
    TextEditingController ctrl,
    bool isEditing, {
    bool isDeduction = false,
  }) {
    final val = ctrl.text.isEmpty ? "0" : ctrl.text;
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          isEditing
              ? SizedBox(
                  width: 120,
                  child: TextField(
                    controller: ctrl,
                    textAlign: TextAlign.right,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      prefixText: "₹ ",
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryTeal.withValues(alpha: 0.5),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: primaryTeal, width: 2),
                      ),
                    ),
                  ),
                )
              : Text(
                  "₹ $val",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDeduction
                        ? Colors.red.shade900
                        : Colors.teal.shade900,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _infoField(
    String label,
    TextEditingController ctrl,
    bool isEditing, {
    bool isFullWidth = false,
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade500,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          isEditing
              ? TextField(
                  controller: ctrl,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryTeal),
                    ),
                  ),
                )
              : Text(
                  ctrl.text.isEmpty ? "—" : ctrl.text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _dateField(String label, TextEditingController ctrl, bool isEditing) {
    String formatted = ctrl.text;
    if (ctrl.text.isNotEmpty) {
      try {
        final d = DateTime.parse(ctrl.text);
        formatted =
            "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
      } catch (_) {}
    }

    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade500,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          isEditing
              ? GestureDetector(
                  onTap: () async {
                    DateTime initial = DateTime.now();
                    try {
                      if (ctrl.text.isNotEmpty) {
                        initial = DateTime.parse(ctrl.text);
                      }
                    } catch (_) {}
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: initial,
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      ctrl.text =
                          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                      setState(() {});
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: ctrl,
                      decoration: InputDecoration(
                        hintText: "Select date",
                        suffixIcon: const Icon(Icons.calendar_today, size: 16),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryTeal),
                        ),
                      ),
                    ),
                  ),
                )
              : Text(
                  ctrl.text.isEmpty ? "—" : formatted,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _inlineTextField(String hint, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.all(10),
      ),
    );
  }

  Widget _buildDetailTile(
    String? primary,
    String? secondary,
    String? tertiary,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  primary ?? "Unknown",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  secondary ?? "Not specified",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            tertiary ?? "",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }
}
