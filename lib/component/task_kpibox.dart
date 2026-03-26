import 'package:flutter/material.dart';

class TaskKpibox extends StatelessWidget {
  final String heading;
  final String total;
  const TaskKpibox({super.key, 
  required this.heading,
   required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(      
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      border: Border(left: BorderSide(color: Colors.brown,width: 4))
      ),
      child: Column(
        spacing: 10,
         mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading, style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF6F7A83),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),),
                 Text(total, style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),)
        ],
      ),
    );
  }
}