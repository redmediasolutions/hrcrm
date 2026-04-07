import 'package:flutter/material.dart';
import 'package:red_hrcrm/pages/employee/employeetable.dart';
import 'package:red_hrcrm/component/header.dart';

String selectedMethod = "All Employess";

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: const AppHeader(
        searchHint: "Search Employee..",
        searchWidth: 420,
        searchFillColor: Color(0xFFEFEFEF),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const EmployeeTable(),
            ],
          ),
        ),
      ),
    );
  }
}
