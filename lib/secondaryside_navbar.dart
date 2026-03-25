import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class SecondarysideNavbar extends StatelessWidget {
  const SecondarysideNavbar({super.key});

  Widget _item(
    BuildContext context, {
    required String route,
    required IconData icon,
    required String label,
  }) {
    // final currentPath = GoRouterState.of(context).uri.path;
    final currentPath = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.uri.path;

    final isSelected = currentPath == route;

    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal:5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(140, 230, 249, 246)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? const Border(
                  right: BorderSide(
                    color: Color(0xFF4C8C86),
                    width: 3,
                  ),
                )
              : null,
          // boxShadow: isSelected
          //     ? const [
          //         BoxShadow(
          //           color: Color.fromARGB(30, 0, 0, 0),
          //           blurRadius: 6,
          //           offset: Offset(0, 2),
          //         ),
          //       ]
          //     : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                    
                  ? Colors.blueGrey
                  : Colors.grey[700],
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.blueGrey
                    : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color.fromARGB(148, 255, 255, 255),
      
      ),
      child: Column(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header / Brand
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                Text(
                  "The Worksplace",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "HR Administration",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Navigation Items
           _item(
            context,
            route: '/home',
            icon: Icons.home,
            label: "Staff",
          ),
          _item(
            context,
            route: '/Payroll',
            icon: Icons.payment,
            label: "Payroll",
          ),
            _item(
            context,
            route: '/Attendance',
            icon: Icons.calendar_today,
            label: "Attendance",
          ),
            _item(
            context,
            route: '/Task',
            icon: Icons.task,
            label: "Task",
          ),
          SizedBox(height: 15,),
        
          
         
          const Spacer(),
Divider(
  endIndent: 1,
  indent: 1,
  color: Colors.white,
  
),
             _item(
            context,
            route: '/settings',
            icon: Icons.settings,
            label: "Settings",
          ),
           _item(
            context,
            route: '/Support',
            icon: Icons.support_agent,
            label: "Support",
          ),
          SizedBox(height: 10,),
Row(
  children: [
    PopupMenuButton<String>(
      tooltip: 'Account',
      onSelected: (value) async {
        if (value == 'logout') {
          await FirebaseAuth.instance.signOut();
          if (!context.mounted) return;
          context.go('/login');
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'logout',
          child: Text('Logout'),
        ),
      ],
      child: const CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(
          'https://www.shutterstock.com/image-vector/user-icon-human-person-symbol-260nw-1051033475.jpg',
        ),
      ),
    ),
    const SizedBox(width: 8),
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'UserName ',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          'Admin',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    )
  ],
)
        ],
      ),
    );
  }
}





  
