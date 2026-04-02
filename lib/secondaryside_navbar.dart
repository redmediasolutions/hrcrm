import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class SecondarysideNavbar extends StatefulWidget {
  const SecondarysideNavbar({super.key});

  @override
  State<SecondarysideNavbar> createState() => _SecondarysideNavbarState();
}

class _SecondarysideNavbarState extends State<SecondarysideNavbar> {
  String? _optimisticRoute;

  Widget item(
    BuildContext context, {
    required String route,
    required IconData icon,
    required String label,
  }) {
    // final currentPath = GoRouterState.of(context).uri.path;
    final currentPath = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.uri.path;

    final normalizedCurrent = currentPath.toLowerCase();
    final normalizedRoute = route.toLowerCase();
    final isSelectedByRoute =
        normalizedCurrent == normalizedRoute ||
        normalizedCurrent.startsWith('$normalizedRoute/');
    final isSelectedByOptimistic =
        _optimisticRoute?.toLowerCase() == normalizedRoute;
    final isSelected = _optimisticRoute != null
        ? isSelectedByOptimistic
        : isSelectedByRoute;

    return InkWell(
      onTapDown: (_) {
        if (_optimisticRoute != route) {
          setState(() => _optimisticRoute = route);
        }
      },
      onTapCancel: () {
        if (_optimisticRoute != null) {
          setState(() => _optimisticRoute = null);
        }
      },
      onTap: () {
        if (_optimisticRoute != route) {
          setState(() => _optimisticRoute = route);
        }
        context.go(route);
      },
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
    final currentPath = GoRouter.of(
      context,
    ).routerDelegate.currentConfiguration.uri.path;
    if (_optimisticRoute != null) {
      final normalizedCurrent = currentPath.toLowerCase();
      final normalizedOptimistic = _optimisticRoute!.toLowerCase();
      final matchesOptimistic =
          normalizedCurrent == normalizedOptimistic ||
          normalizedCurrent.startsWith('$normalizedOptimistic/');
      if (matchesOptimistic) {
        _optimisticRoute = null;
      }
    }
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? "";
    final displayName = user?.displayName;
    final derivedName = email.isNotEmpty ? email.split('@').first : "User";
    final name = (displayName != null && displayName.trim().isNotEmpty)
        ? displayName.trim()
        : derivedName;

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
          item(
            context,
            route: '/home',
            icon: Icons.home,
            label: "Staff",
          ),
          item(
            context,
            route: '/payroll',
            icon: Icons.payment,
            label: "Payroll",
          ),
            item(
            context,
            route: '/attendance',
            icon: Icons.calendar_today,
            label: "Attendance",
          ),
            item(
            context,
            route: '/reports',
            icon: Icons.task,
            label: "Reports",
          ),
          SizedBox(height: 15,),
        
          
         
          const Spacer(),
Divider(
  endIndent: 1,
  indent: 1,
  color: Colors.white,
  
),
          //    item(
          //   context,
          //   route: '/settings',
          //   icon: Icons.settings,
          //   label: "Settings",
          // ),
          //  item(
          //   context,
          //   route: '/support',
          //   icon: Icons.support_agent,
          //   label: "Support",
          // ),
          SizedBox(height: 10,),
Container(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  decoration: BoxDecoration(
    color: const Color(0xFFF7F4F9),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: const Color(0xFFE6DCE9)),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "ADMIN",
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color:  Colors.blueGrey,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
      ),
      const SizedBox(height: 6),
      Row(
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.blueGrey, Color.fromARGB(255, 37, 64, 83)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : "U",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            // Text(
            //   email.isNotEmpty ? email : 'Admin',
            //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            //         color: Colors.grey,
            //         fontSize: 12,
            //         fontWeight: FontWeight.w500,
            //       ),
           // ),
          ],
        ),
      ),
      PopupMenuButton<String>(
        tooltip: 'Account',
        color: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        onSelected: (value) async {
          if (value == 'logout') {
            await FirebaseAuth.instance.signOut();
            if (!context.mounted) return;
            context.go('/login');
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'logout',
            child: Container(
              width: 220,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFD7FF)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A0B3D91),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: const [
                  Icon(Icons.logout, color: Colors.blueGrey),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF6B8FE0)),
                ],
              ),
            ),
          ),
        ],
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.more_vert, size: 20, color: Color(0xFF1B4DB1)),
        ),
      ),
    ],
  ),
    ],
  ),
)
        ],
      ),
    );
  }
}





  
