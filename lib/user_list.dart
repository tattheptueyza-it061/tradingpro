import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tradingcrypto/model/user_list_model.dart';
import 'dart:convert';
import 'admin_edit.dart'; // นำเข้าหน้า admin_edit ที่สร้างไว้

class UserListPage extends StatefulWidget {
  final String username;

  UserListPage({required this.username});
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<Map<String, dynamic>> userList = [];

  @override
  void initState() {
    super.initState();
    fetchUserList(); // เรียกใช้ฟังก์ชันที่นี่
  }

Future<void> fetchUserList() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos/1'));

  if (response.statusCode == 200) {
    try {
      setState(() {
        userList = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } catch (e) {
      print('Error parsing user list: $e');
    }
  } else {
    print('Failed to load user list. Status code: ${response.statusCode}');
  }
}

  // Future<void> fetchUserList() async {
  //   final response = await http.get(Uri.parse(
  //       'https://18ed-184-22-128-32.ngrok-free.app/get_user_list.php'));

  //   if (response.statusCode == 200) {
  //     try {
  //       print('Response body: ${response.body}'); // แสดงข้อมูลที่ได้จาก API
  //       List<dynamic> jsonList = json.decode(response.body);
  //       setState(() {
  //         List<User> userList = jsonList.map((json) => User.fromJson(json)).toList();

  //       });
  //     } catch (e) {
  //       print('Error parsing user list: $e');
  //     }
  //   } else {
  //     print('Failed to load user list. Status code: ${response.statusCode}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: userList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final user = userList[index];
                final username = user['user'] ??
                    'N/A'; // เปลี่ยนจาก 'username' เป็น 'user' ถ้าใช้คอลัมน์ 'user'

                return ListTile(
                  title: Text(username),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {
                      // ตรวจสอบข้อมูลก่อนส่งไปยังหน้าแก้ไข
                      if (user.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminEditPage(userData: user),
                          ),
                        );
                      } else {
                        print('Error: User data is empty');
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
