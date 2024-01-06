import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'common/url.dart';
import 'common/select_list.dart';
import 'common/search_option.dart';
import 'common/max_value.dart';

// 検索結果の音リスト
var musicList = [];

class Search extends StatefulWidget {
  const Search({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _RhythearchAppState createState() => _RhythearchAppState();
}

class _RhythearchAppState extends State<Search> {
  List<int> rhythm = [];
  bool isRecording = false;
  late DateTime startTime;

  bool isButtonVisible = false;

  static var _voiceType = "不明";
  final _voiceFieldController = TextEditingController();
  static var _category = "不明";
  final _categoryFieldController = TextEditingController();
  static var _soundType = "不明";
  final _soundFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _onButtonPress() {
    // リズム検索中でない場合は、リズム検索を開始し、現在時刻を記録
    if (!isRecording) {
      DateTime now = DateTime.now();
      setState(() {
        isRecording = true;
        startTime = now;
      });
      return;
    }
    // 30個未満の差分データである場合は、差分データを追加
    if (rhythm.length < 30) {
      DateTime now = DateTime.now();
      int startTimeDiff = now.difference(startTime).inMilliseconds;
      setState(() {
        rhythm.add(startTimeDiff);
      });
    } else {
      // TODO: 検索をしてくれるように指示
    }

    // 10個以上の差分データがある場合は検索ボタンを表示
    if (rhythm.length >= 10) {
      setState(() {
        isButtonVisible = true;
      });
    }
  }

  Future<void> getMusic() async {
    if (rhythm[rhythm.length - 1] > maxTime) {
      rhythm = [];
      // TODO: エラー表示
      return;
    }
    _voiceType = otherToText(_voiceType, _voiceFieldController);
    _category = otherToText(_category, _categoryFieldController);
    _soundType = otherToText(_soundType, _soundFieldController);
    musicList = await getMusicList(rhythm, _voiceType, _category, _soundType);
  }

  Future<List<dynamic>> getMusicList(List<int> rhythm, String voiceType,
      String category, String soundType) async {
    final url = Uri.parse('$backendApi$getMusicListUrl');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode({
      'rhythm': rhythm,
      'voice_type': voiceType,
      'category': category,
      'sound_type': soundType,
    });
    var response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      var musicList = jsonDecode(response.body);
      return musicList;
    } else {
      // TODO: エラー表示
      debugPrint(
          'Failed to get music list. Status code: ${response.statusCode}');
      return []; // またはエラーを処理する適切な方法に変更してください
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(
              top: 80.0, bottom: 50.0, left: 20.0, right: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '特徴とリズムを入力',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Column(
                  children: [
                    const Text(
                      '~歌声~',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: DropdownButton(
                                onChanged: (String? value) =>
                                    setState(() => _voiceType = value!),
                                value: _voiceType,
                                items: voiceList.map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                underline: Container(),
                              ),
                            )),
                        if (_voiceType == "その他")
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: SizedBox(
                              width: 100, // テキストフィールドの幅
                              child: TextField(
                                controller: _voiceFieldController,
                                decoration: const InputDecoration(
                                    hintText: "詳細を入力",
                                    contentPadding: EdgeInsets.zero),
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      '~カテゴリー~',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: DropdownButton(
                                onChanged: (String? value) =>
                                    setState(() => _category = value!),
                                value: _category,
                                items: categoryList.map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                underline: Container(),
                              ),
                            )),
                        if (_category == "その他")
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: SizedBox(
                              width: 100, // テキストフィールドの幅
                              child: TextField(
                                controller: _categoryFieldController,
                                decoration: const InputDecoration(
                                    hintText: "詳細を入力",
                                    contentPadding: EdgeInsets.zero),
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      '~音の種類~',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: DropdownButton(
                                onChanged: (String? value) =>
                                    setState(() => _soundType = value!),
                                value: _soundType,
                                items: soundList.map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                underline: Container(),
                              ),
                            )),
                        if (_soundType == "その他")
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: SizedBox(
                              width: 100, // テキストフィールドの幅
                              child: TextField(
                                controller: _soundFieldController,
                                decoration: const InputDecoration(
                                    hintText: "詳細を入力",
                                    contentPadding: EdgeInsets.zero),
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 200,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: _onButtonPress,
                    style:
                        ElevatedButton.styleFrom(shape: const CircleBorder()),
                    child: const Icon(
                      Icons.music_note,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: isRecording,
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () {
                  setState(() {
                    isRecording = false;
                    rhythm = [];
                    isButtonVisible = false;
                  });
                },
                child: const Icon(Icons.delete),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: isButtonVisible,
              child: FloatingActionButton(
                onPressed: () async {
                  await getMusic();
                  if (!mounted) return;
                  showBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 650,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 20,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            // Title
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              child: const Text(
                                'もしかして…',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: musicList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return (index == 1)
                                      ? Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 50.0, bottom: 20.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '↓他の候補曲↓',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Card(
                                              child: Column(
                                                children: <Widget>[
                                                  ListTile(
                                                    title: Text(musicList[index]
                                                        ['title']),
                                                    subtitle: Text(
                                                        musicList[index]
                                                            ['artist']),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : Card(
                                          child: Column(
                                            children: <Widget>[
                                              (index == 0)
                                                  ?
                                                  // 最初の要素だけ大きく表示
                                                  Container(
                                                      height:
                                                          200.0, // 任意の大きさを指定
                                                      alignment:
                                                          Alignment.center,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          ListTile(
                                                            title: Text(
                                                              musicList[index]
                                                                  ['title'],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 30.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            subtitle: Text(
                                                              musicList[index]
                                                                  ['artist'],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 20.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : ListTile(
                                                      title: Text(
                                                          musicList[index]
                                                              ['title']),
                                                      subtitle: Text(
                                                          musicList[index]
                                                              ['artist']),
                                                    ),
                                            ],
                                          ),
                                        );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Icon(Icons.search),
              ),
            ),
          ],
        ));
  }
}
