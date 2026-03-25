import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CreateEmployeeFullPage extends StatefulWidget {
  const CreateEmployeeFullPage({super.key});

  @override
  State<CreateEmployeeFullPage> createState() =>
      _CreateEmployeeFullPageState();
}

class _CreateEmployeeFullPageState extends State<CreateEmployeeFullPage> {

  // ================= CONTROLLERS =================

  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final nationality = TextEditingController();

  DateTime? dob;
  String gender = "Male";

  final motherTongue = TextEditingController();
  final bloodGroup = TextEditingController();
  final aadhaar = TextEditingController();
  final pan = TextEditingController();
  String maritalStatus = "Single";
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

  // ================= SUBMIT =================

  Future<void> submit() async {
    try {
      final data = {
        "full_name": name.text,
        "email": email.text,
        "phone": phone.text,
        "gender": gender,
        "nationality": nationality.text,
        "dob": dob?.toIso8601String(),

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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Employee Created ✅")),
      );

      Navigator.pop(context);

    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // ================= UI =================

  InputDecoration input(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF3F3F3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Employee")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // ================= BASIC =================

            TextFormField(controller: name, decoration: input("Full Name")),
            const SizedBox(height: 10),

            TextFormField(controller: email, decoration: input("Email")),
            const SizedBox(height: 10),

            TextFormField(controller: phone, decoration: input("Phone")),
            const SizedBox(height: 10),

            TextFormField(controller: nationality, decoration: input("Nationality")),
            const SizedBox(height: 10),

            TextFormField(
              controller: dobController,
              readOnly: true,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );

                if (picked != null) {
                  setState(() {
                    dob = picked;
                    dobController.text =
                        "${picked.day}/${picked.month}/${picked.year}";
                  });
                }
              },
              decoration: input("DOB"),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Radio(
                  value: "Male",
                  groupValue: gender,
                  onChanged: (v) => setState(() => gender = v!),
                ),
                const Text("Male"),
                Radio(
                  value: "Female",
                  groupValue: gender,
                  onChanged: (v) => setState(() => gender = v!),
                ),
                const Text("Female"),
              ],
            ),

            const SizedBox(height: 20),

            // ================= PERSONAL =================

            TextFormField(controller: motherTongue, decoration: input("Mother Tongue")),
            const SizedBox(height: 10),

            TextFormField(controller: bloodGroup, decoration: input("Blood Group")),
            const SizedBox(height: 10),

            TextFormField(controller: aadhaar, decoration: input("Aadhaar No")),
            const SizedBox(height: 10),

            TextFormField(controller: pan, decoration: input("PAN No")),
            const SizedBox(height: 10),

            TextFormField(controller: spouseName, decoration: input("Spouse Name")),
            const SizedBox(height: 10),

            TextFormField(controller: education, decoration: input("Education")),
            const SizedBox(height: 10),

            TextFormField(controller: disability, decoration: input("Disability Info")),
            const SizedBox(height: 20),

            // ================= ADDRESS =================

            TextFormField(controller: address, decoration: input("Address")),
            const SizedBox(height: 10),

            TextFormField(controller: permanentAddress, decoration: input("Permanent Address")),
            const SizedBox(height: 20),

            // ================= FAMILY =================

            TextFormField(controller: fatherName, decoration: input("Father Name")),
            const SizedBox(height: 10),

            TextFormField(controller: fatherPhone, decoration: input("Father Phone")),
            const SizedBox(height: 10),

            TextFormField(controller: motherName, decoration: input("Mother Name")),
            const SizedBox(height: 10),

            TextFormField(controller: motherPhone, decoration: input("Mother Phone")),
            const SizedBox(height: 20),

            // ================= EMPLOYMENT =================

            TextFormField(controller: position, decoration: input("Position")),
            const SizedBox(height: 10),

            TextFormField(controller: salary, decoration: input("Salary")),
            const SizedBox(height: 10),

            TextFormField(controller: employer, decoration: input("Employer")),
            const SizedBox(height: 10),

            TextFormField(controller: employerAddress, decoration: input("Employer Address")),
            const SizedBox(height: 10),

            TextFormField(controller: pf, decoration: input("PF Number")),
            const SizedBox(height: 20),

            // ================= BANK =================

            TextFormField(controller: bankName, decoration: input("Bank Name")),
            const SizedBox(height: 10),

            TextFormField(controller: branch, decoration: input("Branch")),
            const SizedBox(height: 10),

            TextFormField(controller: account, decoration: input("Account Number")),
            const SizedBox(height: 10),

            TextFormField(controller: ifsc, decoration: input("IFSC")),
            const SizedBox(height: 30),

            // ================= BUTTON =================

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: submit,
                child: const Text("Create Employee Profile"),
              ),
            )
          ],
        ),
      ),
    );
  }
}