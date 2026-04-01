import 'package:flutter/material.dart';
import 'package:red_hrcrm/pages/payroll/widgets/loan_history.dart';
import 'package:red_hrcrm/pages/payroll/widgets/recent_deduction.dart';
import 'package:red_hrcrm/pages/payroll/widgets/stat_card.dart';

class PayrollDetails extends StatelessWidget {
  const PayrollDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
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
              prefixIcon: const Icon(Icons.search),
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
            icon: const Icon(Icons.notifications),
            color: Colors.black,
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              // Handle apps
            },
            icon: const Icon(Icons.apps_outlined),
            color: Colors.black,
          ),
          const SizedBox(width: 16),
          const Divider(color: Colors.grey),
          const CircleAvatar(
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Employee Loan Details",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFF0C5D6B),
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x11000000),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const CircleAvatar(
                          //   radius: 32,
                          //   backgroundImage: NetworkImage(
                          //     'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=200&q=80',
                          //   ),
                          // ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Marcus Aurelius",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "KL-9021-HR  •  Senior HR Analyst",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.black54,
                                      ),
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF0C5D6B),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      icon: const Icon(Icons.add, size: 18),
                                      label: const Text(
                                        "Add Deduction",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    OutlinedButton.icon(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor:
                                            const Color(0xFF0C5D6B),
                                        side: const BorderSide(
                                          color: Color(0xFF0C5D6B),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.upload_file,
                                        size: 18,
                                      ),
                                      label: const Text(
                                        "Export History",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAD7D7),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "REMAINING BALANCE",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: const Color(0xFFB04A4A),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "\$12,450.00",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: const Color(0xFF9E1B1B),
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                size: 16,
                                color: Color(0xFFB04A4A),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Repayment is 65% complete",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: const Color(0xFFB04A4A),
                                      fontWeight: FontWeight.w600,
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
              const SizedBox(height: 20),
              Row(
                children: const [
                  Expanded(
                    child: StatInfoCard(
                      title: 'Total Loan Taken',
                      value: '\$35,000.00',
                      icon: Icons.account_balance,
                      accentColor: Color(0xFF0C5D6B),
                      borderColor: Color(0xFF0C5D6B),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: StatInfoCard(
                      title: 'Total Deducted',
                      value: '\$22,550.00',
                      icon: Icons.attach_money,
                      accentColor: Color(0xFF4C8C86),
                      borderColor: Color(0xFF4C8C86),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: StatInfoCard(
                      title: 'Installments Paid',
                      value: '14 / 24',
                      icon: Icons.calendar_today,
                      accentColor: Color(0xFFF3A85B),
                      borderColor: Color(0xFFF3A85B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x11000000),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Loans History',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const Spacer(),
                              Text(
                                '3 ACTIVE RECORDS',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: Colors.black45,
                                      letterSpacing: 0.6,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          LoanHistoryTable(
                            items: [
                              LoanHistoryItem(
                                date: 'Oct 12, 2023',
                                reference: 'Ref: LN-882',
                                amount: '\$25,000.00',
                                reason: 'Housing Advance',
                                status: 'Active',
                                statusColor: const Color(0xFF4C8C86),
                              ),
                              LoanHistoryItem(
                                date: 'Jan 05, 2023',
                                reference: 'Ref: LN-412',
                                amount: '\$10,000.00',
                                reason: 'Vehicle Loan',
                                status: 'Closed',
                                statusColor: const Color(0xFF9E9E9E),
                              ),
                              LoanHistoryItem(
                                date: 'May 14, 2022',
                                reference: 'Ref: LN-102',
                                amount: '\$5,000.00',
                                reason: 'Personal Advance',
                                status: 'Closed',
                                statusColor: const Color(0xFF9E9E9E),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x11000000),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Recent Deductions',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const Spacer(),
                              Text(
                                'View All',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: const Color(0xFF0C5D6B),
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const RecentDeductionTile(
                            date: 'Feb 28, 2024',
                            title: 'Monthly installment Feb',
                            subtitle: '"Monthly installment Feb"',
                            amount: '-\$1,250.00',
                            tag: 'SALARY',
                            icon: Icons.account_balance_wallet,
                            iconBackground: Color(0xFFD9EEF2),
                            tagColor: Color(0xFF4C8C86),
                          ),
                          const RecentDeductionTile(
                            date: 'Feb 15, 2024',
                            title: 'Partial early repayment',
                            subtitle: '"Partial early repayment"',
                            amount: '-\$5,000.00',
                            tag: 'MANUAL',
                            icon: Icons.person,
                            iconBackground: Color(0xFFD6ECFF),
                            tagColor: Color(0xFF2B6CB0),
                          ),
                          const RecentDeductionTile(
                            date: 'Jan 31, 2024',
                            title: 'Monthly installment Jan',
                            subtitle: '"Monthly installment Jan"',
                            amount: '-\$1,250.00',
                            tag: 'SALARY',
                            icon: Icons.account_balance_wallet,
                            iconBackground: Color(0xFFD9EEF2),
                            tagColor: Color(0xFF4C8C86),
                          ),
                        ],
                      ),
                    ),
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


