import 'package:flutter/material.dart';
import 'package:red_hrcrm/component/task_kpibox.dart';
import 'package:red_hrcrm/component/tasktable.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {

  final List<Map<String, dynamic>> mySubmissions = [
  {
    "name": "Elena Vance",
    "task": "Q3 Infrastructure Audit",
    "dept": "DevOps",
    "time": "Today, 10:45 AM",
    "status": "REVIEW NEEDED",
    "image": "https://i.pravatar.cc/150?u=elena"
  },
  {
    "name": "Jordan Diaz",
    "task": "Brand Identity Overhaul",
    "dept": "Design",
    "time": "Today, 09:12 AM",
    "status": "IN PROGRESS",
    "image": "https://i.pravatar.cc/150?u=jordan"
  },
];

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
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Report Oversight Dashboard",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Monitor real-time progress and approve employee submissions.",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 25,),
              Row(
               
                children: [
                  Expanded(
                    flex: 1 ,
                    child:                   
                  TaskKpibox(
                    heading: 'Total Reports',
                   total: '1,284')),
                      SizedBox(width: 15,),
                   Expanded(
                       flex: 1 ,
                    child:                   
                  TaskKpibox(
                    
                    heading: 'Pending Review',
                   total: '1,284')),
                      SizedBox(width: 15,),

                   Expanded(
                       flex: 1 ,
                    child:                   
                  TaskKpibox(
                    heading: 'Todays Logs',
                   total: '1,284')),
                      
                ],
              ),
              SizedBox(height: 25,),
              Tasktable(submissions: mySubmissions)
            ],
          ),
        ),
      ),
    );
  }
}
