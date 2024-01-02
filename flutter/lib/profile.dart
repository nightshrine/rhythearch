import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<int> rhythm = [];
  bool isRecording = false;
  late DateTime lastButtonPressTime;

  @override
  void initState() {
    super.initState();
    lastButtonPressTime = DateTime.now();
  }

  void _onButtonPress() {
    if (!isRecording) {
      DateTime now = DateTime.now();
      setState(() {
        isRecording = true;
        lastButtonPressTime = now;
      });
      return;
    }
    if (rhythm.length < 10) {
      DateTime now = DateTime.now();
      int interval = now.difference(lastButtonPressTime).inMilliseconds;
      setState(() {
        rhythm.add(interval);
        lastButtonPressTime = now;
      });
    } else if (rhythm.isEmpty) {
      // First button press
      setState(() {
        lastButtonPressTime = DateTime.now();
        rhythm.add(0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "プロフィール",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: 200,
                width: 200,
                child: ElevatedButton(
                  onPressed: _onButtonPress,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(
                    Icons.music_note,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
