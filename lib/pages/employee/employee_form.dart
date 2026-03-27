import 'package:flutter/material.dart';
import 'package:red_hrcrm/pages/employee/employeetable.dart';


class EmployeeForm extends StatelessWidget {
  const EmployeeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Staff Directory"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: EmployeeTable(),
      ),
    );
  }
}