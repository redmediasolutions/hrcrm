import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:red_hrcrm/component/choicechip.dart';
import 'package:red_hrcrm/component/kpiboxes.dart';
import 'package:red_hrcrm/component/table.dart';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Staff Directory",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Manage your global workforce, roles, and departmental access.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.push('/employeeForm');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0C5D6B),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.person_add_alt_1, size: 20),
                      label: const Text(
                        "Add New Employee",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 150,
                      width: 200,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          MyChoiceChip(
                            selectedValue: selectedMethod,
                            onSelected: (value) {
                              setState(() {
                                selectedMethod = value;
                              });
                            },
                          ),
                          const Spacer(),
                          Row(
                            spacing: 10,
                            children: const [
                              Icon(Icons.filter_alt),
                              Text('Advance Filters'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const SizedBox(
                    width: 300,
                    height: 150,
                    child: KpiBox(
                      title: 'Total Workforce',
                      value: '1284',
                      deltaText: '+12 this month',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),

              const EmployeeTable(),
            ],
          ),
        ),
      ),
    );
  }
}
