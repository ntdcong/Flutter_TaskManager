import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskHeader extends StatelessWidget {
  final TextEditingController _taskController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
