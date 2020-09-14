import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:i_motivate/main.dart';

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

    final key = new GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: Colors.black,
      key: key,
      body: Container(
        child: FutureBuilder(
          future: _getQuote(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.deepOrangeAccent),
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (snapshot.data == null)
                    return SplashScreen();
                  else
                    return Column(
                      children: [
                        SizedBox(height: 120),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: (width - 20),
                            minHeight: 400,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(15.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "I Motivate",
                                      style:
                                          GoogleFonts.getFont('Abril Fatface')
                                              .copyWith(
                                                  fontSize: 32.0,
                                                  color: Colors.deepOrange),
                                    ),
                                    SizedBox(height: 50),
                                    Text(
                                      "“ " + qod.quote + " ”",
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                      style:
                                          GoogleFonts.getFont('Hammersmith One')
                                              .copyWith(
                                                  fontSize: 20.0,
                                                  color: Colors.black),
                                    ),
                                    Text("\n" + qod.author,
                                        softWrap: true,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 20.0)),
                                    SizedBox(height: 50),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(
                                      text: qod.quote + "\n\t-" + qod.author),
                                );
                                key.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text("Copied to Clipboard"),
                                  ),
                                );
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                child: Icon(Icons.content_copy,
                                    size: 30, color: Colors.black),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            SizedBox(width: 20.0),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _getQuote();
                                });
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                child: Icon(Icons.refresh,
                                    size: 30, color: Colors.black),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            SizedBox(width: 20.0),
                            GestureDetector(
                              onTap: () {
                                Share.share(qod.quote + "\n\t-" + qod.author);
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                child: Icon(Icons.share,
                                    size: 30, color: Colors.black),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                }
            }
          },
        ),
      ),
    );
  }
}

class Quote {
  final String quote;
  final String author;
  Quote(this.author, this.quote);
}
