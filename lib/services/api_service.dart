import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:red_hrcrm/models/Singleemployeemodel.dart';
import 'package:red_hrcrm/models/contactmodel.dart';
import 'package:red_hrcrm/models/employeepaginatedmodel.dart';
import 'package:red_hrcrm/models/personalmodel.dart';
import 'package:red_hrcrm/models/employment_model.dart';
import 'package:red_hrcrm/models/family_model.dart';

class ApiService {
  static const String baseUrl = "https://api.hr.rd-crm.in";

  static Future<String> _getToken() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final token = await user.getIdToken();

    if (token == null) {
      throw Exception("Failed to get token");
    }

    return token;
  }

  // ================= EMPLOYEES =================


static Future<Map<String, dynamic>> createFullEmployee(
    Map<String, dynamic> data) async {
  final token = await _getToken();

  final res = await http.post(
    Uri.parse("$baseUrl/api/employees/full-create"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode(data),
  );

  if (res.statusCode != 200) {
    throw Exception("Create failed: ${res.body}");
  }

  return jsonDecode(res.body);
}

  static Future<void> deleteEmployee(int id) async {
    final token = await _getToken();

    final res = await http.delete(
      Uri.parse("$baseUrl/api/employees/$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    print("DELETE EMPLOYEE: ${res.statusCode}");

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("Delete failed: ${res.body}");
    }
  }

// CREATE EMPLOYEE BASIC DETAILS. STEP 1

// ================= CREATE EMPLOYEE (BASIC) =================

static Future<Map<String, dynamic>> createEmployeeBasic(
    Map<String, dynamic> data) async {
  final token = await _getToken();

  final res = await http.post(
    Uri.parse("$baseUrl/api/employees/create"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode(data),
  );

  // 🔍 Debug logs (same style as your project)
  print("CREATE EMPLOYEE STATUS: ${res.statusCode}");
  print("CREATE EMPLOYEE BODY: ${res.body}");

  if (res.statusCode != 200 && res.statusCode != 201) {
    throw Exception("Create employee failed: ${res.body}");
  }

  return jsonDecode(res.body);
}


// ========== FETCH EMPLOYEE DETAILS FROM EMPLOYEE TABLE FOR EMPLOYEE DASHBOARD ======
static Future<PaginatedEmployeeResponse> getEmployees({
  int page = 1,
  int limit = 10,
  String? search,
}) async {
  try {
    print("🔄 Fetching Employees...");
    print("➡️ Page: $page | Limit: $limit");

    final token = await _getToken();

    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (search != null && search.isNotEmpty) 'search': search,
    };

    final uri = Uri.parse("$baseUrl/api/employees")
        .replace(queryParameters: queryParams);

    print("🌐 Request URL: $uri");

    final res = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    print("📡 STATUS CODE: ${res.statusCode}");
    print("📦 RAW RESPONSE: ${res.body}");

    if (res.statusCode != 200) {
      throw Exception("Failed to fetch employees: ${res.body}");
    }

    final decoded = jsonDecode(res.body);

    final response = PaginatedEmployeeResponse.fromJson(decoded);

    print("🎯 Parsed Employees Count: ${response.data.length}");

    return response;
  } catch (e) {
    print("🔥 ERROR in getEmployees: $e");
    rethrow;
  }
}


//employee details

static Future<Map<String, dynamic>> getEmployeeById(int id) async {
  final token = await _getToken();

  final res = await http.get(
    Uri.parse("$baseUrl/api/employees/$id"),
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  if (res.statusCode != 200) {
    throw Exception("Failed to fetch employee");
  }

  return jsonDecode(res.body);
}

//attendance 
static Future<List<Map<String, dynamic>>> getRealTimeActivity() async {
  final token = await _getToken();

  final res = await http.get(
    Uri.parse("$baseUrl/api/attendance/realtime"),
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  if (res.statusCode != 200) {
    throw Exception("Failed to fetch realtime activity");
  }

  final List data = jsonDecode(res.body);
  return data.cast<Map<String, dynamic>>();
}
  // ================= PROFILES  =================

  static Future<List<dynamic>> getProfiles() async {
    final token = await _getToken();

    final res = await http.get(
      Uri.parse("$baseUrl/api/profiles"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("Failed: ${res.body}");
    }

    return jsonDecode(res.body);
  }


// ================= SINGLE EMPLOYEE =================

static Future<SingleEmployeeModel> getEmployeeFullById(int id) async {
  try {
    print("═══════════════════════════════════════");
    print("🔍 FETCH EMPLOYEE START");
    print("🆔 Employee ID: $id");

    final token = await _getToken();

    final url = "$baseUrl/api/employees/full/$id"; // ✅ FIXED

    print("🌐 REQUEST URL: $url");

    final res = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    print("📡 STATUS CODE: ${res.statusCode}");
    print("📦 RESPONSE: ${res.body}");

    if (res.statusCode != 200) {
      throw Exception("Failed to fetch employee: ${res.body}");
    }

    final json = jsonDecode(res.body);

    final employee = SingleEmployeeModel.fromJson(json);

    print("✅ FETCH SUCCESS: ${employee.fullName}");

    return employee;

  } catch (e) {
    print("❌ FETCH ERROR: $e");
    rethrow;
  }
}
static Future<PersonalModel> getPersonal(int id) async {
  final token = await _getToken();
  final res = await http.get(
    Uri.parse("$baseUrl/api/employees/$id/personal"),
    headers: {"Authorization": "Bearer $token"},
  );

  final decoded = jsonDecode(res.body);
  
  // If backend accidentally sends a list, take the first item
  if (decoded is List) {
    return PersonalModel.fromJson(decoded.isNotEmpty ? decoded[0] : {});
  }
  return PersonalModel.fromJson(decoded);
}
static Future<void> savePersonal(int id, Map<String, dynamic> data) async {
  final token = await _getToken();

  final res = await http.post(
    Uri.parse("$baseUrl/api/employees/$id/personal"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode(data),
  );

  if (res.statusCode != 200) {
    throw Exception("Failed to save personal");
  }
}

static Future<List<EmploymentModel>> getEmployment(int id) async {
  try {
    final token = await _getToken();

    final res = await http.get(
      Uri.parse("$baseUrl/api/employees/$id/employment"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to fetch employment");
    }

    final decoded = jsonDecode(res.body);

    /// 🔥 HANDLE BOTH CASES (List OR Object)
    if (decoded is List) {
      return decoded
          .map((e) => EmploymentModel.fromJson(e))
          .toList();
    } else {
      // backend sent {}
      return [];
    }

  } catch (e) {
    print("❌ EMPLOYMENT ERROR: $e");
    rethrow;
  }
}
static Future<void> addEmployment(int id, Map<String, dynamic> data) async {
  final token = await _getToken();

  final res = await http.post(
    Uri.parse("$baseUrl/api/employees/$id/employment"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode(data),
  );

  // Change this check to allow 201
  if (res.statusCode != 200 && res.statusCode != 201) {
    print("❌ Server Error Body: ${res.body}"); // Log the actual server error
    throw Exception("Failed to add employment: ${res.body}");
  }
}
static Future<void> updateEmployment(int jobId, Map<String, dynamic> data) async {
  final token = await _getToken();

  final res = await http.put(
    Uri.parse("$baseUrl/api/employment/$jobId"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode(data),
  );

  if (res.statusCode != 200) {
    throw Exception("Failed to update employment");
  }
}

static Future<List<FamilyModel>> getFamily(int id) async {
  try {
    final token = await _getToken();

    final res = await http.get(
      Uri.parse("$baseUrl/api/employees/$id/family"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to fetch family");
    }

    final decoded = jsonDecode(res.body);

    return FamilyModel.listFromJson(decoded);

  } catch (e) {
    print("❌ FAMILY ERROR: $e");
    rethrow;
  }
}
static Future<void> addFamily(int id, Map<String, dynamic> data) async {
  final token = await _getToken();

  final res = await http.post(
    Uri.parse("$baseUrl/api/employees/$id/family"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode(data),
  );

  // ✅ Fix: Allow 201 Created
  if (res.statusCode != 200 && res.statusCode != 201) {
    print("❌ ADD FAMILY ERROR: ${res.body}");
    throw Exception("Failed to add family: ${res.body}");
  }
}
static Future<void> updateFamily(int id, Map<String, dynamic> data) async {
  final token = await _getToken();

  final res = await http.put(
    Uri.parse("$baseUrl/api/family/$id"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode(data),
  );

  if (res.statusCode != 200) {
    throw Exception("Failed to update family");
  }
}

static Future<ContactModel> getContact(int id) async {
  final token = await _getToken();
  final res = await http.get(
    Uri.parse("$baseUrl/api/employees/$id/contact"),
    headers: {"Authorization": "Bearer $token"},
  );

  if (res.statusCode != 200) return ContactModel(); // Return empty model instead of crashing

  final decoded = jsonDecode(res.body);
  
  if (decoded is List) {
    return ContactModel.fromJson(decoded.isNotEmpty ? decoded[0] : {});
  }
  // If backend returns null or empty string, handle it
  return ContactModel.fromJson(decoded ?? {});
}
static Future<void> saveContact(int id, Map<String, dynamic> data) async {
  final token = await _getToken();

  final res = await http.post(
    Uri.parse("$baseUrl/api/employees/$id/contact"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode(data),
  );

  if (res.statusCode != 200) {
    throw Exception("Failed to save contact");
  }
}

}