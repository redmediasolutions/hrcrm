import 'package:flutter/material.dart';
import 'package:red_hrcrm/models/Singleemployeemodel.dart';
import 'package:red_hrcrm/models/contactmodel.dart';
import 'package:red_hrcrm/models/employment_model.dart';
import 'package:red_hrcrm/models/family_model.dart';
import 'package:red_hrcrm/models/office_use_model.dart';
import 'package:red_hrcrm/models/personalmodel.dart';
import 'package:red_hrcrm/models/remuneration_model.dart';
import '../../../services/api_service.dart';

class EmployeeDetailController extends ChangeNotifier {
  final int employeeId;
  final BuildContext context;

  EmployeeDetailController({required this.employeeId, required this.context});

  // ─── Data Models ────────────────────────────────────────────────────────────
  SingleEmployeeModel? employee;
  PersonalModel? personal;
  ContactModel? contact;
  FamilyModel? familyDetails;
  RemunerationModel? remuneration;
  List<EmploymentModel> employments = [];

  // ─── UI State Flags ──────────────────────────────────────────────────────────
  bool loading = true;
  bool isPersonalEditing = false;
  bool isContactEditing = false;
  bool isFamilyEditing = false;
  bool isRemunerationEditing = false;
  bool isOfficeEditing = false;
  bool isOfficeSaving = false;
  bool isAddingJob = false;

  // ─── Personal Controllers ────────────────────────────────────────────────────
  late TextEditingController dobCtrl;
  late TextEditingController motherTongueCtrl;
  late TextEditingController bloodGroupCtrl;
  late TextEditingController maritalStatusCtrl;
  late TextEditingController spouseNameCtrl;
  late TextEditingController aadhaarCtrl;
  late TextEditingController panCtrl;
  late TextEditingController disabilityCtrl;

  // ─── Contact Controllers ─────────────────────────────────────────────────────
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController addressCtrl;

  // ─── Family Controllers ──────────────────────────────────────────────────────
  late TextEditingController fatherNameCtrl;
  late TextEditingController fatherContactCtrl;
  late TextEditingController motherNameCtrl;
  late TextEditingController motherContactCtrl;
  late TextEditingController spouseNameFamilyCtrl;
  late TextEditingController spouseContactCtrl;

  // ─── Remuneration Controllers ─────────────────────────────────────────────────
  late TextEditingController basicCtrl;
  late TextEditingController hraCtrl;
  late TextEditingController overtimeCtrl;
  late TextEditingController bonusCtrl;
  late TextEditingController loansCtrl;
  late TextEditingController advanceCtrl;
  late TextEditingController lopCtrl;
  late TextEditingController pfCtrl;
  late TextEditingController esiCtrl;
  late TextEditingController taxCtrl;

  // ─── Job (Add Employment) Controllers ────────────────────────────────────────
  final TextEditingController newCompanyCtrl = TextEditingController();
  final TextEditingController newPositionCtrl = TextEditingController();
  final TextEditingController newSalaryCtrl = TextEditingController();

  // ─── Office Use State ────────────────────────────────────────────────────────
  DateTime? receivedDate;
  DateTime? checkedDate;
  DateTime? joiningDate;

  bool pan = false;
  bool aadhaar = false;
  bool experience = false;
  bool salary = false;
  bool education = false;
  bool bank = false;
  bool recommendation = false;
  bool medical = false;
  bool notApproved = false;
  bool approved = false;

  final TextEditingController empIdNumberCtrl = TextEditingController();

