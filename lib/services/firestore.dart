import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class FirestoreService {
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');

  // Thêm công việc vào collection 'tasks'
  Future<void> addTask(String taskTitle) async {
    await FirebaseFirestore.instance.collection('tasks').add({
      'title': taskTitle,
      'status': 'Not Started', // Trạng thái mặc định
      'category': 'Personal',  // Loại công việc mặc định
      'createdAt': Timestamp.now(),
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  // Thêm ghi chú mới vào Firestore
  Future<void> addNote(String text, File? imageFile) async {
    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await _uploadImage(imageFile);
    }
    await notesCollection.add({
      'note': text,
      'imageUrl': imageUrl ?? '', // Nếu không có ảnh, giá trị là chuỗi rỗng
    });
  }

  // Cập nhật ghi chú
  Future<void> updateNote(String id, String text, File? imageFile) async {
    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await _uploadImage(imageFile);
    }
    await notesCollection.doc(id).update({
      'note': text,
      'imageUrl': imageUrl ?? '', // Nếu không có ảnh, giá trị là chuỗi rỗng
    });
  }

  // Xóa ghi chú
  Future<void> deleteNote(String id) async {
    await notesCollection.doc(id).delete();
  }

  // Lấy luồng dữ liệu ghi chú
  Stream<QuerySnapshot> getNotesStream() {
    return notesCollection.snapshots();
  }

  // Tải ảnh lên Firebase Storage và trả về URL của ảnh
  Future<String> _uploadImage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = FirebaseStorage.instance.ref().child('notes/$fileName');
    UploadTask uploadTask = storageRef.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}
