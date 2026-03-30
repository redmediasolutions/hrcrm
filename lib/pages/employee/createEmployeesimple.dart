import 'package:flutter/material.dart';
import 'package:red_hrcrm/models/deparment.dart';
import '../../services/api_service.dart';

class CreateEmployeeSimplePage extends StatefulWidget {
  const CreateEmployeeSimplePage({super.key});

  @override
  State<CreateEmployeeSimplePage> createState() =>
      _CreateEmployeeSimplePageState();
}

class _CreateEmployeeSimplePageState extends State<CreateEmployeeSimplePage> {
  // Controllers (only required ones used)
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final nationality = TextEditingController();
  final onboardingDateController = TextEditingController();
  DateTime? onboardingDate;
  List<DepartmentModel> departments = [];
  int? selectedDepartmentId;
  bool isDeptLoading = true;

  String gender = "Male";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    try {
      final res = await ApiService.getDepartments();

      setState(() {
        departments = res;
        isDeptLoading = false;

        if (departments.isNotEmpty) {
          selectedDepartmentId = departments.first.id;
        }
      });
    } catch (e) {
      setState(() => isDeptLoading = false);
    }
  }

  // ================= SUBMIT =================
  Future<void> submit() async {
    setState(() => _isLoading = true);

    try {
      final data = {
        "full_name": name.text,
        "email": email.text,
        "phone": phone.text,
        "gender": gender,
        "nationality": nationality.text,
        "department": selectedDepartmentId, // ✅ added

        "onboarding_date": onboardingDate != null
            ? "${onboardingDate!.year}-"
                  "${onboardingDate!.month.toString().padLeft(2, '0')}-"
                  "${onboardingDate!.day.toString().padLeft(2, '0')}"
            : null,
      };

      final res = await ApiService.createEmployeeBasic(data);

      final employeeId = res['employee_id'];

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Employee Created ✅")));

        // 🔥 Option 1
        Navigator.pop(context);

        // 🔥 Option 2 (recommended)
        // context.push('/employees/$employeeId/personal');
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Colors.black54,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController controller, {
    String? hint,
    bool isDate = false,
    DateTime? selectedDate,
    Function(DateTime)? onDateSelected,
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
            readOnly: isDate, // 👈 important
            onTap: isDate
                ? () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );

                    if (picked != null) {
                      controller.text =
                          "${picked.day}/${picked.month}/${picked.year}";

                      if (onDateSelected != null) {
                        onDateSelected(picked);
                      }
                    }
                  }
                : null,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: const Color(0xFFF1F3F6),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: isDate
                  ? const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: Colors.black38,
                    )
                  : null,
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

  Widget _buildDepartmentDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("DEPARTMENT"),
          const SizedBox(height: 6),

          isDeptLoading
              ? const LinearProgressIndicator()
              : DropdownButtonFormField<int>(
                  value: selectedDepartmentId,
                  items: departments.map((dept) {
                    return DropdownMenuItem<int>(
                      value: dept.id,
                      child: Text(dept.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDepartmentId = value;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF1F3F6),
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
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: const Text(
          "Create Employee",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildInput("FULL NAME", name, hint: "e.g. John Doe"),

                  _buildInput("NATIONALITY", nationality, hint: "e.g. Indian"),

                  _buildDepartmentDropdown(), // 🔥 ADD THIS

                  _buildInput("PHONE", phone, hint: "+91 98765 43210"),

                  _buildInput("EMAIL", email, hint: "john@email.com"),

                  _buildInput(
                    "ONBOARDING DATE",
                    onboardingDateController,
                    hint: "DD/MM/YYYY",
                    isDate: true,
                    selectedDate: onboardingDate,
                    onDateSelected: (date) {
                      setState(() {
                        onboardingDate = date;
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  // Gender
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _buildLabel("GENDER"),
                  ),
                  const SizedBox(height: 10),

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

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "CREATE EMPLOYEE",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
