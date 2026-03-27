import 'package:flutter/material.dart';
import 'package:red_hrcrm/component/attendance_table.dart';
import 'package:red_hrcrm/component/attendancekpiboxes.dart';
import 'package:red_hrcrm/services/api_service.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  List<Map<String, dynamic>> attendanceList = []; // This is what was missing
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchAttendance(); // This triggers the data load
  }

  // ============== FETCH ATTENDANCE==========================
  Future<void> fetchAttendance() async {
    try {
      final data = await ApiService.getRealTimeActivity();

      setState(() {
        attendanceList = data;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() => _isLoading = false);
    }
  }

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
          // In attendance.dart (AppBar section)
          CircleAvatar(
            backgroundColor: Colors.blueGrey,
            child: Icon(
              Icons.person,
              color: Colors.white,
            ), // Safer than a broken link
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
              Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Attendance Monitoring",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Daily workforce status for October 24th, 2023",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Spacer(),
                      SizedBox(
                        height: 50,
                        width: 200,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              209,
                              240,
                              245,
                            ),
                            foregroundColor: Color(0xFF0C5D6B),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(
                            Icons.file_download_outlined,
                            size: 20,
                          ),
                          label: const Text(
                            "Export Report",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 25),
                      SizedBox(
                        height: 50,
                        width: 200,
                        child: ElevatedButton.icon(
                          onPressed: () {},
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
                          icon: const Icon(Icons.add, size: 20),
                          label: const Text(
                            "Manual Entry",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: Attendancekpiboxes(
                      symbol: Icons.access_time,
                      iconscolor: Colors.blue,
                      title: "Clocked In",
                      number: "142",
                      total: "/ 156",
                      badgeText: "+12% vs avg",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Attendancekpiboxes(
                      symbol: Icons.coffee_outlined,
                      iconscolor: Colors.orange,
                      title: "On Break",
                      number: "08",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Attendancekpiboxes(
                      symbol: Icons.person_off_outlined,
                      iconscolor: Colors.redAccent,
                      title: "Absent / Leave",
                      number: "06",
                    ),
                  ),
                ],
              ),
              // Replace your _isLoading block with this:
              Container(
                margin: const EdgeInsets.only(top: 25),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Real-time Activity",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.filter_list, size: 18),
                          label: const Text("All Departments"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // The Dynamic List
                    _isLoading
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: attendanceList.length,
                            itemBuilder: (context, index) {
                              return AttendanceTable(
                                employee: attendanceList[index],
                              );
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