  // ─── Fetch ───────────────────────────────────────────────────────────────────
  Future<void> fetch() async {
    try {
      final emp = await ApiService.getEmployeeFullById(employeeId);
      final p = await ApiService.getPersonal(employeeId);
      final c = await ApiService.getContact(employeeId);
      final jobs = await ApiService.getEmployment(employeeId);
      final fam = await ApiService.getFamily(employeeId);

      RemunerationModel? r;
      try {
        r = await ApiService.getRemuneration(employeeId);
      } catch (e) {
        debugPrint("⚠️ No remuneration found → using empty");
        r = null;
      }

      // Clean DOB
      String cleanDob = p.dob ?? "";
      if (cleanDob.contains("T")) cleanDob = cleanDob.split("T")[0];

      // Personal
      dobCtrl = TextEditingController(text: cleanDob);
      motherTongueCtrl = TextEditingController(text: p.motherTongue ?? "");
      bloodGroupCtrl = TextEditingController(text: p.bloodGroup ?? "");
      maritalStatusCtrl = TextEditingController(text: p.maritalStatus ?? "");
      spouseNameCtrl = TextEditingController(text: p.spouseName ?? "");
      aadhaarCtrl = TextEditingController(text: p.aadhaarNo ?? "");
      panCtrl = TextEditingController(text: p.panNo ?? "");
      disabilityCtrl = TextEditingController(text: p.disabilityInfo ?? "");

      // Contact
      emailCtrl = TextEditingController(text: c.email ?? "");
      phoneCtrl = TextEditingController(text: c.phone ?? "");
      addressCtrl = TextEditingController(text: c.address ?? "");

      // Family
      fatherNameCtrl = TextEditingController(text: fam?.fatherName ?? "");
      fatherContactCtrl = TextEditingController(text: fam?.fatherContact ?? "");
      motherNameCtrl = TextEditingController(text: fam?.motherName ?? "");
      motherContactCtrl = TextEditingController(text: fam?.motherContact ?? "");
      spouseNameFamilyCtrl = TextEditingController(text: fam?.spouseName ?? "");
      spouseContactCtrl = TextEditingController(text: fam?.spouseContact ?? "");

      // Remuneration
      basicCtrl = TextEditingController(text: r?.basicPay?.toString() ?? "");
      hraCtrl = TextEditingController(text: r?.hra?.toString() ?? "");
      overtimeCtrl = TextEditingController(text: r?.overtime?.toString() ?? "");
      bonusCtrl = TextEditingController(text: r?.bonus?.toString() ?? "");
      loansCtrl = TextEditingController(text: r?.loans?.toString() ?? "");
      advanceCtrl = TextEditingController(text: r?.advance?.toString() ?? "");
      lopCtrl = TextEditingController(text: r?.lop?.toString() ?? "");
      pfCtrl = TextEditingController(text: r?.pfDeduction?.toString() ?? "");
      esiCtrl = TextEditingController(text: r?.esi?.toString() ?? "");
      taxCtrl = TextEditingController(text: r?.professionalTax?.toString() ?? "");

      employee = emp;
      personal = p;
      contact = c;
      employments = jobs;
      familyDetails = fam;
      remuneration = r;
      loading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("❌ FETCH ERROR: $e");
      loading = false;
      notifyListeners();
    }
  }

