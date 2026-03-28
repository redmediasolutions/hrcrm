import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:red_hrcrm/models/Singleemployeemodel.dart';
import 'package:red_hrcrm/models/contactmodel.dart';
import 'package:red_hrcrm/models/employment_model.dart';
import 'package:red_hrcrm/models/family_model.dart';
import 'package:red_hrcrm/models/personalmodel.dart';
import '../../services/api_service.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final int employeeId;

  const EmployeeDetailScreen({super.key, required this.employeeId});

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  SingleEmployeeModel? employee;
  bool loading = true;

  // 🔥 Inline Add States
  bool isAddingJob = false;
  bool isAddingFamily = false;

  // 🔥 Job Controllers
  late TextEditingController newCompanyCtrl = TextEditingController();
  late TextEditingController newPositionCtrl = TextEditingController();
  late TextEditingController newSalaryCtrl = TextEditingController();

  // 🔥 Family Controllers
  late TextEditingController newMemberNameCtrl = TextEditingController();
  late TextEditingController newRelationCtrl = TextEditingController();
  late TextEditingController newAgeCtrl = TextEditingController();

  PersonalModel? personal;
  ContactModel? contact;
  List<EmploymentModel> employments = [];
  List<FamilyModel> family = [];

  bool isPersonalEditing = false;
  bool isContactEditing = false;

  late TextEditingController nameCtrl, dobCtrl, genderCtrl;
  late TextEditingController emailCtrl, phoneCtrl, addressCtrl;

  final Color primaryTeal = const Color(0xFF0C5D6B);
  final Color bgGrey = const Color(0xFFF7F8FA);

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    try {
      final emp = await ApiService.getEmployeeFullById(widget.employeeId);
      final p = await ApiService.getPersonal(widget.employeeId);
      final c = await ApiService.getContact(widget.employeeId);
      final jobs = await ApiService.getEmployment(widget.employeeId);
      final fam = await ApiService.getFamily(widget.employeeId);

      if (!mounted) return;

      String cleanDob = p.dob ?? "";
      if (cleanDob.contains("T")) {
        cleanDob = cleanDob.split("T")[0];
      }

      nameCtrl = TextEditingController(text: p.fullName ?? "");
      dobCtrl = TextEditingController(text: cleanDob);
      genderCtrl = TextEditingController(text: p.gender ?? "");

      emailCtrl = TextEditingController(text: c.email ?? "");
      phoneCtrl = TextEditingController(text: c.phone ?? "");
      addressCtrl = TextEditingController(text: c.address ?? "");

      setState(() {
        employee = emp;
        personal = p;
        contact = c;
        employments = jobs;
        family = fam;
        loading = false;
      });
    } catch (e) {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading || employee == null) {
      return Scaffold(backgroundColor: bgGrey, body: const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text("Employee Profile: ${employee!.fullName}", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            _buildHeroHeader(),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildSectionCard(
                        title: "Personal Information",
                        icon: Icons.person_outline,
                        isEditing: isPersonalEditing,
                        onEdit: () => setState(() => isPersonalEditing = true),
                        onSave: () async {
                          await ApiService.savePersonal(widget.employeeId, {
                            "full_name": nameCtrl.text,
                            "dob": dobCtrl.text,
                            "gender": genderCtrl.text,
                          });
                          setState(() => isPersonalEditing = false);
                        },
                        children: [
                          _infoField("Full Name", nameCtrl, isPersonalEditing),
                          _infoField("Date of Birth", dobCtrl, isPersonalEditing),
                          _infoField("Gender", genderCtrl, isPersonalEditing),
                        ],
                      ),
                      _buildListSection<EmploymentModel>(
                        title: "Professional Details",
                        icon: Icons.badge_outlined,
                        items: employments,
                        onAdd: () => setState(() => isAddingJob = true),
                        itemBuilder: (job) => _buildDetailTile(job.employerName, job.positionHeld, "₹ ${job.salaryDrawn}"),
                        extraWidget: isAddingJob ? _buildInlineJobForm() : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildSectionCard(
                        title: "Contact Information",
                        icon: Icons.alternate_email,
                        isEditing: isContactEditing,
                        onEdit: () => setState(() => isContactEditing = true),
                        onSave: () async {
                          await ApiService.saveContact(widget.employeeId, {
                            "email": emailCtrl.text,
                            "phone": phoneCtrl.text,
                            "correspondence_address": addressCtrl.text,
                          });
                          setState(() => isContactEditing = false);
                        },
                        children: [
                          _infoField("Work Email", emailCtrl, isContactEditing, isFullWidth: true),
                          _infoField("Phone Number", phoneCtrl, isContactEditing, isFullWidth: true),
                          _infoField("Residential Address", addressCtrl, isContactEditing, isFullWidth: true),
                        ],
                      ),
                      _buildListSection<FamilyModel>(
                        title: "Family Details",
                        icon: Icons.family_restroom_outlined,
                        items: family,
                        onAdd: () => setState(() => isAddingFamily = true),
                        itemBuilder: (f) => _buildDetailTile(f.name, f.relation, "Age: ${f.age}"),
                        extraWidget: isAddingFamily ? _buildInlineFamilyForm() : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 NEW: Inline Job Form
  Widget _buildInlineJobForm() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _inlineTextField("Company Name", newCompanyCtrl)),
              const SizedBox(width: 12),
              Expanded(child: _inlineTextField("Position", newPositionCtrl)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _inlineTextField("Salary Drawn", newSalaryCtrl)),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.check_circle, color: Colors.green),
                onPressed: () async {
                  await ApiService.addEmployment(widget.employeeId, {
                    "employer_name": newCompanyCtrl.text,
                    "position_held": newPositionCtrl.text,
                    "salary_drawn": newSalaryCtrl.text,
                  });
                  newCompanyCtrl.clear(); newPositionCtrl.clear(); newSalaryCtrl.clear();
                  setState(() => isAddingJob = false);
                  fetch();
                },
              ),
              IconButton(
                icon: const Icon(Icons.cancel, color: Colors.red),
                onPressed: () => setState(() => isAddingJob = false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🔥 NEW: Inline Family Form
  Widget _buildInlineFamilyForm() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Expanded(child: _inlineTextField("Name", newMemberNameCtrl)),
          const SizedBox(width: 8),
          Expanded(child: _inlineTextField("Relation", newRelationCtrl)),
          const SizedBox(width: 8),
          SizedBox(width: 60, child: _inlineTextField("Age", newAgeCtrl)),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.green),
            onPressed: () async {
              await ApiService.addFamily(widget.employeeId, {
                "name": newMemberNameCtrl.text,
                "relation": newRelationCtrl.text,
                "age": int.tryParse(newAgeCtrl.text) ?? 0,
              });
              newMemberNameCtrl.clear(); newRelationCtrl.clear(); newAgeCtrl.clear();
              setState(() => isAddingFamily = false);
              fetch();
            },
          ),
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.red),
            onPressed: () => setState(() => isAddingFamily = false),
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

  Widget _buildHeroHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: primaryTeal.withOpacity(0.1),
            child: Text(employee!.fullName.isNotEmpty ? employee!.fullName[0] : "?", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryTeal)),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("ACTIVE EMPLOYEE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.teal, letterSpacing: 1.2)),
                Text(employee!.fullName, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                Text("${employee!.positionHeld ?? 'Staff Member'} • ${employee!.email}", style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: primaryTeal, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text("Action Menu", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required bool isEditing, required VoidCallback onEdit, required VoidCallback onSave, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [Icon(icon, size: 20, color: primaryTeal), const SizedBox(width: 12), Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
              isEditing 
                ? TextButton(onPressed: onSave, child: const Text("Save Changes", style: TextStyle(fontWeight: FontWeight.bold)))
                : OutlinedButton(onPressed: onEdit, style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.grey.shade300)), child: const Text("Edit", style: TextStyle(color: Colors.black))),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [Icon(icon, size: 20, color: primaryTeal), const SizedBox(width: 12), Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
              IconButton(onPressed: onAdd, icon: const Icon(Icons.add_circle_outline, color: Colors.blue)),
            ],
          ),
          const Divider(height: 40),
          ...items.map((item) => itemBuilder(item)),
          if (extraWidget != null) extraWidget,
        ],
      ),
    );
  }

  Widget _infoField(String label, TextEditingController ctrl, bool isEditing, {bool isFullWidth = false}) {
    return SizedBox(
      width: isFullWidth ? double.infinity : 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey.shade500, letterSpacing: 1.1)),
          const SizedBox(height: 8),
          isEditing 
            ? TextField(controller: ctrl, decoration: InputDecoration(isDense: true, contentPadding: const EdgeInsets.symmetric(vertical: 8), border: UnderlineInputBorder(borderSide: BorderSide(color: primaryTeal))))
            : Text(ctrl.text.isEmpty ? "—" : ctrl.text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildDetailTile(String? primary, String? secondary, String? tertiary) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bgGrey, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(primary ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(secondary ?? "Not specified", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            ],
          ),
          Text(tertiary ?? "", style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.teal)),
        ],
      ),
    );
  }
}