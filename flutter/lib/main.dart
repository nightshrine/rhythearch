import 'package:flutter/material.dart';
import 'package:rhythearch/search.dart';
import 'package:rhythearch/add_rhythm.dart';
import 'package:rhythearch/profile.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    // theme: ThemeData.dark(), //← これでダークテーマ固定
    home: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _RhythearchAppState createState() => _RhythearchAppState();
}

class _RhythearchAppState extends State<MyApp> with TickerProviderStateMixin {
  static List<Widget> tabs = <Widget>[
    const Search(),
    const AddRhythm(),
    const Profile(),
  ];
  int currentIndex = 0;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(), // スワイプでの画面遷移を無効にする
          children: tabs,
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ]),
          child: BottomNavigationBar(
              elevation: 50,
              currentIndex: currentIndex,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: '検索',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.music_note),
                  label: '曲追加',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.perm_identity),
                  label: 'プロフィール',
                ),
              ],
              onTap: (index) {
                setState(() {
                  _tabController.index = index;
                  currentIndex = index;
                });
              }),
        ));
  }
}
