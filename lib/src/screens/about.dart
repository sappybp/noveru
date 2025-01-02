import 'package:flutter/material.dart';

import 'package:noveru/src/screens/privacyPolicy.dart';
import 'package:noveru/src/screens/howToUse.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicy()
                ),
              );
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