import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Match Words with Images",
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orange,
      ),
      home: const MatchGame(),
    );
  }
}

class MatchGame extends StatefulWidget {
  const MatchGame({super.key});

  @override
  State<MatchGame> createState() => _MatchGameState();
}

class _MatchGameState extends State<MatchGame> {
  final FlutterTts tts = FlutterTts();
  final AudioPlayer player = AudioPlayer();

  final List<Map<String, String>> data = [
    {"word": "Apple", "image": "assets/images/apple.jpg"},
    {"word": "Ball", "image": "assets/images/ball.jpg"},
    {"word": "Cat", "image": "assets/images/cat.webp"},
    {"word": "Dog", "image": "assets/images/dog.webp"},
  ];

  Map<String, String>? current;
  List<String> options = [];
  int score = 0;

  @override
  void initState() {
    super.initState();
    nextQuestion();
  }

  Future<void> speak(String text) async {
    await tts.setSpeechRate(0.5);
    await tts.speak(text);
  }

  void playSound(String type) async {
    if (type == "correct") {
      await player.play(AssetSource("sounds/correct.mp3"));
    } else {
      await player.play(AssetSource("sounds/wrong.mp3"));
    }
  }

void nextQuestion() {
  final rand = Random();
  final newCurrent = data[rand.nextInt(data.length)];
  final Set<String> choiceSet = {newCurrent["word"]!};

  while (choiceSet.length < 4) {
    choiceSet.add(data[rand.nextInt(data.length)]["word"]!);
  }

  setState(() {
    current = newCurrent;
    options = choiceSet.toList()..shuffle();
  });

  speak("Find ${newCurrent["word"]}");
}


void checkAnswer(String choice) {
  if (choice == current!["word"]) {
    playSound("correct");
    speak("Great! Correct answer");
    setState(() => score++);
  } else {
    playSound("wrong");
    speak("Oops! The correct answer is ${current!["word"]}");
  }

  // Move to next question automatically after 1.5 seconds
  Future.delayed(const Duration(seconds: 2), nextQuestion);
}

  @override
  Widget build(BuildContext context) {
    if (current == null) return const SizedBox();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBE7),
      appBar: AppBar(
        title: const Text("Match Image & Word"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "Score: $score",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black26,
                      offset: const Offset(2, 2),
                    )
                  ],
                ),
                child: Image.asset(current!["image"]!, width: 180),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: options
                .map((word) => ElevatedButton(
                      onPressed: () => checkAnswer(word),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        backgroundColor: Colors.orange.shade100,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        word,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
