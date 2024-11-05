import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tradingcrypto/admin_select.dart';
import 'dart:convert';

import 'package:tradingcrypto/home.dart';

class LoginPage extends StatefulWidget {
  final String username; // เพิ่มตัวแปรนี้เพื่อต้อนรับ username

  LoginPage({Key? key, required this.username}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late String username;

  @override
  void initState() {
    super.initState();
    username = ''; // กำหนดค่าเริ่มต้นให้ username
  }

Future<void> _login() async {
  // ตรวจสอบว่าชื่อผู้ใช้และรหัสผ่านเป็น admin
  if ((_usernameController.text == 'admin' && _passwordController.text == 'admin123') ||
      (_usernameController.text == 'adminyee' && _passwordController.text == 'adminyee123') ||
      (_usernameController.text == 'adminbell' && _passwordController.text == 'adminbell123')) {
    // เปลี่ยนหน้าไปยัง AdminSelectPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminSelectPage(
          username: _usernameController.text, // ส่งค่าชื่อผู้ใช้ไปยัง AdminSelectPage
        ),
      ),
    );
  } else {
    // ถ้าไม่ใช่ admin ให้ทำการส่งข้อมูลไปตรวจสอบที่ server
    final response = await http.post(
      Uri.parse('http://184.22.128.32/login.php'),
      body: {
        'username': _usernameController.text,
        'password': _passwordController.text,
      },
    );

    final data = json.decode(response.body);
    if (data['status'] == 'success') {
      // เปลี่ยนหน้าไปยัง HomePage เมื่อเข้าสู่ระบบสำเร็จ
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            username: _usernameController.text, // ส่งค่าจาก TextEditingController
          ),
        ),
      );
    } else {
      // แสดงข้อความแจ้งข้อผิดพลาดเมื่อเข้าสู่ระบบไม่สำเร็จ
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Invalid username or password'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E2C), // สีพื้นหลังเข้ม
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logotrading.png',
                  height: 250, // เพิ่มขนาดความสูง
                  width: 250, // กำหนดความกว้างเพิ่มถ้าต้องการ
                  fit: BoxFit
                      .contain, // ปรับการแสดงผลของรูปให้ขยายเต็มพื้นที่ที่กำหนด
                ),
                SizedBox(height: 20),
                Text(
                  'Welcome to Trading',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Sign in to your account',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.person, color: Colors.grey[400]),
                    filled: true,
                    fillColor: Color(0xFF2A2D3E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.lock, color: Colors.grey[400]),
                    filled: true,
                    fillColor: Color(0xFF2A2D3E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: Text(
                    'SIGN IN',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // TextButton(
                //   onPressed: () {
                //     // Handle "Create Account" logic
                //   },
                //   child: Text.rich(
                //     TextSpan(
                //       text: "Don't have an account? ",
                //       style: TextStyle(color: Colors.white),
                //       children: [
                //         TextSpan(
                //           text: 'Create Account',
                //           style: TextStyle(color: Colors.green),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
