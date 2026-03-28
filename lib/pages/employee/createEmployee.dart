import 'package:flutter/material.dart';
import '../../services/api_service.dart';

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
  final spousephone = TextEditingController();

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Success ✅")));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ================= UI HELPERS =================

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFFE8EDF2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.black87, size: 16),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFFD1E3E7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.stars,
                      color: Color(0xFF2C5364),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    "FULL LIFE ASSEMBLY OF GOD (FLAG)",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  "10/15, II Floor, East Patel Nagar, Delhi - 110008\nPh: +91 9811273880",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 80,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              "AFFIX\nPHOTO",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 8, color: Colors.black38),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: Colors.black45,
        letterSpacing: 0.5,
      ),
    );
  }

  // Updated Input to match the light-grey "Ghost" style
  Widget _buildInput(
    String label,
    TextEditingController controller, {
    String? hint,
    IconData? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.black26,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              suffixIcon: suffixIcon != null
                  ? Icon(suffixIcon, size: 18, color: Colors.black38)
                  : null,
              filled: true,
              fillColor: const Color(
                0xFFF1F3F6,
              ), // Specific soft grey from design
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Updated Selection Box to look like the Radio Buttons in the image
  Widget _buildSelectionBox(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 18,
              color: isSelected ? Colors.black87 : Colors.black38,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxRow(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F6),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: const Text(
          "Create Profile",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        // Centers the entire form
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildSectionCard("Personal Information", Icons.person_outline, [
                  _buildHeader(),
                  const SizedBox(height: 24),

                  // Row 1: Name and Date of Birth
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildInput(
                          "NAME",
                          name,
                          hint: "e.g. Alexander Pierce",
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInput(
                          "DATE OF BIRTH",
                          dobController,
                          hint: "DD/MM/YYYY",
                          suffixIcon: Icons.calendar_today_outlined,
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
                        ),
                      ),
                    ],
                  ),

                  // Row 2: Gender Selection
                  _buildLabel("GENDER"),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSelectionBox(
                        "Male",
                        gender == "Male",
                        () => setState(() => gender = "Male"),
                      ),
                      const SizedBox(width: 12),
                      _buildSelectionBox(
                        "Female",
                        gender == "Female",
                        () => setState(() => gender = "Female"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Row 3: Nationality and Mother Tongue
                  Row(
                    children: [
                      Expanded(
                        child: _buildInput(
                          "NATIONALITY",
                          nationality,
                          hint: "e.g. Indian",
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInput(
                          "MOTHER TONGUE",
                          motherTongue,
                          hint: "e.g. Hindi",
                        ),
                      ),
                    ],
                  ),

                  // Row 4: Blood Group and Aadhaar
                  Row(
                    children: [
                      Expanded(
                        child: _buildInput(
                          "BLOOD GROUP",
                          bloodGroup,
                          hint: "e.g. O+",
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInput(
                          "AADHAAR NO.",
                          aadhaar,
                          hint: "XXXX XXXX XXXX",
                        ),
                      ),
                    ],
                  ),

                  // Row 5: PAN and Marital Status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildInput("PAN NO.", pan, hint: "ABCDE1234F"),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("MARITAL STATUS"),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildSelectionBox(
                                  "Single",
                                  maritalStatus == "Single",
                                  () =>
                                      setState(() => maritalStatus = "Single"),
                                ),
                                const SizedBox(width: 12),
                                _buildSelectionBox(
                                  "Married",
                                  maritalStatus == "Married",
                                  () =>
                                      setState(() => maritalStatus = "Married"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Row 6: Spouse and Education
                  Row(
                    children: [
                      Expanded(
                        child: _buildInput(
                          "SPOUSE'S NAME",
                          spouseName,
                          hint: "e.g. Priya Sharma",
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInput(
                          "EDUCATIONAL QUALIFICATION",
                          education,
                          hint: "e.g. B.Tech",
                        ),
                      ),
                    ],
                  ),

                  _buildInput(
                    "ANY PHYSICAL DISABILITY OR ALLERGIC TO ANY FOOD OR DRUG",
                    disability,
                    hint: "e.g. None",
                  ),
                ]),

                SizedBox(height: 25),
                //=================== CONTACT INFO=========================//
                _buildSectionCard(
                  "Contact Information",
                  Icons.contact_mail_outlined,
                  [
                    // 1. Full-width Address Fields
                    _buildInput(
                      "CORRESPONDENCE",
                      address,
                      hint: "Enter correspondence address",
                    ),
                    _buildInput(
                      "PERMANENT ADDRESS (IF DIFFERENT)",
                      permanentAddress,
                      hint: "Enter permanent address",
                    ),

                    const SizedBox(height: 8),

                    // 2. Row: Phone and Email
                    Row(
                      children: [
                        Expanded(
                          child: _buildInput(
                            "PHONE",
                            phone,
                            hint: "e.g. +91 98765 43210",
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInput(
                            "EMAIL",
                            email,
                            hint: "name@company.com",
                          ),
                        ),
                      ],
                    ),

                    // 3. Row: Spouse Name and Contact
                  ],
                ),

                //=================== FAMILY INFO=========================//
                SizedBox(height: 25),
                _buildSectionCard("Family Details", Icons.groups_outlined, [
                  Row(
                    children: [
                      Expanded(
                        child: _buildInput(
                          "SPOUSE NAME",
                          spouseName,
                          hint: "e.g. Priya Sharma",
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Reusing phone controller or specific spouse contact controller
                      Expanded(
                        child: _buildInput(
                          "CONTACT NUMBER",
                          TextEditingController(),
                          hint: "e.g. +91 98765 43210",
                        ),
                      ),
                    ],
                  ),

                  // 4. Row: Father's Details
                  Row(
                    children: [
                      Expanded(
                        child: _buildInput(
                          "FATHER'S NAME",
                          fatherName,
                          hint: "e.g. Ramesh Sharma",
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInput(
                          "CONTACT NUMBER",
                          fatherPhone,
                          hint: "e.g. +91 98765 43210",
                        ),
                      ),
                    ],
                  ),

                  // 5. Row: Mother's Details
                  Row(
                    children: [
                      Expanded(
                        child: _buildInput(
                          "MOTHER'S NAME",
                          motherName,
                          hint: "e.g. Sunita Sharma",
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInput(
                          "CONTACT NUMBER",
                          motherPhone,
                          hint: "e.g. +91 98765 43210",
                        ),
                      ),
                    ],
                  ),
                ]),

                // _buildSectionCard(
                //   "Employment & Bank",
                //   Icons.account_balance_outlined,
                //   [
                //     _buildInput("Last Position", position),
                //     _buildInput("Last Salary", salary),
                //     _buildInput("Bank Name", bankName),
                //     _buildInput("Account Number", account),
                //     _buildInput("IFSC Code", ifsc),
                //   ],
                // ),

                //=================== BANK DETAILS SECTION=========================//
                SizedBox(height: 25),

                _buildSectionCard(
                  "Bank Details",
                  Icons.account_balance_outlined,
                  [
                    _buildInput(
                      "NAME OF THE BANK",
                      bankName,
                      hint: "e.g. State Bank of India",
                    ),
                    _buildInput(
                      "NAME OF THE BRANCH",
                      branch,
                      hint: "e.g. MG Road",
                    ),
                    _buildInput(
                      "BANK ACCOUNT NUMBER",
                      account,
                      hint: "e.g. 1234567890",
                    ),
                    _buildInput("IFSC CODE", ifsc, hint: "e.g. SBIN0001234"),
                  ],
                ),

                //=================== DECLARATION SECTION========================//
                SizedBox(height: 25),

                // 2. Declaration Section
                _buildSectionCard("Declaration", Icons.verified_outlined, [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Text(
                          "I undersigned hereby confirm that all the information given above is true and correct.",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: _buildInput("", ifsc, hint: "Signature"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "NB: Kindly attach a copy of your Aadhar Card, PAN Card, Experience certificate, Salary Proof, Bank Passbook Front Page, Medical certificate, Recommendation Letter and Education Certificates together with this form.",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black45,
                      height: 1.5,
                    ),
                  ),
                ]),
                //=================== PREVIOUS EMPLOYEMENT========================//
                SizedBox(height: 25),

                _buildSectionCard("Previous Employment", Icons.work_outline, [
                  Row(
                    children: [
                      Expanded(
                        child: _buildInput(
                          "POSITION HELD",
                          position,
                          hint: "e.g. Senior Analyst",
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInput(
                          "SALARY DRAWN",
                          salary,
                          hint: "e.g. 45,000",
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInput(
                          "EMPLOYER NAME",
                          employer,
                          hint: "e.g. Red Systems",
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInput(
                          "EMPLOYER ADDRESS",
                          employerAddress,
                          hint: "e.g. 12, MG Road, Pune",
                        ),
                      ),
                    ],
                  ),
                  _buildInput("P F NUMBER", pf, hint: "e.g. PF1234567"),
                ]),

                //=================== EMERGENCY CONTACT DETAILS========================//
                SizedBox(height: 25),

                _buildSectionCard(
                  "Emergency Contact Details",
                  Icons.shield_outlined,
                  [
                    _buildInput(
                      "NAME AND ADDRESS OF NEXT KIN",
                      address,
                      hint: "e.g. Ramesh Sharma, 22 Park Street, Delhi",
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInput(
                            "RELATIONSHIP",
                            TextEditingController(),
                            hint: "e.g. Father",
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInput(
                            "CONTACT NUMBER",
                            TextEditingController(),
                            hint: "e.g. +91 98765 43210",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                //=================== OFFICE USE ONLY======================//
                SizedBox(height: 25),
                _buildSectionCard(
                  "FOR OFFICE USE ONLY",
                  Icons.fact_check_outlined,
                  [
                    // Row 1: Received Date and Checked By Date
                    Row(
                      children: [
                        Expanded(
                          child: _buildInput(
                            "RECEIVED DATE",
                            TextEditingController(),
                            hint: "DD/MM/YYYY",
                            suffixIcon: Icons.calendar_today_outlined,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInput(
                            "CHECKED BY DATE",
                            TextEditingController(),
                            hint: "DD/MM/YYYY",
                            suffixIcon: Icons.calendar_today_outlined,
                          ),
                        ),
                      ],
                    ),

                    // Row 2: Date of Joining (Full Width)
                    _buildInput(
                      "DATE OF JOINING",
                      TextEditingController(),
                      hint: "DD/MM/YYYY",
                      suffixIcon: Icons.calendar_today_outlined,
                    ),

                    const SizedBox(height: 12),
                    _buildLabel("CHECKLIST"),
                    const SizedBox(height: 12),

                    // Checkbox Grid
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _buildCheckboxRow("PAN CARD"),
                              _buildCheckboxRow("EXPERIENCE CERTIFICATE"),
                              _buildCheckboxRow("EDUCATIONAL CERTIFICATES"),
                              _buildCheckboxRow("RECOMMENDATION LETTER"),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            children: [
                              _buildCheckboxRow("AADHAR CARD"),
                              _buildCheckboxRow("SALARY PROOF"),
                              _buildCheckboxRow("BANK PASSBOOK"),
                              _buildCheckboxRow("MEDICAL CERTIFICATE"),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // HR Sign Approval
                    _buildLabel("HR SIGN"),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildSelectionBox("APPROVED", true, () {}),
                        const SizedBox(width: 12),
                        _buildSelectionBox("NOT APPROVED", false, () {}),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Allotted ID and President Signature
                    Row(
                      children: [
                        Expanded(
                          child: _buildInput(
                            "EMPLOYEE ID NUMBER ALLOTTED",
                            TextEditingController(),
                            hint: "e.g. EMP-1024",
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("PRESIDENT'S SIGNATURE"),
                              const SizedBox(height: 6),
                              TextFormField(
                                // Assign a controller here if you need to capture the text
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                  hintText: "SIGNATURE",
                                  hintStyle: const TextStyle(
                                    color: Colors.black26,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF1F3F6),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40, top: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "SAVE PROFILE",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
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
