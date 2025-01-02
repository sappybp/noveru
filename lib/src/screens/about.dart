import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:noveru/src/screens/howToUse.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future onLaunchUrlPrivatePolicy () async {
    final url = Uri.parse('https://sappy-info.jimdofree.com/%E3%83%97%E3%83%A9%E3%82%A4%E3%83%90%E3%82%B7%E3%83%BC%E3%83%9D%E3%83%AA%E3%82%B7%E3%83%BC/');
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      print('cant open url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アプリについて',),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              // 幅150、高さ50のボタン
              fixedSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              onLaunchUrlPrivatePolicy();
            },
            child: const Text("プライバシーポリシー",
              style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              // 幅150、高さ50のボタン
              fixedSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HowToUse()
                ),
              );
            },
            child: const Text("使い方",
              style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
    );
  }
}