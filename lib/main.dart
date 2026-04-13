import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(PurnovApp());

class PurnovApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF0A0A0A),
        cardColor: Color(0xFF161616),
        primaryColor: Color(0xFFFFD700),
      ),
      home: SniperScreen(),
    );
  }
}

class SniperScreen extends StatefulWidget {
  @override
  _SniperScreenState createState() => _SniperScreenState();
}

class _SniperScreenState extends State<SniperScreen> {
  List alerts = [];
  final String url = "http://ТВОЙ_АДРЕС_ТУННЕЛЯ/api/data"; // Сюда впишешь адрес из EXE

  Future update() async {
    try {
      var r = await http.get(Uri.parse(url));
      if (r.statusCode == 200) setState(() => alerts = json.decode(r.body)['alerts']);
    } catch (e) { print(e); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VSA SNIPER PREMIUM", style: TextStyle(color: Color(0xFFFFD700), letterSpacing: 2)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: update,
        child: ListView.builder(
          itemCount: alerts.length,
          itemBuilder: (context, i) {
            bool isConfirmed = alerts[i]['text'].contains("ПОДТВЕРЖДЕН");
            return Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: isConfirmed ? Colors.amber : Colors.red, width: 1),
                borderRadius: BorderRadius.circular(15)
              ),
              child: ListTile(
                title: Text(alerts[i]['asset'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                subtitle: Text(alerts[i]['text']),
                trailing: Text(alerts[i]['time'], style: TextStyle(color: Colors.grey)),
              ),
            );
          },
        ),
      ),
    );
  }
}