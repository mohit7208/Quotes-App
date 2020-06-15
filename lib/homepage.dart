import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  fetchData() async {
    final url = "http://192.168.153.1:3000/api/quotes";
    var res = await http.get(url);
    print("Response is $res");
    return jsonDecode(res.body)["quotes"];
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      Vx.blue800,
      Vx.gray800,
      Vx.red800,
      Vx.green800,
      Vx.orange800,
      Vx.purple800,
      Vx.teal800,
      Vx.pink800,
      Vx.yellow800,
    ];
    return Material(
      child: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          print("Snashot is ${snapshot.data}");
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return StatefulBuilder(
                builder: (context, setState) {
                  final color = colors[Random().nextInt(9)];
                  return VxSwiper(
                    onPageChanged: (index) {
                      setState(() {});
                    },
                    viewportFraction: 1.0,
                    scrollDirection: Axis.vertical,
                    height: context.screenHeight,
                    items: snapshot.data
                        .map<Widget>((el) => VStack(
                              [
                                "Quotes".text.white.xl2.make(),
                                "${el["quoteText"]}"
                                    .text
                                    .white
                                    .italic
                                    .xl3
                                    .bold
                                    .make()
                                    .shimmer()
                                    .box
                                    .shadow2xl
                                    .make(),
                                IconButton(
                                  icon: Icon(
                                    Icons.share,
                                    size: 30,
                                  ),
                                  color: Colors.white,
                                  onPressed: () {
                                    Share.share("${el["quoteText"]}");
                                  },
                                )
                              ],
                              crossAlignment: CrossAxisAlignment.center,
                              alignment: MainAxisAlignment.spaceAround,
                            )
                                .animatedBox
                                .p16
                                .color(color)
                                .make()
                                .h(context.screenHeight))
                        .toList(),
                  );
                },
              );
            }
          } else if (snapshot.connectionState == ConnectionState.none) {
            return "Something went wrong".text.makeCentered();
          }
          return CircularProgressIndicator().centered();
        },
      ),
    );
  }
}
