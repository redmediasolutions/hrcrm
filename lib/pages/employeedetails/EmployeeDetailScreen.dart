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

  // PERSONAL Controllers
  late TextEditingController dobCtrl;
  late TextEditingController motherTongueCtrl;
  late TextEditingController bloodGroupCtrl;
  late TextEditingController maritalStatusCtrl;
  late TextEditingController spouseNameCtrl;
  late TextEditingController aadhaarCtrl;
  late TextEditingController panCtrl;
  late TextEditingController disabilityCtrl;

  // 🔥 Job Controllers
  late TextEditingController newCompanyCtrl = TextEditingController();
  late TextEditingController newPositionCtrl = TextEditingController();
  late TextEditingController newSalaryCtrl = TextEditingController();

  // 🔥 Family Controllers
  late TextEditingController fatherNameCtrl;
  late TextEditingController fatherContactCtrl;
  late TextEditingController motherNameCtrl;
  late TextEditingController motherContactCtrl;
  late TextEditingController spouseNameFamilyCtrl;
  late TextEditingController spouseContactCtrl;

  bool isFamilyEditing = false;

  PersonalModel? personal;
  ContactModel? contact;
  List<EmploymentModel> employments = [];
  FamilyModel? familyDetails;

  bool isPersonalEditing = false;
  bool isContactEditing = false;

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

      // PERSONAL CONTOLLER
      dobCtrl = TextEditingController(text: p.dob ?? "");
      motherTongueCtrl = TextEditingController(text: p.motherTongue ?? "");
      bloodGroupCtrl = TextEditingController(text: p.bloodGroup ?? "");
      maritalStatusCtrl = TextEditingController(text: p.maritalStatus ?? "");
      spouseNameCtrl = TextEditingController(text: p.spouseName ?? "");
      aadhaarCtrl = TextEditingController(text: p.aadhaarNo ?? "");
      panCtrl = TextEditingController(text: p.panNo ?? "");
      disabilityCtrl = TextEditingController(text: p.disabilityInfo ?? "");

      // FAMILY
      // FAMILY
      familyDetails = fam;

      fatherNameCtrl = TextEditingController(
        text: familyDetails?.fatherName ?? "",
      );
      fatherContactCtrl = TextEditingController(
        text: familyDetails?.fatherContact ?? "",
      );

      motherNameCtrl = TextEditingController(
        text: familyDetails?.motherName ?? "",
      );
      motherContactCtrl = TextEditingController(
        text: familyDetails?.motherContact ?? "",
      );

      spouseNameFamilyCtrl = TextEditingController(
        text: familyDetails?.spouseName ?? "",
      );
      spouseContactCtrl = TextEditingController(
        text: familyDetails?.spouseContact ?? "",
      );

      emailCtrl = TextEditingController(text: c.email ?? "");
      phoneCtrl = TextEditingController(text: c.phone ?? "");
      addressCtrl = TextEditingController(text: c.address ?? "");

      setState(() {
        employee = emp;
        personal = p;
        contact = c;
        employments = jobs;
        familyDetails = fam;
        loading = false;
      });
    } catch (e) {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> savePersonalSection() async {
    await ApiService.savePersonal(widget.employeeId, {
      "dob": dobCtrl.text,
      "mother_tongue": motherTongueCtrl.text,
      "blood_group": bloodGroupCtrl.text,
      "marital_status": maritalStatusCtrl.text,
      "spouse_name": spouseNameCtrl.text,
      "aadhaar_no": aadhaarCtrl.text,
      "pan_no": panCtrl.text,
      "disability_info": disabilityCtrl.text,
    });

    setState(() => isPersonalEditing = false);
  }

  Future<void> saveFamilySection() async {
    await ApiService.saveFamily(widget.employeeId, {
      "father_name": fatherNameCtrl.text,
      "father_contact": fatherContactCtrl.text,
      "mother_name": motherNameCtrl.text,
      "mother_contact": motherContactCtrl.text,
      "spouse_name": spouseNameFamilyCtrl.text,
      "spouse_contact": spouseContactCtrl.text,
    });

    setState(() => isFamilyEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading || employee == null) {
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
                        onSave: savePersonalSection, // ✅ CLEAN
                        children: [
                          _dateField(
                            "Date of Birth",
                            dobCtrl,
                            isPersonalEditing,
                          ), // ✅ UPDATED
                          _infoField(
                            "Mother Tongue",
                            motherTongueCtrl,
                            isPersonalEditing,
                          ),
                          _infoField(
                            "Blood Group",
                            bloodGroupCtrl,
                            isPersonalEditing,
                          ),
                          _infoField(
                            "Marital Status",
                            maritalStatusCtrl,
                            isPersonalEditing,
                          ),
                          _infoField(
                            "Spouse Name",
                            spouseNameCtrl,
                            isPersonalEditing,
                          ),
                          _infoField(
                            "Aadhaar No",
                            aadhaarCtrl,
                            isPersonalEditing,
                            isFullWidth: true,
                          ),
                          _infoField(
                            "PAN No",
                            panCtrl,
                            isPersonalEditing,
                            isFullWidth: true,
                          ),
                          _infoField(
                            "Disability Info",
                            disabilityCtrl,
                            isPersonalEditing,
                            isFullWidth: true,
                          ),
                        ],
                      ),
                    _buildSectionCard(
  title: "Family Details",
  icon: Icons.family_restroom_outlined,
  isEditing: isFamilyEditing,
  onEdit: () => setState(() => isFamilyEditing = true),
  onSave: saveFamilySection,
  children: [
    _infoField("Father Name", fatherNameCtrl, isFamilyEditing),
    _infoField("Father Contact", fatherContactCtrl, isFamilyEditing),
    _infoField("Mother Name", motherNameCtrl, isFamilyEditing),
    _infoField("Mother Contact", motherContactCtrl, isFamilyEditing),
    _infoField("Spouse Name", spouseNameFamilyCtrl, isFamilyEditing),
    _infoField("Spouse Contact", spouseContactCtrl, isFamilyEditing),
  ],
),
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
                          _infoField(
                            "Work Email",
                            emailCtrl,
                            isContactEditing,
                            isFullWidth: true,
                          ),
                          _infoField(
                            "Phone Number",
                            phoneCtrl,
                            isContactEditing,
                            isFullWidth: true,
                          ),
                          _infoField(
                            "Residential Address",
                            addressCtrl,
                            isContactEditing,
                            isFullWidth: true,
                          ),
                        ],
                      ),
                      _buildListSection<EmploymentModel>(
                        title: "Previous Employement Details",
                        icon: Icons.badge_outlined,
                        items: employments,
                        onAdd: () => setState(() => isAddingJob = true),
                        itemBuilder: (job) => _buildDetailTile(
                          job.employerName,
                          job.positionHeld,
                          "₹ ${job.salaryDrawn}",
                        ),
                        extraWidget: isAddingJob ? _buildInlineJobForm() : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(flex: 1, child: Column(children: [
                     
                      
                    ],
                  )),
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
                  newCompanyCtrl.clear();
                  newPositionCtrl.clear();
                  newSalaryCtrl.clear();
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: primaryTeal.withOpacity(0.1),
            child: Text(
              employee!.fullName.isNotEmpty ? employee!.fullName[0] : "?",
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
                  employee!.fullName,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  "${employee!.positionHeld ?? 'Staff Member'} • ${employee!.email}",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryTeal,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Action Menu",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required bool isEditing,
    required VoidCallback onEdit,
    required VoidCallback onSave,
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
                      onPressed: onSave,
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
          ...items.map((item) => itemBuilder(item)),
          if (extraWidget != null) extraWidget,
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
          Column(
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

  Widget _dateField(String label, TextEditingController ctrl, bool isEditing) {
    String formattedDate = ctrl.text;

    // 🔥 Convert YYYY-MM-DD → DD/MM/YYYY
    if (ctrl.text.isNotEmpty) {
      try {
        final date = DateTime.parse(ctrl.text);
        formattedDate =
            "${date.day.toString().padLeft(2, '0')}/"
            "${date.month.toString().padLeft(2, '0')}/"
            "${date.year}";
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
                    DateTime initialDate = DateTime.now();

                    if (ctrl.text.isNotEmpty) {
                      try {
                        initialDate = DateTime.parse(ctrl.text);
                      } catch (_) {}
                    }

                    final picked = await showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );

                    if (picked != null) {
                      // ✅ STORE in YYYY-MM-DD
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
                  ctrl.text.isEmpty ? "—" : formattedDate, // ✅ DISPLAY FORMAT
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
    );
  }
}
