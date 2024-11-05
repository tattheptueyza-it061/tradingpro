import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final String username; // เปลี่ยนจาก userId เป็น username

  ProfilePage({required this.username});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> userData = {};
  final TextEditingController _withdrawAmountController =
      TextEditingController();

  Future<void> fetchUserData() async {
    final response = await http.get(Uri.parse(
        'http://184.22.128.32/get_user_data.php?user=${widget.username}'));
    if (response.statusCode == 200) {
      try {
        setState(() {
          userData = json.decode(response.body);
        });
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    } else {
      print('Failed to load user data. Status code: ${response.statusCode}');
    }
  }

  Future<void> withdrawAmount() async {
    final double currentBalance = double.parse(userData['account_balance']);
    final double withdrawAmount =
        double.tryParse(_withdrawAmountController.text) ?? 0.0;

    if (withdrawAmount <= 0 || withdrawAmount > currentBalance) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Errorss'),
          content: Text(withdrawAmount <= 0
              ? 'Please enter a valid amount.'
              : 'Insufficient balance.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK')),
          ],
        ),
      );
      return;
    }

    final newBalance = currentBalance - withdrawAmount;

    final response = await http.post(
      Uri.parse('http://184.22.128.32/update_balance.php'),
      body: {
        'username': widget.username,
        'new_balance': newBalance.toString(),
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody['status'] == 'success') {
        setState(() {
          userData['account_balance'] = newBalance.toString();
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Withdrawal successful.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK')),
            ],
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: Text('Edit Profile', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: userData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Icon(
                    Icons.account_circle, // แทนที่ด้วยไอคอนที่คุณต้องการ
                    size: 100, // ขนาดของไอคอน
                    color: Colors.yellow, // สีของไอคอน
                  ),
                  SizedBox(height: 20),
                  buildProfileItem(
                      'Username', userData['user'], Icons.account_circle),
                  buildProfileItem(
                      'Full Name',
                      '${userData['first_name']} ${userData['last_name']}',
                      Icons.person),
                  buildProfileItem(
                      'Phone Number', userData['phone_number'], Icons.phone),
                  buildProfileItem('Bank Name', userData['bank_name'],
                      Icons.account_balance),
                  buildProfileItem('Bank Account Number',
                      userData['bank_account_number'], Icons.credit_card),
                  buildProfileItem('Status', userData['status'], Icons.info),
                  buildProfileItem(
                      'Account Balance',
                      '\$${userData['account_balance']}',
                      Icons.account_balance_wallet),
                  buildProfileItem(
                      'Outstanding Balance',
                      '\$${userData['outstanding_balance']}',
                      Icons.attach_money),
                  SizedBox(height: 30,),
                  buildWithdrawSection(),
                ],
              ),
            ),
    );
  }

  Widget buildProfileItem(String title, String value, IconData icon) {
    return Card(
      color: Colors.grey[900],
      child: ListTile(
        leading: Icon(icon, color: Colors.yellow[700]),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(
          value,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildWithdrawSection() {
    return Column(
      children: [
        Divider(thickness: 2, height: 30),
        Text('ทำรายการถอนเงิน',style: TextStyle(fontSize: 20,color: Colors.green),),
        SizedBox(height: 10),
        TextField(
          controller: _withdrawAmountController,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'จำนวนเงินที่ต้องการถอน',
            labelStyle: TextStyle(color: Colors.yellow[700]),
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: withdrawAmount,
          child: Text('ถอนเงินเงิน', style: TextStyle(color: Colors.black)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.yellow[700],
            padding: EdgeInsets.symmetric(vertical: 15,horizontal: 60),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
