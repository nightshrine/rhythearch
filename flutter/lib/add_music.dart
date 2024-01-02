import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'common/url.dart';
import 'common/select_list.dart';
import 'common/search_option.dart';

class AddMusic extends StatefulWidget {
  const AddMusic({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _RhythearchAppState createState() => _RhythearchAppState();
}

class _RhythearchAppState extends State<AddMusic> {
  List<int> rhythm = [];
  bool isRecording = false;
  late DateTime lastButtonPressTime;

  static var isButtonVisible = false;

  // 送信内容
  final _titleFieldController = TextEditingController();
  final _artistFieldController = TextEditingController();
  static var _voiceType = "不明";
  final _voiceFieldController = TextEditingController();
  static var _category = "不明";
  final _categoryFieldController = TextEditingController();
  static var _soundType = "不明";
  final _soundFieldController = TextEditingController();

  // リズム追加結果
  static var addMusicResultText = "";

  @override
  void initState() {
    super.initState();
    lastButtonPressTime = DateTime.now();
  }

  void _onButtonPress() {
    // リズム検索中でない場合は、リズム検索を開始し、現在時刻を記録
    if (!isRecording) {
      DateTime now = DateTime.now();
      setState(() {
        isRecording = true;
        lastButtonPressTime = now;
      });
      return;
    }
    // 30個未満の差分データである場合は、差分データを追加
    if (rhythm.length < 30) {
      DateTime now = DateTime.now();
      int interval = now.difference(lastButtonPressTime).inMilliseconds;
      setState(() {
        rhythm.add(interval);
        lastButtonPressTime = now;
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

  Future<void> searchMusic() async {
    _voiceType = otherToText(_voiceType, _voiceFieldController);
    _category = otherToText(_category, _categoryFieldController);
    _soundType = otherToText(_soundType, _soundFieldController);
    await addRhythm(rhythm, _titleFieldController.text,
        _artistFieldController.text, _voiceType, _category, _soundType);
    // 入力値を初期化
    _titleFieldController.clear();
    _artistFieldController.clear();
    _voiceFieldController.clear();
    _categoryFieldController.clear();
    _soundFieldController.clear();
    _voiceType = "不明";
    _category = "不明";
    _soundType = "不明";
  }

  Future<void> addRhythm(List<int> rhythm, String title, String artist,
      String voiceType, String category, String soundType) async {
    if (title.isEmpty || artist.isEmpty) {
      setState(() {
        addMusicResultText = "タイトルとアーティストは必須です";
      });
      return;
    }
    final url = Uri.parse('$backendApi$addRhythmUrl');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode({
      'rhythm': rhythm,
      'title': title,
      'artist': artist,
      'voice_type': voiceType,
      'category': category,
      'sound_type': soundType,
    });
    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // 正常レスポンス
      rhythm = [];
      setState(() {
        isRecording = false;
        isButtonVisible = false;
        addMusicResultText = "リズムを追加しました";
      });
      return;
    } else {
      // エラーレスポンス
      setState(() {
        addMusicResultText = "リズムの追加に失敗しました";
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.only(
              top: 80.0, bottom: 50.0, left: 20.0, right: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100, // テキストフィールドの幅
                          child: TextField(
                            controller: _titleFieldController,
                            decoration: const InputDecoration(
                                hintText: "タイトル",
                                contentPadding: EdgeInsets.zero),
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: SizedBox(
                            width: 150, // テキストフィールドの幅
                            child: TextField(
                              controller: _artistFieldController,
                              decoration: const InputDecoration(
                                  hintText: "アーティスト",
                                  contentPadding: EdgeInsets.zero),
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                  await searchMusic();
                  if (!mounted) return;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("送信結果"),
                        content: Text(addMusicResultText),
                        actions: [
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ));
  }
}
