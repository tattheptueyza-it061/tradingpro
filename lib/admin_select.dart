import 'package:flutter/material.dart';
import 'package:tradingcrypto/admin_dashboard.dart';
import 'package:tradingcrypto/admin_edit.dart';
import 'package:tradingcrypto/profile.dart';
import 'package:tradingcrypto/user_list.dart';

class AdminSelectPage extends StatefulWidget {
  final String username; // เพิ่มตัวแปรนี้เพื่อต้อนรับ username

  AdminSelectPage({Key? key, required this.username}) : super(key: key);

  @override
  _AdminSelectPageState createState() => _AdminSelectPageState();
}

class _AdminSelectPageState extends State<AdminSelectPage> {
  final TextEditingController _usernameController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF1E1E2C),
        iconTheme: IconThemeData(
          color: Colors.white, // เปลี่ยนสีของไอคอนลูกศรย้อนกลับที่นี่
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome, Admin',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            _buildMenuButton(
              context,
              'ยอดค้าง',
              Icons.attach_money,
              Colors.blue,
              () {
                Navigator.push(
                  context,
                  // MaterialPageRoute(builder: (context) => AdminDashboard()), // ตรวจสอบให้แน่ใจว่าได้นำเข้า AdminDashboard ด้วย
                  MaterialPageRoute(builder: (context) => UserListPage(username: widget.username
                  ,)),
                );
              },
            ),
            SizedBox(height: 20),
            _buildMenuButton(
              context,
              'สมัคร',
              Icons.person_add,
              Colors.green,
              () {
                // ใส่ฟังก์ชันหรือการนำทางเมื่อกดปุ่มนี้
                Navigator.push(
                  context,
                  // MaterialPageRoute(builder: (context) => AdminDashboard()), // ตรวจสอบให้แน่ใจว่าได้นำเข้า AdminDashboard ด้วย
                  MaterialPageRoute(builder: (context) => AdminDashboard()),
                );
              },
            ),
            SizedBox(height: 20),
            // _buildMenuButton(
            //   context,
            //   'แก้ไขข้อมูลลูกค้า',
            //   Icons.edit,
            //   Colors.orange,
            //   () {
            //     String username =
            //         _usernameController.text; // รับค่าจาก TextEditingController

            //     // ตรวจสอบให้แน่ใจว่า username ไม่เป็นค่าว่าง
            //     if (username.isNotEmpty) {
            //       // ส่งข้อมูล username ไปยังหน้า AdminEditPage
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => AdminEditPage(
            //             userData: {
            //               'user':
            //                   username, // ส่ง username หรือข้อมูลอื่นที่จำเป็น
            //               // เพิ่มข้อมูลอื่น ๆ ที่ต้องการใช้ในหน้า AdminEditPage
            //             },
            //           ),
            //         ),
            //       );
            //     } else {
            //       // แสดงข้อความแจ้งเตือนหาก username เป็นค่าว่าง
            //       showDialog(
            //         context: context,
            //         builder: (context) => AlertDialog(
            //           title: Text('Error'),
            //           content: Text('กรุณาใส่ชื่อผู้ใช้ก่อนดำเนินการ'),
            //           actions: [
            //             TextButton(
            //               onPressed: () => Navigator.of(context).pop(),
            //               child: Text('OK'),
            //             ),
            //           ],
            //         ),
            //       );
            //     }
            //   },
            // ),
            // SizedBox(height: 20),
            _buildMenuButton(
              context,
              'อื่นๆ',
              Icons.more_horiz,
              Colors.grey,
              () {
                // ใส่ฟังก์ชันหรือการนำทางเมื่อกดปุ่มนี้
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: Colors.white),
          SizedBox(width: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
