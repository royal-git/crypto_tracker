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

  Future<Null> search(String currency) async {
    var response =
        await http.get("https://api.coinmarketcap.com/v1/ticker/bitcoin/");
    setState(() {
      _current = json.decode(response.body);
    });
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
                    print(xd);
                  },
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    contentPadding:
                        EdgeInsets.only(left: 50.0, top: 15.0, bottom: 15.0),
                    hintText: 'Search for specific cryptos',
                    hintStyle: TextStyle(color: Colors.white),
                    border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
              ),
              Text("Test"),
            ],
          ),
        ),
        SizedBox(height: 50.0),
      ],
    );
  }
}
