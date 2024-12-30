import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Đăng ký người dùng mới
  Future<String?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user?.uid; // Trả về userId nếu đăng ký thành công
    } on FirebaseAuthException catch (e) {
      return e.message; // Trả về lỗi nếu có
    }
  }

  // Đăng nhập người dùng
  Future<String?> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user?.uid; // Trả về userId nếu đăng nhập thành công
    } on FirebaseAuthException catch (e) {
      return e.message; // Trả về lỗi nếu có
    }
  }

  // Đăng xuất người dùng
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Kiểm tra xem người dùng có đăng nhập hay không
  Stream<User?> get user => _auth.authStateChanges();
}
