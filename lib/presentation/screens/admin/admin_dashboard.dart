import 'package:flutter/material.dart';
import 'package:loginsignup/presentation/screens/admin/users_management.dart';
import 'package:loginsignup/presentation/screens/admin/posts_management.dart';
import 'package:loginsignup/data/local/user_storage.dart';
import 'package:loginsignup/presentation/screens/auth/login_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const UsersManagement(),
    const PostsManagement(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await UserStorage.clearUser();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyLogin()),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: Colors.grey[100],
            selectedIconTheme: const IconThemeData(color: Colors.red),
            selectedLabelTextStyle: const TextStyle(color: Colors.red),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.people),
                selectedIcon: Icon(Icons.people),
                label: Text('Users'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.post_add),
                selectedIcon: Icon(Icons.post_add),
                label: Text('Posts'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Main content
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}
