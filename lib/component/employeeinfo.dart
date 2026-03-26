import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CreateEmployeeFullPage extends StatefulWidget {
  const CreateEmployeeFullPage({super.key});

  @override
  State<CreateEmployeeFullPage> createState() => _CreateEmployeeFullPageState();
}

class _CreateEmployeeFullPageState extends State<CreateEmployeeFullPage> {
  // ================= CONTROLLERS (Backend Logic Intact) =================
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final nationality = TextEditingController();
  final motherTongue = TextEditingController();
  final bloodGroup = TextEditingController();
  final aadhaar = TextEditingController();
  final pan = TextEditingController();
  final spouseName = TextEditingController();
  final education = TextEditingController();
  final disability = TextEditingController();
  final address = TextEditingController();
  final permanentAddress = TextEditingController();
  final fatherName = TextEditingController();
  final fatherPhone = TextEditingController();
  final motherName = TextEditingController();
  final motherPhone = TextEditingController();
  final position = TextEditingController();
  final salary = TextEditingController();
  final employer = TextEditingController();
  final employerAddress = TextEditingController();
  final pf = TextEditingController();
  final bankName = TextEditingController();
  final branch = TextEditingController();
  final account = TextEditingController();
  final ifsc = TextEditingController();
  final dobController = TextEditingController();

  DateTime? dob;
  String gender = "Male";
  String maritalStatus = "Single";
  bool _isLoading = false;

  // ================= SUBMIT LOGIC (Untouched) =================
  Future<void> submit() async {
    setState(() => _isLoading = true);
    try {
      final data = {
        "full_name": name.text,
        "email": email.text,
        "phone": phone.text,
        "gender": gender,
        "nationality": nationality.text,
        "dob": dob != null 
            ? "${dob!.year}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}" 
            : null,
        "mother_tongue": motherTongue.text,
        "blood_group": bloodGroup.text,
        "aadhaar_no": aadhaar.text,
        "pan_no": pan.text,
        "marital_status": maritalStatus,
        "spouse_name": spouseName.text,
        "education": education.text,
        "disability_info": disability.text,
        "address": address.text,
        "permanent_address": permanentAddress.text,
        "father_name": fatherName.text,
        "father_contact": fatherPhone.text,
        "mother_name": motherName.text,
        "mother_contact": motherPhone.text,
        "employer_name": employer.text,
        "employer_address": employerAddress.text,
        "position_held": position.text,
        "salary_drawn": salary.text,
        "pf_number": pf.text,
        "bank_name": bankName.text,
        "branch_name": branch.text,
        "account_number": account.text,
        "ifsc_code": ifsc.text,
      };
      await ApiService.createFullEmployee(data);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Success ✅")));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ================= UI HELPERS =================

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24), // Slightly more padding for elegance
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Softer corners
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blueGrey, size: 18),
              const SizedBox(width: 10),
              Text(
                title.toUpperCase(),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.5, color: Colors.black45),
              ),
            ],
          ),
          const Divider(height: 32, thickness: 0.5),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, {bool readOnly = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black38)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: const Color(0xFFF7F8FA),
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionBox(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : const Color(0xFFF3F3F3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(color: isSelected ? Colors.white : Colors.black54, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: const Text("Create Profile", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center( // Centers the entire form
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900), 
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildSectionCard("Basic Information", Icons.badge_outlined, [
                  _buildInput("Full Name", name),
                  _buildInput("Email Address", email),
                  _buildInput("Phone Number", phone),
                  _buildInput("Nationality", nationality),
                  _buildInput("Date of Birth", dobController, readOnly: true, onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        dob = picked;
                        dobController.text = "${picked.day}/${picked.month}/${picked.year}";
                      });
                    }
                  }),
                  const Text("Gender", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black38)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildSelectionBox("MALE", gender == "Male", () => setState(() => gender = "Male")),
                      const SizedBox(width: 12),
                      _buildSelectionBox("FEMALE", gender == "Female", () => setState(() => gender = "Female")),
                    ],
                  ),
                ]),

                _buildSectionCard("Personal Details", Icons.person_search_outlined, [
                  _buildInput("Mother Tongue", motherTongue),
                  _buildInput("Blood Group", bloodGroup),
                  _buildInput("Aadhaar Number", aadhaar),
                  _buildInput("PAN Number", pan),
                  _buildInput("Education", education),
                  const Text("Marital Status", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black38)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildSelectionBox("SINGLE", maritalStatus == "Single", () => setState(() => maritalStatus = "Single")),
                      const SizedBox(width: 12),
                      _buildSelectionBox("MARRIED", maritalStatus == "Married", () => setState(() => maritalStatus = "Married")),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (maritalStatus == "Married") _buildInput("Spouse Name", spouseName),
                  _buildInput("Disability Info", disability),
                ]),

                _buildSectionCard("Contact Information", Icons.location_on_outlined, [
                  _buildInput("Correspondence Address", address),
                  _buildInput("Permanent Address", permanentAddress),
                ]),

                _buildSectionCard("Family Details", Icons.groups_outlined, [
                  _buildInput("Father's Name", fatherName),
                  _buildInput("Father's Contact", fatherPhone),
                  _buildInput("Mother's Name", motherName),
                  _buildInput("Mother's Contact", motherPhone),
                ]),

                _buildSectionCard("Employment & Bank", Icons.account_balance_outlined, [
                  _buildInput("Last Position", position),
                  _buildInput("Last Salary", salary),
                  _buildInput("Bank Name", bankName),
                  _buildInput("Account Number", account),
                  _buildInput("IFSC Code", ifsc),
                ]),

                Padding(
                  padding: const EdgeInsets.only(bottom: 40, top: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white) 
                        : const Text("SAVE PROFILE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}