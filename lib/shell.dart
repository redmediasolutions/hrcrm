
import 'package:flutter/material.dart';
import 'package:red_hrcrm/secondaryside_navbar.dart';



class ShellPage extends StatelessWidget {
  final Widget child;
  final Widget? secondarySidebar;

  const ShellPage({
    super.key,
    required this.child,
    this.secondarySidebar,
  });

  @override
  Widget build(BuildContext context) {
     

    return Scaffold(
      
      backgroundColor: const Color(0xFFF5F5F7),
      body: Row(
        children: [
          // Primary sidebar (ONCE)
         
         
           const SizedBox(
            width: 300,
            child: SecondarysideNavbar(),
          ),

          // Secondary sidebar (optional)
          if (secondarySidebar != null)
            Container(
              width: 300,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  right: BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
              child: secondarySidebar,
            ),

          Expanded(child: child),
        ],
      ),
    );
  }
}