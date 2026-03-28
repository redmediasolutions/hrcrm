import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:red_hrcrm/models/Singleemployeemodel.dart';
import '../../services/api_service.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final int employeeId;

  const EmployeeDetailScreen({super.key, required this.employeeId});

  @override
  State<EmployeeDetailScreen> createState() =>
      _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  SingleEmployeeModel? employee;
  bool loading = true;

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
      final res =
          await ApiService.getEmployeeFullById(widget.employeeId);

      if (!mounted) return;

      /// 🔥 INIT CONTROLLERS
      nameCtrl = TextEditingController(text: res.fullName);
      dobCtrl = TextEditingController(text: res.dob);
      genderCtrl = TextEditingController(text: res.gender);

      roleCtrl = TextEditingController(text: res.positionHeld);
      companyCtrl = TextEditingController(text: res.employerName);
      salaryCtrl = TextEditingController(text: res.salaryDrawn);

      emailCtrl = TextEditingController(text: res.email);
      phoneCtrl = TextEditingController(text: res.phone);
      addressCtrl =
          TextEditingController(text: res.correspondenceAddress);

      setState(() {
        employee = res;
        loading = false;
      });
    } catch (e) {
      debugPrint("DETAIL ERROR: $e");
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading || employee == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
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
              onUpdate: () {
                print("UPDATE PERSONAL");
                print(nameCtrl.text);
                setState(() => isPersonalEditing = false);
              },
              children: [
                _editableField("Full Name", nameCtrl, isPersonalEditing),
                _editableField("DOB", dobCtrl, isPersonalEditing),
                _editableField("Gender", genderCtrl, isPersonalEditing),
              ],
            ),

            _sectionCard(
              title: "Professional Details",
              icon: Icons.badge,
              isEditing: isProfessionalEditing,
              onEdit: () => setState(() => isProfessionalEditing = true),
              onCancel: () =>
                  setState(() => isProfessionalEditing = false),
              onUpdate: () {
                print("UPDATE PROFESSIONAL");
                setState(() => isProfessionalEditing = false);
              },
              children: [
                _editableField("Role", roleCtrl, isProfessionalEditing),
                _editableField(
                    "Company", companyCtrl, isProfessionalEditing),
                _editableField(
                    "Salary", salaryCtrl, isProfessionalEditing),
              ],
            ),

            _sectionCard(
              title: "Contact Information",
              icon: Icons.contact_page,
              isEditing: isContactEditing,
              onEdit: () => setState(() => isContactEditing = true),
              onCancel: () =>
                  setState(() => isContactEditing = false),
              onUpdate: () {
                print("UPDATE CONTACT");
                setState(() => isContactEditing = false);
              },
              children: [
                _editableField("Email", emailCtrl, isContactEditing),
                _editableField("Phone", phoneCtrl, isContactEditing),
                _editableField(
                    "Address", addressCtrl, isContactEditing),
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
              Text(d.fullName,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              Text(d.positionHeld ?? "",
                  style: const TextStyle(color: Colors.grey)),
            ],
          )
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
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold)),
                ],
              ),

              Row(
                children: [
                  if (!isEditing)
                    TextButton(onPressed: onEdit, child: const Text("Edit")),
                  if (isEditing) ...[
                    TextButton(
                        onPressed: onCancel, child: const Text("Cancel")),
                    ElevatedButton(
                        onPressed: onUpdate,
                        child: const Text("Update")),
                  ]
                ],
              )
            ],
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 40,
            runSpacing: 20,
            children: children,
          )
        ],
      ),
    );
  }

  /// 🔥 EDIT FIELD
  Widget _editableField(
      String label, TextEditingController controller, bool isEditing) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(),
              style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 6),

          isEditing
              ? TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                )
              : Text(controller.text,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
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
            Text("HR Context",
                style: TextStyle(fontWeight: FontWeight.bold)),
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
            )
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
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Update Role"),
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text("Deactivate Employee",
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      )
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
        Text(label.toUpperCase(),
            style: const TextStyle(
                fontSize: 10, color: Colors.grey, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(value?.toString() ?? "-",
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

}