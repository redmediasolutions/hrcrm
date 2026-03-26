import 'package:flutter/material.dart';
import 'package:red_hrcrm/component/payroll_kpiboxes.dart';
import 'package:red_hrcrm/component/payrolltable.dart';

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
              Column(
                spacing: 15,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Payroll Administration",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Color(0xFF0C5D6B),
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Manage and monitor organization-wide compensation, bonuses, and tax compliance with architectural precision",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),

              //=============================CONTAINER 1=================================//
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF0B4C59),
                            Color(0xFF0C5D6B),
                            Color(0xFF1A6C7A),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "TOTAL PAYROLL THIS MONTH",
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "+4.2% from last month",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "\$1,248,500.00",
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Processing Status",
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF48E39A),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "82% Complete",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 36),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Approvals Pending",
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    "14 Stakeholders",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 25),

                  //=============================CONTAINER 2=================================//
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.event_repeat,
                                  size: 20,
                                  color: Color(0xFF0C5D6B),
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "View Calendar",
                                  style: TextStyle(
                                    color: Color(0xFF0C5D6B),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Next Pay Cycle",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Scheduled for 25th Oct, 2023. Finalize employee adjustments by end of week.",
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "06 Days",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          color: const Color(0xFF0C5D6B),
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                  Text(
                                    "UNTIL DISBURSEMENT",
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Colors.black54,
                                          letterSpacing: 0.6,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              SizedBox(
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0C5D6B),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                    ),
                                  ),
                                  child: const Text(
                                    "Prepare Cycle",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),

              //========================KPI BOXES FOR PAYROLL==========================//
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(height: 25),
                      Expanded(
                        child: PayrollKpiboxes(
                          heading: 'Recent Bonuses',
                          amount: '\$42,300',
                          subheading: '12 employees rewarded this week',
                          amtcolor: Colors.brown,
                        ),
                      ),
                      SizedBox(width: 25),
                      Expanded(
                        child: PayrollKpiboxes(
                          heading: 'Tax Accruals',
                          amount: '\$315,200',
                          subheading: 'Compliance check: 100% verified',
                          amtcolor: Color(0xFF0C5D6B),
                        ),
                      ),
                      SizedBox(width: 25),
                      Expanded(
                        child: PayrollKpiboxes(
                          heading: 'New Hires Onboarding',
                          amount: '\$18',
                          subheading: 'Enrolled in current pay cycle',
                          amtcolor: Color(0xFF0C5D6B),
                        ),
                      ),
                    ],
                  ),
                  // ===========================Recent Disbursement Table==========================//
                  SizedBox(height: 25),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Recent Disbursements',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                Spacer(),
                                SizedBox(width: 8),
                                Icon(Icons.filter_alt, size: 15),
                                SizedBox(width: 6),
                                Icon(Icons.file_download_outlined, size: 15),
                              ],
                            ),
                            SizedBox(height: 12),
                            Payrolltable(),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Processing Hub',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(      
                                      fontSize: 20,                                
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              SizedBox(height: 15,),
                              Text(
                                'SELECT DEPARTMENT',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      letterSpacing: 0.6,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFFE9ECEB),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'All Departments',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                    Icon(Icons.keyboard_arrow_down,
                                        color: Colors.black54),
                                  ],
                                ),
                              ),
                              SizedBox(height: 14),
                              Container(
                                padding: EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5F6F6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Bulk Action Status',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.autorenew,
                                          size: 16,
                                          color: Color(0xFF0C5D6B),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: LinearProgressIndicator(
                                        value: 0.65,
                                        minHeight: 6,
                                        backgroundColor: Colors.black12,
                                        valueColor: AlwaysStoppedAnimation(
                                          Color(0xFF0C5D6B),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '65% Ready',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      '652 employees are ready for disbursement. 128 require manual tax reconciliation before final submission.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 14),
                              Divider(color: Colors.black12),
                              SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Net Payroll',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  Text('\$1,012,400.00',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(fontWeight: FontWeight.w600)),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Tax & Compliance',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  Text('\$236,100.00',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(fontWeight: FontWeight.w600)),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Benefits Contribution',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  Text('\$42,000.00',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(fontWeight: FontWeight.w600)),
                                ],
                              ),
                              SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF0C5D6B),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Execute Batch Processing',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
