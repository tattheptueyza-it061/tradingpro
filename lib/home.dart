import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tradingcrypto/profile.dart';
import 'dart:convert';
import 'crypto_chart.dart'; // นำเข้าหน้ากราฟที่สร้างไว้

class HomePage extends StatefulWidget {
  final String username; // รับค่า username จากหน้าก่อนหน้า

  HomePage({required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> cryptoList = [];

  @override
  void initState() {
    super.initState();
    fetchCryptoData();
  }

  Future<void> fetchCryptoData() async {
    final response = await http.get(
      Uri.parse(
          'https://min-api.cryptocompare.com/data/top/mktcapfull?tsym=USD&limit=100'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        cryptoList = data['Data'];
      });
    } else {
      // Handle error
      print('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Practice Log',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF1E1E2C),
        iconTheme: IconThemeData(
          color: Colors.white, // เปลี่ยนสีของไอคอนลูกศรย้อนกลับที่นี่
        ),
      ),
      body: cryptoList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cryptoList.length,
              itemBuilder: (context, index) {
                final crypto = cryptoList[index];
                final name = crypto['CoinInfo']['Name'];
                final fullName = crypto['CoinInfo']['FullName'];
                final price =
                    crypto['RAW'] != null && crypto['RAW']['USD'] != null
                        ? crypto['RAW']['USD']['PRICE']
                        : 0.0; // หรือแสดงข้อความเช่น "N/A"
                final change =
                    crypto['RAW'] != null && crypto['RAW']['USD'] != null
                        ? crypto['RAW']['USD']['CHANGE24HOUR']
                        : 0.0; // หรือแสดงข้อความเช่น "N/A"
                final imageUrl = crypto['CoinInfo']['ImageUrl'] != null
                    ? 'https://www.cryptocompare.com${crypto['CoinInfo']['ImageUrl']}'
                    : ''; // ดึงรูปจากลิ้งฐานข้อมูล

                return Card(
                  color: Colors.grey[900],
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    onTap: () {
                      // นำทางไปยังหน้าแสดงกราฟเมื่อกดเลือกเหรียญ
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            print(
                                'Username before navigating to CryptoChartPage: ${widget.username}');
                            if (widget.username == null ||
                                widget.username.isEmpty) {
                              print(
                                  'Error: Username is null or empty in HomePage');
                              return Container(); // หรือแสดงข้อความเตือน
                            } else {
                              return CryptoChartPage(
                                cryptoName: name,
                                username: widget.username,
                              );
                            }
                          },
                        ),
                      );
                    },
                    leading: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            width: 40,
                            height: 40,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error, color: Colors.red);
                            },
                          )
                        : Icon(Icons.currency_bitcoin, color: Colors.orange),
                    title: Text(
                      fullName,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    subtitle: Text(
                      'ID: $name',
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: change >= 0 ? Colors.green : Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
                  floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(
                username:
                    widget.username, // ใช้ค่าจากการเรียกใช้งานที่ไม่เป็นค่าว่าง
              ),
            ),
          );
        },
        child: Icon(Icons.person),
        backgroundColor: Colors.yellow,
        tooltip: 'Profile',
      ),
    );
  }
}
