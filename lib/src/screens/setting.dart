import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noveru/themeModeNotifier.dart';
import 'package:noveru/colorAssistNotifier.dart';

import 'package:noveru/sqlite.dart';


class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final switchThemeMode = ref.read(themeModeProvider.notifier).switchThemeMode;
    final switchColorAssist = ref.read(colorAssistProvider.notifier).switchColorAssist;
    return Scaffold(
      appBar: AppBar(
        title: const Text("設定"),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          SwitchListTile(
            title: const Text('ダークモード',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            value: (ref.watch(themeModeProvider) == ThemeMode.dark) ? true : false,
            onChanged: (bool value) {
              if (value == false) {
                switchThemeMode(ThemeMode.light);
              } else {
                switchThemeMode(ThemeMode.dark);
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Divider(
            indent: 10,
            endIndent: 10,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
          ),
          const SizedBox(
            height: 10,
          ),
          SwitchListTile(
            title: const Text('色彩アシスト',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            value: ref.watch(colorAssistProvider),
            onChanged: (bool value) {
              if (value == false) {
                switchColorAssist(false);
              } else {
                switchColorAssist(true);
              }
            },
          ),
          const Text('※オンにすると、あらすじ表示にジャンル別カラーを表示できます。',
            style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          ),
          const SizedBox(
            height: 10,
          ),
          Divider(
            indent: 10,
            endIndent: 10,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              // 幅150、高さ50のボタン
              fixedSize: const Size(double.infinity, 50),
            ),
            child: const Text('お気に入りのあらすじをリセット',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              showDialog<void>(
                  context: context,
                  builder: (_) {
                    return const AlertDialogSample(type: 0);
                  }
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              // 幅150、高さ50のボタン
              fixedSize: const Size(double.infinity, 50),
            ),
            child: const Text('削除したあらすじをリセット',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              showDialog<void>(
                  context: context,
                  builder: (_) {
                    return const AlertDialogSample(type: 1);
                  }
              );
            },
          ),
        ],
      ),
    );
  }
}

class AlertDialogSample extends StatelessWidget {
  const AlertDialogSample({super.key, required this.type});
  final int type;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: type == 0 ?
      const Text('お気に入りのあらすじをリセットしますか？',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ):
      const Text('削除したあらすじをリセットしますか？',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('戻る',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            // print('戻る');
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          child: const Text('リセット',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red
            ),
          ),
          onPressed: () {
            // print('リセット');
            DatabaseHelper.instance.deleteSomeBookRatings(type);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}