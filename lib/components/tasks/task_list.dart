// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskList extends StatelessWidget {
  final String selectedStatus;

  const TaskList({required this.selectedStatus});

  // Lấy màu trạng thái
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

  // Dịch trạng thái sang tiếng Việt
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

  // Hộp thoại xác nhận xóa
  void _showDeleteConfirmation(BuildContext context, DocumentSnapshot task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text('Xác nhận xóa'),
          ],
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa công việc này? Hành động này không thể hoàn tác.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Hủy',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('tasks')
                  .doc(task.id)
                  .delete();
              Navigator.pop(context);
            },
            child: Text('Xóa'),
          ),
        ],
      ),
    );
  }

  // Hộp thoại chỉnh sửa công việc
  void _showEditDialog(BuildContext context, DocumentSnapshot task) {
    TextEditingController _editController =
        TextEditingController(text: task['title']);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Chỉnh sửa công việc',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _editController,
                decoration: InputDecoration(
                  labelText: 'Tiêu đề công việc',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 20, horizontal: 20), // Tăng kích thước padding
                ),
                minLines: 1, // Số dòng tối thiểu
                maxLines: 5, // Số dòng tối đa (có thể tăng)
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Hủy'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      String newTitle = _editController.text.trim();
                      if (newTitle.isNotEmpty) {
                        await FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(task.id)
                            .update({'title': newTitle});
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Lưu'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm cập nhật trạng thái
  void _updateStatus(DocumentSnapshot task, String newStatus) async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(task.id)
        .update({'status': newStatus});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('status',
              isEqualTo: selectedStatus == 'All'
                  ? null
                  : selectedStatus) // Lọc theo trạng thái
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
              child: Text('Lỗi khi tải công việc: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'Chưa có công việc nào',
              style: TextStyle(color: Colors.grey, fontSize: 16),
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
              elevation: 4,
              margin: EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                title: Text(
                  task['title'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.circle,
                          size: 12, color: _getStatusColor(task['status'])),
                      SizedBox(width: 8),
                      Text(
                        _translateStatus(task['status']),
                        style: TextStyle(
                            fontSize: 14,
                            color: _getStatusColor(task['status'])),
                      ),
                    ],
                  ),
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditDialog(context, task);
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(context, task);
                    } else {
                      _updateStatus(task, value);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Chỉnh sửa'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Xóa'),
                        ],
                      ),
                    ),
                    PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'Not Started',
                      child: Text('Chưa bắt đầu'),
                    ),
                    PopupMenuItem(
                      value: 'In Progress',
                      child: Text('Đang thực hiện'),
                    ),
                    PopupMenuItem(
                      value: 'Completed',
                      child: Text('Hoàn thành'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
