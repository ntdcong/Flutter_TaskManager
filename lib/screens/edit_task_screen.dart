import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;
  final String taskTitle;

  EditTaskScreen({required this.taskId, required this.taskTitle});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.taskTitle);
  }

  void _updateTask() async {
    String updatedTitle = _titleController.text.trim();
    if (updatedTitle.isNotEmpty) {
      FirebaseFirestore.instance.collection('tasks').doc(widget.taskId).update({
        'title': updatedTitle,
        'updatedAt': Timestamp.now(),
      });
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chỉnh Sửa Công Việc')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Tiêu đề công việc'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTask,
              child: Text('Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }
}
