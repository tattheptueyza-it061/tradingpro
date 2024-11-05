

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tradingcrypto/firebase_option.dart';
import 'login.dart'; // ตรวจสอบให้แน่ใจว่าคุณนำเข้า LoginPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: firebaseOptions,
  );

  runApp(MyApp(username: '',)); // เรียกใช้ MyApp โดยไม่ส่ง username
}


class MyApp extends StatelessWidget {
  final String username;

  MyApp({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trading App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: LoginPage(username: username), // ส่ง username ไปยัง LoginPage
    );
  }
}

