// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nhomba_project_flutter/components/tasks/task_list.dart';
import '../components/tasks/status_filter.dart';
import '../components/tasks/task_header.dart';
import 'package:nhomba_project_flutter/widgets/app_drawer.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedStatus = 'All'; // Trạng thái lọc

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'Chưa có';

    return Scaffold(
      appBar: AppBar(
        title: Text('Quản Lý Công Việc'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      drawer: AppDrawer(userEmail: userEmail), // Thêm AppDrawer vào Drawer
      body: Column(
        children: [
          // Header (TextField và nút Thêm)
          TaskHeader(),
          // Dropdown lọc trạng thái
          StatusFilter(
            selectedStatus: _selectedStatus,
            onStatusChange: (newValue) {
              setState(() {
                _selectedStatus = newValue;
              });
            },
          ),
          // Danh sách công việc
          Expanded(
            child: TaskList(selectedStatus: _selectedStatus),
          ),
        ],
      ),
    );
  }
}
