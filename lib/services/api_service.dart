import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

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

static Future<List<dynamic>> getEmployees() async {
  final token = await _getToken();

  final res = await http.get(
    Uri.parse("$baseUrl/api/employees"),
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  // 👇 ADD THESE 2 LINES HERE
  print("GET EMPLOYEES STATUS: ${res.statusCode}");
  print("GET EMPLOYEES BODY: ${res.body}");

  if (res.statusCode != 200) {
    throw Exception("Failed to fetch employees: ${res.body}");
  }

  return jsonDecode(res.body);
}


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




//employee details

static Future<Map<String, dynamic>> getEmployeeById(int id) async {
  final token = await _getToken();

  final res = await http.get(
    Uri.parse("$baseUrl/api/employees/full/$id"), 
    headers: {
      "Authorization": "Bearer $token",
    },
  );

  print("GET EMPLOYEE STATUS: ${res.statusCode}");
  print("GET EMPLOYEE BODY: ${res.body}");

  if (res.statusCode != 200) {
    throw Exception("Failed to fetch employee: ${res.body}");
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
//to read reports
static Future<List<dynamic>> getDailyReports() async {
  try {
    final token = await _getToken();
    final url = Uri.parse("$baseUrl/api/daily-reports");

    final res = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to fetch reports");
    }
  } catch (e) {
    throw Exception("API Error: $e");
  }
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


}