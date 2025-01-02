import 'package:flutter/material.dart';

class HowToUse extends StatelessWidget {
  const HowToUse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('使い方',),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: const [
          SizedBox(
            height: 20,
          ),
          Text('1．あらすじ画面ではあらすじがランダムで表示されます。グレーのボタンでひとつ前のあらすじに戻れます。',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('★お気に入りなら右スワイプorハートをタップ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          Text('×興味がなければ左スワイプorゴミ箱をタップ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
          ),
          SizedBox(
            height: 10,
          ),
          FittedBox(
            fit: BoxFit.contain,
            child: Image(image: AssetImage('assets/images/explain1.png')),
          ),
          SizedBox(
            height: 40,
          ),
          Text('2．お気に入り一覧から自分がお気に入りにしたあらすじの本が確認できます。タップして詳細も確認できます。',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          FittedBox(
            fit: BoxFit.contain,
            child: Image(image: AssetImage('assets/images/explain2.png')),
          ),
          SizedBox(
            height: 40,
          ),
          Text('3．本のタイトル、著者名、あらすじを確認できます。リンクをタップして検索することができます。',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          FittedBox(
            fit: BoxFit.contain,
            child: Image(image: AssetImage('assets/images/explain3.png')),
          ),
          SizedBox(
            height: 40,
          ),
          Text('最終更新日：2025/1/1',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
