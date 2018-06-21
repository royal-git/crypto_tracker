import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var _primaryTextColor = Colors.white;
  var _current = [];
  var showContent = false;

  Future<Null> search(String currency, bool submit) async {
    try {
      var response =
          await http.get("https://api.coinmarketcap.com/v1/ticker/$currency/");
      setState(() {
        _current = json.decode(response.body);
      });
    } catch (e) {
      setState(() {
        showContent = false;
      });
      if (submit) {
        Scaffold.of(context).showSnackBar(new SnackBar(
              content: Text(
                  "Could not find coin, are you sure you spelled it correctly?"),
            ));
      }
    }
  }

  showTile() {
    if (showContent == true) {
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: double.parse(_current[0]['percent_change_1h']) < 0
              ? Colors.red
              : Colors.lightGreen,
          child: Text(
            _current[0]["symbol"],
            style: TextStyle(fontSize: 10.0, color: Colors.white),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Text("%1h", style: TextStyle(color: _primaryTextColor)),
                    Text("${_current[0]['percent_change_1h']}",
                        style: TextStyle(
                            color:
                                double.parse(_current[0]['percent_change_1h']) <
                                        0
                                    ? Colors.redAccent[100]
                                    : Colors.greenAccent[400]))
                  ],
                )),
            new Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Text("%24h", style: TextStyle(color: _primaryTextColor)),
                    Text("${_current[0]['percent_change_24h']}",
                        style: TextStyle(
                            color: double.parse(
                                        _current[0]['percent_change_24h']) <
                                    0
                                ? Colors.redAccent[100]
                                : Colors.greenAccent[400]))
                  ],
                )),
            new Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Text("%7d", style: TextStyle(color: _primaryTextColor)),
                    Text("${_current[0]['percent_change_7d']}",
                        style: TextStyle(
                            color:
                                double.parse(_current[0]['percent_change_7d']) <
                                        0
                                    ? Colors.redAccent[100]
                                    : Colors.greenAccent[400]))
                  ],
                )),
          ],
        ),
        title: Text(
          "${_current[0]["name"]} (${_current[0]["symbol"]})",
          style: TextStyle(color: _primaryTextColor),
        ),
        subtitle: Text(
          "\$${_current[0]["price_usd"]}\n${_current[0]["price_btc"]} BTC",
          style: TextStyle(fontSize: 12.0, color: _primaryTextColor),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment(-0.9, 0.0),
            children: <Widget>[
              Icon(
                Icons.search,
                color: Colors.white,
              ),
              Theme(
                data: new ThemeData(
                  hintColor: Colors.white,
                  primaryColor: Colors.white,
                ),
                child: TextField(
                  onSubmitted: (String xd) {
                    search(xd, true);
                    showContent = true;
                  },
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    contentPadding:
                        EdgeInsets.only(left: 50.0, top: 15.0, bottom: 15.0),
                    hintText: 'Search for specific cryptos',
                    hintStyle: TextStyle(color: Colors.white),
                   /* border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),*/
                    border: InputBorder.none,                        
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 50.0),
        showTile(),
      ],
    );
  }
}
