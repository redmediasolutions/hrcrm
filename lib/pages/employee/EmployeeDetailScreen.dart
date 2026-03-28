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

  // 🔥 NEW MODELS DATA
  PersonalModel? personal;
  ContactModel? contact;
  List<EmploymentModel> employments = [];
  List<FamilyModel> family = [];

  /// 🔥 EDIT STATES
  bool isPersonalEditing = false;
  bool isProfessionalEditing = false;
  bool isContactEditing = false;

  /// 🔥 CONTROLLERS
  late TextEditingController nameCtrl;
  late TextEditingController dobCtrl;
  late TextEditingController genderCtrl;

  late TextEditingController roleCtrl;
  late TextEditingController companyCtrl;
  late TextEditingController salaryCtrl;

  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController addressCtrl;

  @override
  void initState() {
    super.initState();
    print("🚀 EmployeeDetailScreen OPENED");
    print("🆔 Employee ID: ${widget.employeeId}");
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

      // 🔥 CONTROLLERS
      nameCtrl = TextEditingController(text: p.fullName ?? "");
      dobCtrl = TextEditingController(text: p.dob ?? "");
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
      print("❌ FETCH ERROR: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading || employee == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final d = employee!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Employee Details",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            /// 🔥 HERO HEADER
            _heroHeader(d),

            const SizedBox(height: 24),

            _sectionCard(
              title: "Personal Information",
              icon: Icons.person,
              isEditing: isPersonalEditing,
              onEdit: () => setState(() => isPersonalEditing = true),
              onCancel: () => setState(() => isPersonalEditing = false),
              onUpdate: () async {
                await ApiService.savePersonal(widget.employeeId, {
                  "full_name": nameCtrl.text,
                  "dob": dobCtrl.text,
                  "gender": genderCtrl.text,
                });

                setState(() => isPersonalEditing = false);
              },
              children: [
                _editableField("Full Name", nameCtrl, isPersonalEditing),
                _editableField("DOB", dobCtrl, isPersonalEditing),
                _editableField("Gender", genderCtrl, isPersonalEditing),
              ],
            ),

            _sectionCard(
              title: "Employment History",
              icon: Icons.work,
              isEditing: false,
              onEdit: () {},
              onCancel: () {},
              onUpdate: () {},
              children: [
                ...employments.map(
                  (job) => Container(
                    width: 250,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.employerName ?? "",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(job.positionHeld ?? ""),
                        Text("₹ ${job.salaryDrawn ?? ""}"),
                      ],
                    ),
                  ),
                ),

                /// ➕ ADD BUTTON
                GestureDetector(
                  onTap: () async {
                    await ApiService.addEmployment(widget.employeeId, {
                      "employer_name": "New Company",
                      "position_held": "Role",
                      "salary_drawn": "0",
                    });

                    fetch(); // refresh
                  },
                  child: Container(
                    width: 250,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(child: Text("+ Add Job")),
                  ),
                ),
              ],
            ),

            _sectionCard(
              title: "Family Details",
              icon: Icons.family_restroom,
              isEditing: false,
              onEdit: () {},
              onCancel: () {},
              onUpdate: () {},
              children: [
                ...family.map(
                  (f) => Container(
                    width: 250,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f.name ?? "",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(f.relation ?? ""),
                        Text("Age: ${f.age ?? "-"}"),
                      ],
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () async {
                    await ApiService.addFamily(widget.employeeId, {
                      "name": "New Member",
                      "relation": "Relation",
                      "age": 0,
                    });

                    fetch();
                  },
                  child: Container(
                    width: 250,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(child: Text("+ Add Family")),
                  ),
                ),
              ],
            ),

            _sectionCard(
              title: "Contact Information",
              icon: Icons.contact_page,
              isEditing: isContactEditing,
              onEdit: () => setState(() => isContactEditing = true),
              onCancel: () => setState(() => isContactEditing = false),
              onUpdate: () async {
                await ApiService.saveContact(widget.employeeId, {
                  "email": emailCtrl.text,
                  "phone": phoneCtrl.text,
                  "correspondence_address": addressCtrl.text,
                });

                setState(() => isContactEditing = false);
              },
              children: [
                _editableField("Email", emailCtrl, isContactEditing),
                _editableField("Phone", phoneCtrl, isContactEditing),
                _editableField("Address", addressCtrl, isContactEditing),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 HERO HEADER
  Widget _heroHeader(SingleEmployeeModel d) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.black,
            child: Text(
              d.fullName.isNotEmpty ? d.fullName[0] : "?",
              style: const TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                d.fullName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                d.positionHeld ?? "",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔥 SECTION CARD
  Widget _sectionCard({
    required String title,
    required IconData icon,
    required bool isEditing,
    required VoidCallback onEdit,
    required VoidCallback onCancel,
    required VoidCallback onUpdate,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              Row(
                children: [
                  if (!isEditing)
                    TextButton(onPressed: onEdit, child: const Text("Edit")),
                  if (isEditing) ...[
                    TextButton(
                      onPressed: onCancel,
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: onUpdate,
                      child: const Text("Update"),
                    ),
                  ],
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          Wrap(spacing: 40, runSpacing: 20, children: children),
        ],
      ),
    );
  }

  /// 🔥 EDIT FIELD
  Widget _editableField(
    String label,
    TextEditingController controller,
    bool isEditing,
  ) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
          const SizedBox(height: 6),

          isEditing
              ? TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                )
              : Text(
                  controller.text,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
        ],
      ),
    );
  }

  Widget _rightPanel() {
    return Column(
      children: [
        /// GLASS CARD
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("HR Context", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(
                "This profile is verified and active in the workforce database.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text("Verified & Active"),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        /// ACTIONS
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: const [
              ListTile(
                leading: Icon(Icons.lock),
                title: Text("Reset Credentials"),
              ),
              ListTile(leading: Icon(Icons.edit), title: Text("Update Role")),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text(
                  "Deactivate Employee",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _iconText(IconData icon, String? text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 6),
        Text(text ?? "-", style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _gridItem(String label, dynamic value) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value?.toString() ?? "-",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
