import 'package:flutter/material.dart';

class StatusFilter extends StatelessWidget {
  final String selectedStatus;
  final Function(String) onStatusChange;

  const StatusFilter({
    required this.selectedStatus,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    // Bản đồ chuyển đổi giữa tiếng Anh (lưu trên database) và tiếng Việt (hiển thị giao diện)
    final Map<String, String> statusMap = {
      'All': 'Tất cả',
      'Not Started': 'Chưa bắt đầu',
      'In Progress': 'Đang thực hiện',
      'Completed': 'Hoàn thành',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            topLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: DropdownButton<String>(
          value: selectedStatus,
          onChanged: (String? newValue) {
            onStatusChange(
                newValue!); // Trả về trạng thái tiếng Anh cho database
          },
          items: statusMap.keys.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                statusMap[value]!, // Hiển thị tiếng Việt trên giao diện
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            );
          }).toList(),
          isExpanded: true,
          underline: SizedBox(),
          icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
        ),
      ),
    );
  }
}
