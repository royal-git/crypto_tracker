import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

main() => runApp(new MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _cryptoData;
  Future<Null> _loadData() async {
    http.Response response =
        await http.get("https://api.coinmarketcap.com/v1/ticker/?limit=50");
    setState(() {
      _cryptoData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          new IconButton(
            color: Colors.black54,
            icon: Icon(Icons.refresh),
            onPressed: () {
              _loadData();
            },
          ),
          
        ],
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: new Text("💸"),
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadData(),
        child: ListView.builder(
          itemCount: _cryptoData == null ? 0 : _cryptoData.length,
          itemBuilder: ((BuildContext context, int index) {
            var _current = _cryptoData[index];
            double _fontSize = _current['symbol'].length >= 5 ? 10.0 : 13.0;
            return Column(
              children: <Widget>[
                Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: double.parse(_current['percent_change_1h']) < 0 ? Colors.red : Colors.lightGreen,
                    child: Text(
                      _current["symbol"],
                      style: TextStyle(fontSize: _fontSize, color: Colors.white),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      new Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(children: <Widget>[
                          Text("%1h", style: TextStyle(color: Colors.black54)),
                          Text("${_current['percent_change_1h']}", style: TextStyle(color: double.parse(_current['percent_change_1h']) < 0 ? Colors.red : Colors.green))
                        ],)
                      ),
                      new Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(children: <Widget>[
                          Text("%24h", style: TextStyle(color: Colors.black54)),
                          Text("${_current['percent_change_24h']}", style: TextStyle(color: double.parse(_current['percent_change_24h']) < 0 ? Colors.red : Colors.green))
                        ],)
                      ),
                      new Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(children: <Widget>[
                          Text("%7d", style: TextStyle(color: Colors.black54)),
                          Text("${_current['percent_change_7d']}", style: TextStyle(color: double.parse(_current['percent_change_7d']) < 0 ? Colors.red : Colors.green))
                        ],)
                      ),
                    ],
                  ),
                  title: Text("${_current["name"]} (${_current["symbol"]})"),
                  subtitle: Text(
                      "\$${_current["price_usd"]}\n${_current["price_btc"]} BTC", style: TextStyle(fontSize: 12.0),),
                ),
              ],
            );
          }),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
