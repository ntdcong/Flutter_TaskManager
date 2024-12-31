import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nhomba_project_flutter/firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/user_profile_screen.dart'; // Import trang thông tin người dùng

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý Công Việc',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FirebaseAuth.instance.currentUser != null ? HomeScreen() : LoginScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/profile': (context) => UserProfileScreen(), // Thêm route cho trang thông tin người dùng
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
