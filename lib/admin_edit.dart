import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminEditPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  AdminEditPage({required this.userData});

  @override
  _AdminEditPageState createState() => _AdminEditPageState();
}

class _AdminEditPageState extends State<AdminEditPage> {
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _outstandingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _statusController.text = widget.userData['status'];
    _outstandingController.text = widget.userData['outstanding_balance'];
  }

  Future<void> updateData(String field, String newValue) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.101/update_user_data.php'),
      body: {
        'user': widget.userData['user'],
        'field': field,
        'value': newValue,
      },
    );

    if (response.statusCode == 200) {
      print('Update successful');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('สำเร็จ'),
          content: Text('บันทึกการแก้ไขสำเร็จ'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('ตกลง'),
            ),
          ],
        ),
      );
    } else {
      print('Failed to update data');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('ข้อผิดพลาด'),
          content: Text('การบันทึกการแก้ไขล้มเหลว'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('ตกลง'),
            ),
          ],
        ),
      );
    }
  }

  void showEditDialog(String field, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $field'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'New $field',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                // อัปเดตค่าใหม่ใน UI
                widget.userData[field] = controller.text;
              });
              updateData(
                  field, controller.text); // เรียกใช้ฟังก์ชันอัปเดตในฐานข้อมูล
              Navigator.of(context).pop();
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User: ${widget.userData['user']}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.account_circle, size: 80, color: Colors.white),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                widget.userData['user'],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(height: 5),
            Center(
              child: Text(
                '${widget.userData['first_name']} ${widget.userData['last_name']}',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 20),
            buildProfileItem(Icons.account_balance_wallet, 'Account Balance',
                '\$${widget.userData['account_balance']}'),
            buildProfileItem(
                Icons.phone, 'Phone Number', widget.userData['phone_number']),
            buildProfileItem(Icons.account_balance, 'Bank Name',
                widget.userData['bank_name']),
            buildProfileItem(Icons.account_box, 'Bank Account Number',
                widget.userData['bank_account_number']),
            buildEditableProfileItem(Icons.info, 'Status', _statusController),
            buildEditableProfileItem(Icons.attach_money, 'Outstanding Balance',
                _outstandingController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // โค้ดการบันทึกการแก้ไข
                updateData('status', _statusController.text);
                updateData('outstanding_balance', _outstandingController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'บันทึกการแก้ไข',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileItem(IconData icon, String title, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value),
      ),
    );
  }

  Widget buildEditableProfileItem(
      IconData icon, String title, TextEditingController controller) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(controller.text),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.orange),
              onPressed: () => showEditDialog(title, controller),
            ),
          ],
        ),
      ),
    );
  }
}
