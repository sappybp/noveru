import 'package:flutter/material.dart';
import 'package:noveru/sqlite.dart';
import 'package:noveru/classBook.dart';
import 'package:noveru/src/screens/bookmarkdetail.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {

  late double opacityLevel;
  List booksRating = [];

  @override
  void initState() {
    super.initState();
    _initFunction();
  }

  Future<void> _initFunction() async{
    if(mounted) {
      setState(() {
        //ローディングとフェイドイン初期化
        opacityLevel = 0.0;
      });
    }
    await _fetchData();
    if(mounted) {
      setState(() {
        //ローディングとフェイドイン初期化
        opacityLevel = 1.0;
      });
    }
  }

  Future<void> _fetchData() async {
    booksRating = [];
    List<Map<String, dynamic>> records = await DatabaseHelper.instance.selectBookRating();
    // print(records);
    setState(() {
      for (var record in records) {
        booksRating.add(
          BookRating(record['id'], record['title'], record['author'], record['synopsis'], record['rating'])
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('お気に入り',),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
        itemCount: booksRating.length,
        itemBuilder: (BuildContext context, int index) {
          return  Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.fromLTRB(3, 2, 3, 2),
                backgroundColor: Colors.grey.withOpacity(0.2),
              ),
              onPressed: (){
                _navigateBookMarkDetail(context, booksRating[index]);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      '${booksRating[index].synopsis}',
                      overflow:  TextOverflow.ellipsis,
                      maxLines: 4,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                            child:Text(
                              '${booksRating[index].title}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                            child:Text(
                              '${booksRating[index].author}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                ),
              ),
            ),
          );
        }
      )
    );
  }

  Future<void> _navigateBookMarkDetail(BuildContext context, bookRating) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => BookMarkDetail(bookRating: bookRating)),
    );
    if (result == 'delete'){
      _fetchData();
    }
  }
}