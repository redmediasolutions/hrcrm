import 'package:flutter/material.dart';
import 'package:red_hrcrm/pages/employee/employeetable.dart';

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

              const EmployeeTable(),
            ],
          ),
        ),
      ),
    );
  }
}
