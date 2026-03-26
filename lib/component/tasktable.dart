import 'package:flutter/material.dart';

class Tasktable extends StatelessWidget {
  final List<Map<String, dynamic>> submissions;

  const Tasktable({super.key, required this.submissions});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xFFF8FAFC),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ]),
      child: Column(
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Active Submissions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Text('View Full Report', 
                  style: TextStyle(color: Color(0xFF0C5D6B), fontWeight: FontWeight.bold)),
                label: const Icon(Icons.arrow_forward, size: 16, color: Color(0xFF0C5D6B)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Table Labels
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
            child: Row(
              children: [
                Expanded(flex: 2, child: _LabelText('EMPLOYEE')),
                Expanded(flex: 2, child: _LabelText('TASK TITLE')),
                Expanded(flex: 1, child: _LabelText('DEPARTMENT')),
                Expanded(flex: 2, child: _LabelText('TIMELINE')),
                Expanded(flex: 1, child: _LabelText('STATUS')),
                Expanded(flex: 1, child: _LabelText('ACTION')),
              ],
            ),
          ),
          const Divider(height: 1),

          // Dynamic Rows from Database/List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: submissions.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = submissions[index];
              return _buildTaskRow(item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskRow(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Row(
        children: [
          // Employee
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(data['image']),
                ),
                const SizedBox(width: 10),
                Text(data['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
          // Task Title
          Expanded(flex: 2, child: Text(data['task'], style: const TextStyle(fontSize: 13, color: Colors.black87))),
          // Department
          Expanded(flex: 1, child: Text(data['dept'], style: const TextStyle(fontSize: 13, color: Colors.black54))),
          // Timeline
          Expanded(flex: 2, child: Text(data['time'], style: const TextStyle(fontSize: 13, color: Colors.black54))),
          // Status Chip
          Expanded(flex: 1, child: _StatusChip(status: data['status'])),
          // Action Button
          Expanded(
            flex: 1,
            child: _ActionButton(status: data['status']),
          ),
        ],
      ),
    );
    
  }
  
}
 // UI HELPER


class _LabelText extends StatelessWidget {
  final String text;
  const _LabelText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11, 
        fontWeight: FontWeight.w700, 
        // This is the specific greyish-blue used in professional dashboards
        color: Color(0xFF94A3B8), 
        letterSpacing: 0.5,
      ),
    );
  }
}
class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor = const Color(0xFFE0E0E0);
    Color textColor = Colors.black54;

    if (status == "REVIEW NEEDED") {
      bgColor = const Color(0xFFFDE7D3);
      textColor = const Color(0xFFD48B46);
    } else if (status == "IN PROGRESS") {
      bgColor = const Color(0xFFD9EEF1);
      textColor = const Color(0xFF5D9BA4);
    } else if (status == "COMPLETED") {
      bgColor = const Color(0xFFE8E9EB);
      textColor = const Color(0xFF7E8489);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Text(status, textAlign: TextAlign.center, 
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: textColor)),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String status;
  const _ActionButton({required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isReview = status == "REVIEW NEEDED";
    return SizedBox(
      width: 25,
      height: 30,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isReview ? const Color(0xFF0C5D6B) : Colors.white,
          foregroundColor: isReview ? Colors.white : Colors.black87,
          elevation: 0,
          side: isReview ? BorderSide.none : const BorderSide(color: Colors.black12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(),
        ),
        child: Text(isReview ? "Review" : (status == "COMPLETED" ? "Logs" : "View"), 
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      ),
    );
  }
}