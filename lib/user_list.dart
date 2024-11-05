import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  final response = await http.get(Uri.parse('http://192.168.1.101/get_user_list.php'));


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
