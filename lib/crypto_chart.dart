import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tradingcrypto/profile.dart';

class CryptoChartPage extends StatefulWidget {
  final String cryptoName;

  final String username;

  CryptoChartPage({required this.cryptoName, required this.username});

  @override
  _CryptoChartPageState createState() => _CryptoChartPageState();
}

class _CryptoChartPageState extends State<CryptoChartPage> {
  List<CandleData> _chartData = [];
  List<dynamic> newsList = [];
  double currentPrice = 2126.20; // ค่าเริ่มต้น
  double priceChange = 30.0; // การเปลี่ยนแปลงราคา
  double percentageChange = 0.72; // เปอร์เซ็นต์การเปลี่ยนแปลง

  @override
  void initState() {
    super.initState();
    fetchChartData();
    fetchNewsData();
  }
//   @override
// void initState() {
//   super.initState();
//   print('Username in CryptoChartPage: ${widget.username}');
//   if (widget.username == null || widget.username.isEmpty) {
//     print('Error: Username is null or empty in CryptoChartPage');
//   }
// }

  Future<void> fetchChartData() async {
    final response = await http.get(Uri.parse(
        'https://min-api.cryptocompare.com/data/v2/histoday?fsym=${widget.cryptoName}&tsym=USD&limit=30'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<CandleData> loadedData = [];
      for (var item in data['Data']['Data']) {
        loadedData.add(CandleData(
          time: DateTime.fromMillisecondsSinceEpoch(item['time'] * 1000),
          open: item['open'].toDouble(),
          high: item['high'].toDouble(),
          low: item['low'].toDouble(),
          close: item['close'].toDouble(),
        ));
      }
      setState(() {
        _chartData = loadedData;
        currentPrice = loadedData.last.close;
        priceChange = 30.0;
        percentageChange = 0.72;
      });
    } else {
      print('Failed to load chart data');
    }
  }

  Future<void> fetchNewsData() async {
    final response = await http.get(Uri.parse(
        'https://min-api.cryptocompare.com/data/v2/news/?categories=${widget.cryptoName}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        newsList = data['Data'].take(5).toList(); // จำกัดข่าวสารไว้ที่ 5-6 ข่าว
      });
    } else {
      print('Failed to load news data');
    }
  }

  void _showOrderForm(String action) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.cryptoName}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Lots',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                ExpansionTile(
                  title: Text('Order Settings'),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text('Market Order'),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text('Buy Limit'),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text('Buy Stop'),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Take Profit',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {},
                    ),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Stop Loss',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {},
                    ),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle confirm buy or sell action
                    Navigator.pop(context);
                  },
                  child: Text('Confirm $action'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        action == 'BUY' ? Colors.green : Colors.red,
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.cryptoName} Chart',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF1E1E2C),
        iconTheme: IconThemeData(
          color: Colors.white, // เปลี่ยนสีของไอคอนลูกศรย้อนกลับที่นี่
        ),
      ),
      body: _chartData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹ ${currentPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${priceChange > 0 ? '+' : ''}${priceChange.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: priceChange > 0
                                          ? Colors.green
                                          : Colors.red),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '(${percentageChange > 0 ? '+' : ''}${percentageChange.toStringAsFixed(2)}%)',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: percentageChange > 0
                                          ? Colors.green
                                          : Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('NSE'),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('BSE'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 300,
                    padding: EdgeInsets.all(16.0),
                    child: SfCartesianChart(
                      primaryXAxis: DateTimeAxis(),
                      primaryYAxis: NumericAxis(),
                      series: <CandleSeries>[
                        CandleSeries<CandleData, DateTime>(
                          dataSource: _chartData,
                          xValueMapper: (CandleData data, _) => data.time,
                          lowValueMapper: (CandleData data, _) => data.low,
                          highValueMapper: (CandleData data, _) => data.high,
                          openValueMapper: (CandleData data, _) => data.open,
                          closeValueMapper: (CandleData data, _) => data.close,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showOrderForm('SELL');
                          },
                          child: Text(
                            'SELL',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize: Size(150, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _showOrderForm('BUY');
                          },
                          child: Text(
                            'BUY',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: Size(150, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(thickness: 2, height: 30),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'News',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        ...newsList.map((news) {
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(news['title']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(news['body']),
                                  SizedBox(height: 5),
                                  Text(
                                    'Source: ${news['source']}',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              onTap: () {
                                // เปิดลิงก์ข่าว
                                print('Open news link: ${news['url']}');
                              },
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
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

class CandleData {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;

  CandleData({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });
}
