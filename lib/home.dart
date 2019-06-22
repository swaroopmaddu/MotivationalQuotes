import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

Quote qod;

class _HomeScreenState extends State<HomeScreen> {
  Future<Quote> _getQuote() async {
    var data = await http.get("https://favqs.com/api/qotd");
    var json = jsonDecode(data.body);
    var dataValues = Map.from(json['quote']);
    qod = Quote(dataValues['author'], dataValues['body']);
    return qod;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final key = new GlobalKey<ScaffoldState>();

    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.format_quote,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepOrangeAccent,
        title: Text("I Motivate"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => SystemNavigator.pop(),
          )
        ],
      ),
      key: key,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        backgroundColor: Colors.deepOrangeAccent,
        icon: const Icon(Icons.format_quote),
        label: const Text('Refresh'),
        onPressed: () {
          setState(() {
            _getQuote();
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share(qod.quote + "\n\t-" + qod.author);
              },
            ),
            Text(""),
            IconButton(
              icon: Icon(Icons.content_copy),
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: qod.quote + "\n\t-" + qod.author),
                );
                key.currentState.showSnackBar(
                  SnackBar(
                    content: Text("Copied to Clipboard"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: FutureBuilder(
            future: _getQuote(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent),
                  );
                default:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    if (snapshot.data == null)
                      return SplashScreen();
                    else
                      return Container(
                        padding: EdgeInsets.all(32.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Container(
                            height: height,
                            width: width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Container(height: 230.0),
                                    Container(
                                      height: 100.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                        color: Colors.deepOrangeAccent,
                                      ),
                                    ),
                                    Positioned(
                                      top: 50.0,
                                      left: 94.0,
                                      child: Container(
                                        padding: EdgeInsets.all(4.0),
                                        height: 90.0,
                                        width: 90.0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(45.0),
                                          border: Border.all(
                                              color: Colors.deepOrange,
                                              style: BorderStyle.solid,
                                              width: 2.0),
                                          image: DecorationImage(
                                            image:
                                                AssetImage("images/logo.png"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(
                                      "“ " + qod.quote + " ”",
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2.0),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 40.0),
                                  child: Center(
                                    child: Text(
                                      " ̶̶ " + qod.author,
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                  }
              }
            }),
      ),
    );
  }
}

class Quote {
  final String quote;
  final String author;
  Quote(this.author, this.quote);
}
