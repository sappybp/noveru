import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:noveru/sqlite.dart';
import 'package:noveru/classBook.dart';
import 'package:noveru/src/tategaki/tategaki.dart';
import 'package:noveru/sharedPreferencesInstance.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen>{

  late List books;

  late bool _isLoading;
  late double opacityLevel;
  late double opacityLevelLate;

  final CardSwiperController controller = CardSwiperController();

  @override
  void initState() {
    super.initState();
    _createBooks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _createBooks() async {
    // print('createBooks開始');
    if(mounted) {
      setState(() {
        //ローディングとフェイドイン初期化
        _isLoading = true;
        opacityLevel = 0.0;
        opacityLevelLate = 0.0;
      });
    }

    await _fetchData();

    //ローディング画面が見たい時用
    await Future.delayed(const Duration(milliseconds: 500));

    if(mounted) {
      setState(() {
        //ローディングとフェイドイン
        _isLoading = false;
        opacityLevel = 1.0;
      });
    }

    //前面の出力時間を待つ
    await Future.delayed(const Duration(milliseconds: 500));

    if(mounted) {
      //背景の更新ボタン用のopacityLevel
      setState(() {
        opacityLevelLate = 1.0;
      });
    }
  }

  Future<void> _fetchData() async {
    books = [];
    List<Map<String, dynamic>> records = await DatabaseHelper.instance.selectBook10();
    for (var record in records) {
      setState(() {
        var genre = Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white;
        if (getColorAssist() == true) {
          if (Theme.of(context).brightness != Brightness.dark) {
            switch (record['genre']) {
              case 0: // ヒューマン・ドラマ
                genre = const Color.fromARGB(255, 205, 205, 255);
              case 1: // SF・ファンタジー
                genre = const Color.fromARGB(255, 255, 255, 205);
              case 2: // ミステリー・サスペンス
                genre = const Color.fromARGB(255, 255, 205, 205);
              case 3: // 恋愛
                genre = const Color.fromARGB(255, 255, 205, 230);
              case 4: // 青春
                genre = const Color.fromARGB(255, 205, 255, 255);
              case 5: // ホラー
                genre = const Color.fromARGB(255, 235, 235, 235);
              case 6: // 短編集
                genre = const Color.fromARGB(255, 205, 205, 255);
              case 7: // 文学、名作文学、海外文学
                genre = const Color.fromARGB(255, 255, 230, 205);
              case 8: // 経済・社会
                genre = const Color.fromARGB(255, 230, 255, 205);
              case 9: // 歴史・時代
                genre = const Color.fromARGB(255, 205, 255, 205);
              default: // その他
                genre = const Color.fromARGB(255, 220, 205, 255);
            }
          } else {
            switch (record['genre']) {
              case 0: // ヒューマン・ドラマ
                genre = const Color.fromARGB(255, 0, 0, 50);
              case 1: // SF・ファンタジー
                genre = const Color.fromARGB(255, 50, 50, 0);
              case 2: // ミステリー・サスペンス
                genre = const Color.fromARGB(255, 50, 0, 0);
              case 3: // 恋愛
                genre = const Color.fromARGB(255, 50, 0, 25);
              case 4: // 青春
                genre = const Color.fromARGB(255, 0, 50, 50);
              case 5: // ホラー
                genre = const Color.fromARGB(255, 20, 20, 20);
              case 6: // 短編集
                genre = const Color.fromARGB(255, 0, 0, 50);
              case 7: // 文学、名作文学、海外文学
                genre = const Color.fromARGB(255, 50, 25, 0);
              case 8: // 経済・社会
                genre = const Color.fromARGB(255, 25, 50, 0);
              case 9: // 歴史・時代
                genre = const Color.fromARGB(255, 0, 50, 0);
              default: // その他
                genre = const Color.fromARGB(255, 30, 0, 50);
            }
          }
        }
        books.add(
          Book(record['id'], record['title'], record['author'],
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: FractionalOffset.topRight,
                  end: FractionalOffset.bottomLeft,
                  colors: [
                    Theme.of(context).brightness == Brightness.dark ? genre : genre,
                    Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                    Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                    Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                    Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                    Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                    Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                    Theme.of(context).brightness == Brightness.dark ? genre : genre,
                  ],
                ),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(0, 10, 20, 15),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Scrollbar(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Tategaki("　${record['synopsis']}",
                    style: const TextStyle(
                      height: 1.1,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              )
            )
          )
        );
      });
    }
  }

  bool getColorAssist() {
    final prefs = SharedPreferencesInstance().prefs;
    // print('_loadColorAssist');
    final loaded = prefs.getBool('color_assist') ?? true;
    return loaded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
        toolbarHeight: 30.0,
      ),
      body: Stack(
        children: [
          Center(
            child: IconButton(
              icon: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.refresh,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //index初期化
                controller.moveTo(0);
                //データの取得
                _createBooks();
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue,
                highlightColor: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                (books.isEmpty || books.length <= 1)?
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text('※すべてのあらすじを読み終えました。',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text('※設定からゴミ箱に入れたあらすじをリセットすることができます。',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ):Flexible(
                  child: CardSwiper(
                    controller: controller,
                    isLoop: false,
                    scale: 0.6,
                    onSwipe: _onSwipe,
                    onUndo: _onUndo,
                    allowedSwipeDirection:const AllowedSwipeDirection.only(left: true, right: true),
                    cardsCount: books.length,
                    cardBuilder: (
                      context,
                      index,
                      percentThresholdX,
                      percentThresholdY
                    ) => books[index].synopsis,
                  ),
                ),
                (books.isEmpty || books.length <= 1)?const Text('',
                  // style: TextStyle(color: Colors.white),
                ):Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ///delete///
                    IconButton(
                      icon: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.delete_outline,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => controller.swipe(CardSwiperDirection.left),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        highlightColor: Colors.black.withOpacity(0.3),
                      ),
                    ),
                    ///undo///
                    IconButton(
                      icon: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.undo,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: controller.undo,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey,
                        highlightColor: Colors.black.withOpacity(0.3),
                      ),
                    ),
                    ///favorite///
                    IconButton(
                      icon: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.favorite,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => controller.swipe(CardSwiperDirection.right),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.green,
                        highlightColor: Colors.black.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
          if (_isLoading)
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
              ),
              constraints: const BoxConstraints.expand(),
              child: Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.blue,
                  size: 100,
                ),
              ),
            ),
        ],
      ),
    );
  }

   bool _onSwipe(
      int previousIndex,
      int? currentIndex,
      CardSwiperDirection direction,
    ) {
      // debugPrint(
      //   'スワイプしたカードindex： $previousIndex　　'
      //   'スワイプ後に表示されているカードindex：$currentIndex　　'
      //   'スワイプした方向：${direction.name}'
      //   'あらすじの書籍番号：${books[previousIndex].id}'
      //   'あらすじのタイトル：${books[previousIndex].title}'
      //   'あらすじの著者：${books[previousIndex].author}'
      // );

      if (direction.name == 'right') {
        //0：お気に入り
        DatabaseHelper.instance.insertBookRating(books[previousIndex].id, 0);
      } else {
        //1:削除
        DatabaseHelper.instance.insertBookRating(books[previousIndex].id, 1);
      }

      return true;
    }

  bool _onUndo(
      int? previousIndex,
      int currentIndex,
      CardSwiperDirection direction,
    ) {
      // debugPrint(
      //   '元に戻しました　　'
      //   '元に戻したカード：$currentIndex　　'
      //   '元に戻る前に表示されていたカード：$previousIndex　　'
      //   'スワイプしていた方向：${direction.name}',
      // );

      DatabaseHelper.instance.deleteBookRating(books[currentIndex].id);

      return true;
    }
}