import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _taskController = TextEditingController();
  String _selectedStatus = 'All'; // Biến để lưu trạng thái lọc

  // Hàm thêm công việc mới
  void _addTask() async {
    String taskTitle = _taskController.text.trim();
    if (taskTitle.isNotEmpty) {
      FirebaseFirestore.instance.collection('tasks').add({
        'title': taskTitle,
        'status': 'Not Started',
        'createdAt': Timestamp.now(),
        'userId': FirebaseAuth.instance.currentUser!.uid,
      });
      _taskController.clear();
    }
  }

  // Hàm chỉnh sửa công việc
  void _editTask(String taskId, String taskTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(taskId: taskId, taskTitle: taskTitle),
      ),
    );
  }

  // Hàm xóa công việc
  void _deleteTask(String taskId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa công việc này?'),
          actions: [
            TextButton(
              child: Text('Hủy'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Xóa', style: TextStyle(color: Colors.red)),
              onPressed: () {
                FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Hàm cập nhật trạng thái công việc
  void _updateTaskStatus(String taskId, String status) {
    FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
      'status': status,
      'updatedAt': Timestamp.now(),
    });
  }

  // Hàm lấy màu sắc trạng thái công việc
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Not Started':
        return Colors.grey;
      case 'In Progress':
        return Colors.blue;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Hàm dịch trạng thái sang tiếng Việt
  String _translateStatus(String status) {
    switch (status) {
      case 'Not Started':
        return 'Chưa bắt đầu';
      case 'In Progress':
        return 'Đang thực hiện';
      case 'Completed':
        return 'Hoàn thành';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản Lý Công Việc'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Thêm công việc mới',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white24,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.white, size: 30),
                  onPressed: _addTask,
                ),
              ],
            ),
          ),
          // Dropdown lọc trạng thái
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: DropdownButton<String>(
              value: _selectedStatus,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStatus = newValue!;
                });
              },
              items: <String>['All', 'Not Started', 'In Progress', 'Completed']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              isExpanded: true,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tasks')
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .where(
                    'status',
                    isEqualTo: _selectedStatus == 'All' ? null : _selectedStatus,
                  )
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Lỗi khi tải công việc: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'Chưa có công việc nào',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                var tasks = snapshot.data!.docs;
                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    var task = tasks[index];
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        title: Text(
                          task['title'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Container(
                          margin: EdgeInsets.only(top: 8),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(task['status']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _translateStatus(task['status']),
                            style: TextStyle(
                              color: _getStatusColor(task['status']),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editTask(task.id, task['title']),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTask(task.id),
                            ),
                            PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert),
                              onSelected: (String status) {
                                _updateTaskStatus(task.id, status);
                              },
                              itemBuilder: (BuildContext context) {
                                return ['Not Started', 'In Progress', 'Completed']
                                    .map((status) {
                                  return PopupMenuItem<String>(
                                    value: status,
                                    child: Text(_translateStatus(status)),
                                  );
                                }).toList();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
