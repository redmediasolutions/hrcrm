import 'package:flutter/material.dart';
import 'package:red_hrcrm/component/payroll_kpiboxes.dart';
import 'package:red_hrcrm/component/payrolltable.dart';
import 'package:red_hrcrm/pages/payroll/loantable.dart';
import 'package:red_hrcrm/pages/payroll/profileoutstanding.dart';

class Payroll extends StatefulWidget {
  const Payroll({super.key});

  @override
  State<Payroll> createState() => _PayrollState();
}

class _PayrollState extends State<Payroll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      //==================== APPBAR======================//
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 500,
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(15),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              // Handle notifications
            },
            icon: Icon(Icons.notifications),
            color: Colors.black,
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: () {
              // Handle notifications
            },
            icon: Icon(Icons.apps_outlined),
            color: Colors.black,
          ),
          SizedBox(width: 16),
          Divider(color: Colors.grey),
          CircleAvatar(
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
             Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  crossAxisAlignment: CrossAxisAlignment.start, // Aligns button to the top of the text
  children: [
    // Left Side: Title and Description
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Payroll",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.black, // Image shows black text for title
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8), // Spacing between title and subtext
          Text(
            "Manage employee financial assistance, track repayment schedules, and oversee automated payroll deductions with architectural precision.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: Colors.black54, // Slightly greyed out for description
                  fontWeight: FontWeight.w400,
                  height: 1.4, // Improves readability
                ),
          ),
        ],
      ),
    ),

    // Right Side: Add Loan Button
    ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add, size: 18),
      label: const Text("Add Loan"),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF004D57), // Dark teal color from image
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  ],
),
              SizedBox(height: 25),

              //=============================CONTAINER 1=================================//
             Profileoutstanding(),
              SizedBox(height: 25),

              //========================KPI BOXES FOR PAYROLL==========================//
              Column(
                children: [
                
                  LoanTable()
                 
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
