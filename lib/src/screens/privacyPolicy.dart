import 'package:flutter/material.dart';


class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プライバシーポリシー',),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: const [
          SizedBox(
            height: 20,
          ),
          Text('『個人情報の取得』',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text('本アプリが個人情報を取得することはありません。',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text('『個人情報の利用』',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text('本アプリが個人情報を利用することはありません。',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text('『個人情報の提供』',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text('本アプリが個人情報を第三者へ提供することはありません。',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text('『表示されるあらすじについて』',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text('本アプリでは、本のあらすじが表示されますが、実際の本の内容とずれが生じている可能性がございます。購入の際などは、今一度ご確認をお願いしております。',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text('『外部アプリへのアクセス』',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text('本アプリでは、お気に入りにした本をスムーズに検索できるようリンクがありますが、その先で発生した問題（購入、配送の問題や本の内容があらすじと違った、面白くなかった等）に対して、一切の責任を負いかねます。',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text('最終更新日：2025/1/1',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
