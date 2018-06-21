import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'tabs/search.dart';

main() => runApp(new MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  var _cryptoData;
  var _myColor = Colors.blueGrey[900];
  var _primaryTextColor = Colors.white;
  var myTabController;
  Future<Null> _loadData() async {
    http.Response response =
        await http.get("https://api.coinmarketcap.com/v1/ticker/?limit=50");
    setState(() {
      _cryptoData = json.decode(response.body);
    });
  }

  final List<Tab> myTabs = <Tab>[
    new Tab(icon: Icon(Icons.home)),
    new Tab(icon: Icon(Icons.search)),
  ];
  @override
  void initState() {
    _loadData();
    super.initState();
    myTabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        bottom: new TabBar(
          controller: myTabController,
          tabs: myTabs,
        ),
        actions: <Widget>[
          new IconButton(
            color: _primaryTextColor,
            icon: Icon(Icons.refresh),
            onPressed: () {
              _loadData();
            },
          ),
        ],
        backgroundColor: _myColor,
        elevation: 0.0,
        title: new Text(
          "🚀hodl",
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      body: TabBarView(
        controller: myTabController,
        children: <Widget>[
          RefreshIndicator(
            backgroundColor: Colors.white,
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
                        backgroundColor:
                            double.parse(_current['percent_change_1h']) < 0
                                ? Colors.red
                                : Colors.lightGreen,
                        child: Text(
                          _current["symbol"],
                          style: TextStyle(
                              fontSize: _fontSize, color: Colors.white),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          new Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Text("%1h",
                                      style:
                                          TextStyle(color: _primaryTextColor)),
                                  Text("${_current['percent_change_1h']}",
                                      style: TextStyle(
                                          color: double.parse(_current[
                                                      'percent_change_1h']) <
                                                  0
                                              ? Colors.redAccent[100]
                                              : Colors.greenAccent[400]))
                                ],
                              )),
                          new Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Text("%24h",
                                      style:
                                          TextStyle(color: _primaryTextColor)),
                                  Text("${_current['percent_change_24h']}",
                                      style: TextStyle(
                                          color: double.parse(_current[
                                                      'percent_change_24h']) <
                                                  0
                                              ? Colors.redAccent[100]
                                              : Colors.greenAccent[400]))
                                ],
                              )),
                          new Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Text("%7d",
                                      style:
                                          TextStyle(color: _primaryTextColor)),
                                  Text("${_current['percent_change_7d']}",
                                      style: TextStyle(
                                          color: double.parse(_current[
                                                      'percent_change_7d']) <
                                                  0
                                              ? Colors.redAccent[100]
                                              : Colors.greenAccent[400]))
                                ],
                              )),
                        ],
                      ),
                      title: Text(
                        "${_current["name"]} (${_current["symbol"]})",
                        style: TextStyle(color: _primaryTextColor),
                      ),
                      subtitle: Text(
                        "\$${_current["price_usd"]}\n${_current["price_btc"]} BTC",
                        style:
                            TextStyle(fontSize: 12.0, color: _primaryTextColor),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          Search(),
        ],
      ),
      backgroundColor: _myColor,
    );
  }
}
