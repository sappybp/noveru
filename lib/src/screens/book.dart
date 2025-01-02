import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:noveru/sqlite.dart';
import 'package:noveru/classBook.dart';
import 'package:noveru/src/tategaki/tategaki.dart';

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
    await Future.delayed(const Duration(seconds: 1));

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
        books.add(
          Book(record['id'], record['title'], record['author'],
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
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