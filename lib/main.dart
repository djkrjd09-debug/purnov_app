import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

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
  // Твоя новая рабочая ссылка через Cloudflare
  final String url = "https://hiking-words-knee-agencies.trycloudflare.com/levels";

  @override
  void initState() {
    super.initState();
    update();
    // Автообновление каждые 30 секунд, чтобы не дергать экран вручную
    Timer.periodic(Duration(seconds: 30), (timer) => update());
  }

  Future<void> update() async {
    try {
      var r = await http.get(Uri.parse(url));
      if (r.statusCode == 200) {
        setState(() {
          alerts = json.decode(r.body)['alerts'];
        });
      }
    } catch (e) {
      print("Ошибка связи: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VSA SNIPER PREMIUM", 
          style: TextStyle(color: Color(0xFFFFD700), letterSpacing: 2, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.refresh, color: Colors.amber), onPressed: update)
        ],
      ),
      body: RefreshIndicator(
        onRefresh: update,
        child: alerts.isEmpty 
          ? Center(child: Text("Ожидание сигналов Пурнова...", style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (context, i) {
                bool isConfirmed = alerts[i]['text'].toString().contains("ПОДТВЕРЖДЕН");
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: isConfirmed ? Colors.amber : Colors.redAccent, width: 1.5),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    title: Text(alerts[i]['asset'], 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(alerts[i]['text'], style: TextStyle(fontSize: 16, color: Colors.white70)),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(isConfirmed ? Icons.check_circle : Icons.shutter_speed, 
                             color: isConfirmed ? Colors.amber : Colors.redAccent),
                        SizedBox(height: 5),
                        Text(alerts[i]['time'], style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }
}
