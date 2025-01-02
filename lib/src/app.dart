import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noveru/themeModeNotifier.dart';

import 'screens/setting.dart';
import 'screens/bookmark.dart';
import 'screens/book.dart';
import 'screens/about.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'noveる',
      debugShowCheckedModeBanner: false,
      // ライトモードのテーマ設定
      theme: ThemeData(
        fontFamily: 'Noto_Serif_JP',
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          selectedIconTheme: IconThemeData(color: Colors.blue),
          unselectedIconTheme: IconThemeData(color: Colors.grey),
          selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold
          )
        ),
      ),
      // ダークモードのテーマ設定
      darkTheme: ThemeData(
        fontFamily: 'Noto_Serif_JP',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          selectedIconTheme: IconThemeData(color: Colors.blue),
          unselectedIconTheme: IconThemeData(color: Colors.grey),
        ),
      ),
      themeMode: ref.watch(themeModeProvider),
      home: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const BookScreen(),
      const BookmarkScreen(),
      const AboutScreen(),
      const SettingScreen()
    ];
    return Scaffold(
        body: screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.auto_stories), label: 'あらすじ'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'お気に入り'),
            BottomNavigationBarItem(icon: Icon(Icons.info), label: 'アプリについて'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '設定'),
          ],
          type: BottomNavigationBarType.fixed,
        ));
  }
}