  // ─── Date Helpers ────────────────────────────────────────────────────────────
  Future<void> pickDate(BuildContext ctx, Function(DateTime) onSelected) async {
    final picked = await showDatePicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onSelected(picked);
      notifyListeners();
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return "Select Date";
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // ─── Save: Personal ──────────────────────────────────────────────────────────
  Future<void> savePersonal() async {
    await ApiService.savePersonal(employeeId, {
      "dob": dobCtrl.text,
      "mother_tongue": motherTongueCtrl.text,
      "blood_group": bloodGroupCtrl.text,
      "marital_status": maritalStatusCtrl.text,
      "spouse_name": spouseNameCtrl.text,
      "aadhaar_no": aadhaarCtrl.text,
      "pan_no": panCtrl.text,
      "disability_info": disabilityCtrl.text,
    });
    isPersonalEditing = false;
    notifyListeners();
  }

  // ─── Save: Contact ───────────────────────────────────────────────────────────
  Future<void> saveContact() async {
    await ApiService.saveContact(employeeId, {
      "email": emailCtrl.text,
      "phone": phoneCtrl.text,
      "correspondence_address": addressCtrl.text,
    });
    isContactEditing = false;
    notifyListeners();
  }

  // ─── Save: Family ────────────────────────────────────────────────────────────
  Future<void> saveFamily() async {
    await ApiService.saveFamily(employeeId, {
      "father_name": fatherNameCtrl.text,
      "father_contact": fatherContactCtrl.text,
      "mother_name": motherNameCtrl.text,
      "mother_contact": motherContactCtrl.text,
      "spouse_name": spouseNameFamilyCtrl.text,
      "spouse_contact": spouseContactCtrl.text,
    });
    isFamilyEditing = false;
    notifyListeners();
  }

  // ─── Save: Remuneration ──────────────────────────────────────────────────────
  Future<void> saveRemuneration() async {
    try {
      final model = RemunerationModel(
        employeeId: employeeId,
        basicPay: double.tryParse(basicCtrl.text) ?? 0,
        hra: double.tryParse(hraCtrl.text) ?? 0,
        overtime: double.tryParse(overtimeCtrl.text) ?? 0,
        bonus: double.tryParse(bonusCtrl.text) ?? 0,
        loans: double.tryParse(loansCtrl.text) ?? 0,
        advance: double.tryParse(advanceCtrl.text) ?? 0,
        lop: double.tryParse(lopCtrl.text) ?? 0,
        pfDeduction: double.tryParse(pfCtrl.text) ?? 0,
        esi: double.tryParse(esiCtrl.text) ?? 0,
        professionalTax: double.tryParse(taxCtrl.text) ?? 0,
      );
      await ApiService.saveRemuneration(model);
      isRemunerationEditing = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Remuneration saved!")),
      );
      await fetch();
    } catch (e) {
      debugPrint("❌ SAVE FAILED: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving: $e"), backgroundColor: Colors.red),
      );
    }
  }

  // ─── Save: Office Use ────────────────────────────────────────────────────────
  Future<void> saveOfficeUse() async {
    try {
      isOfficeSaving = true;
      notifyListeners();

      final model = OfficeUseModel(
        employeeId: employeeId,
        receivedDate: receivedDate?.toIso8601String().split('T')[0],
        checkedByDate: checkedDate?.toIso8601String().split('T')[0],
        dateOfJoining: joiningDate?.toIso8601String().split('T')[0],
        panCard: pan,
        aadhaarCard: aadhaar,
        experienceCertificate: experience,
        salaryProof: salary,
        educationalCertificates: education,
        bankPassbook: bank,
        recommendationLetter: recommendation,
        medicalCertificate: medical,
        approved: approved,
        notApproved: notApproved,
        employeeIdNumber: empIdNumberCtrl.text,
      );

      await ApiService.saveOfficeUse(model);
      isOfficeEditing = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Office section saved successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    } finally {
      isOfficeSaving = false;
      notifyListeners();
    }
  }

  // ─── Add Employment ──────────────────────────────────────────────────────────
  Future<void> addEmployment() async {
    await ApiService.addEmployment(employeeId, {
      "employer_name": newCompanyCtrl.text,
      "position_held": newPositionCtrl.text,
      "salary_drawn": newSalaryCtrl.text,
    });
    newCompanyCtrl.clear();
    newPositionCtrl.clear();
    newSalaryCtrl.clear();
    isAddingJob = false;
    await fetch();
  }

  // ─── Remuneration Calculations ────────────────────────────────────────────────
  double get totalEarnings {
    double p(String t) => double.tryParse(t) ?? 0.0;
    return p(basicCtrl.text) + p(hraCtrl.text) + p(overtimeCtrl.text) + p(bonusCtrl.text);
  }

  double get totalDeductions {
    double p(String t) => double.tryParse(t) ?? 0.0;
    return p(loansCtrl.text) + p(advanceCtrl.text) + p(lopCtrl.text) +
        p(pfCtrl.text) + p(esiCtrl.text) + p(taxCtrl.text);
  }

  double get netSalary => totalEarnings - totalDeductions;

  // ─── Dispose ─────────────────────────────────────────────────────────────────
  @override
  void dispose() {
    dobCtrl.dispose();
    motherTongueCtrl.dispose();
    bloodGroupCtrl.dispose();
    maritalStatusCtrl.dispose();
    spouseNameCtrl.dispose();
    aadhaarCtrl.dispose();
    panCtrl.dispose();
    disabilityCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    fatherNameCtrl.dispose();
    fatherContactCtrl.dispose();
    motherNameCtrl.dispose();
    motherContactCtrl.dispose();
    spouseNameFamilyCtrl.dispose();
    spouseContactCtrl.dispose();
    basicCtrl.dispose();
    hraCtrl.dispose();
    overtimeCtrl.dispose();
    bonusCtrl.dispose();
    loansCtrl.dispose();
    advanceCtrl.dispose();
    lopCtrl.dispose();
    pfCtrl.dispose();
    esiCtrl.dispose();
    taxCtrl.dispose();
    newCompanyCtrl.dispose();
    newPositionCtrl.dispose();
    newSalaryCtrl.dispose();
    empIdNumberCtrl.dispose();
    super.dispose();
  }
}
