import 'package:flutter/material.dart';
import 'package:noveru/sqlite.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:external_app_launcher/external_app_launcher.dart';

import 'package:noveru/classBook.dart';

class BookMarkDetail extends StatefulWidget {
  const BookMarkDetail({super.key, required this.bookRating});

  final BookRating bookRating;

  @override
  State<BookMarkDetail> createState() => _BookMarkDetailState();
}

class _BookMarkDetailState extends State<BookMarkDetail> {

  @override
  void initState() {
    super.initState();
  }

  Future onLaunchUrl () async {
    final url = Uri.parse('https://www.amazon.co.jp/s?k=${widget.bookRating.title}%7C${widget.bookRating.author}');
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      print('cant open url');
      // var openAppResult = await LaunchApp.openApp(
      //   androidPackageName: 'com.amazon.mShop.android.shopping',
      //   iosUrlScheme: 'amzn://',
      // );
      // print(
      //     'openAppResult => $openAppResult ${openAppResult.runtimeType}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              decoration: const BoxDecoration(
                  // color: Color.fromARGB(255, 19, 19, 19)
              ),
              constraints: const BoxConstraints.expand(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(widget.bookRating.title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(widget.bookRating.author,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                    child: Text('　${widget.bookRating.synopsis}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onLaunchUrl();
                    },
                    child: const Text("この本をamazonで探す",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(30),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context, "");
                    },
                    padding: const EdgeInsets.all(20),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey,
                      highlightColor: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(30),
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      DatabaseHelper.instance.deleteBookRating(widget.bookRating.id);
                      Navigator.pop(context, "delete");
                    },
                    padding: const EdgeInsets.all(20),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red,
                      highlightColor: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}