import 'dart:async';
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
      title: 'Fun ABC & 123',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const LearningScreen(),
    );
  }
}

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  final FlutterTts tts = FlutterTts();
  final AudioPlayer player = AudioPlayer();
  final letters = List.generate(26, (i) => String.fromCharCode(65 + i));
  final numbers = List.generate(10, (i) => (i + 1).toString());

  String category = "letters";
  String mode = "learn";
  int currentIndex = 0;
  Timer? autoplayTimer;

  // quiz
  String? quizCorrect;
  List<String> quizChoices = [];
  int score = 0;
  int attempts = 0;

  @override
  void dispose() {
    autoplayTimer?.cancel();
    super.dispose();
  }

  List<String> get items => category == "letters" ? letters : numbers;

  Future<void> speak(String text) async {
    await tts.stop();
    await tts.setPitch(1.1);
    await tts.setSpeechRate(0.5);
    await tts.speak(text);
  }
  
  Future<void> playItem(int i) async {
    setState(() => currentIndex = i);
    await speak(items[i]);
  }

  void startAutoplay() async {
    stopAutoplay(); // ensure no duplicate timer
    int i = 0;

    Future<void> playNext() async {
      if (i >= items.length) i = 0; // loop back
      await playItem(i);
      i++;
      // wait 1 second after speech ends, then play next
      Future.delayed(const Duration(seconds: 2), playNext);
    }

    playNext();
  }


  void stopAutoplay() {
    autoplayTimer?.cancel();
    autoplayTimer = null;
  }

  void makeQuizQuestion() {
    final rand = Random();
    final correct = items[rand.nextInt(items.length)];
    final Set<String> choices = {correct};
    while (choices.length < 4) {
      choices.add(items[rand.nextInt(items.length)]);
    }
    setState(() {
      quizCorrect = correct;
      quizChoices = choices.toList()..shuffle();
    });
    speak(correct);
  }

  void chooseAnswer(String choice) {
    setState(() => attempts++);
    if (choice == quizCorrect) {
      setState(() => score++);
      speak("Correct");
    } else {
      speak("No, it is $quizCorrect");
    }
    Future.delayed(const Duration(seconds: 1), makeQuizQuestion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      appBar: AppBar(
        title: const Text("Fun ABC & 123"),
        actions: [
          DropdownButton<String>(
            value: category,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: "letters", child: Text("Letters")),
              DropdownMenuItem(value: "numbers", child: Text("Numbers")),
            ],
            onChanged: (v) => setState(() => category = v!),
          ),
          const SizedBox(width: 10),
          DropdownButton<String>(
            value: mode,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: "learn", child: Text("Learn")),
              DropdownMenuItem(value: "play", child: Text("Play")),
              DropdownMenuItem(value: "quiz", child: Text("Quiz")),
            ],
            onChanged: (v) {
              setState(() => mode = v!);
              stopAutoplay();
              if (mode == "quiz") {
                score = 0;
                attempts = 0;
                makeQuizQuestion();
              }
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: mode == "quiz"
            ? buildQuiz()
            : buildCards(),
      ),
      floatingActionButton: mode == "play"
          ? (autoplayTimer == null
              ? FloatingActionButton.extended(
                  onPressed: startAutoplay,
                  label: const Text("Play"),
                  icon: const Icon(Icons.play_arrow),
                )
              : FloatingActionButton.extended(
                  onPressed: stopAutoplay,
                  label: const Text("Stop"),
                  icon: const Icon(Icons.stop),
                ))
          : null,
    );
  }

  Widget buildCards() {
    return GridView.builder(
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, i) {
        final isActive = i == currentIndex;
        return GestureDetector(
          onTap: () => playItem(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isActive ? Colors.teal[200] : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  offset: const Offset(2, 2),
                  color: Colors.black.withOpacity(0.1),
                )
              ],
            ),
            child: Center(
              child: Text(
                items[i],
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildQuiz() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          "What is this?",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        Text(
          quizCorrect ?? "",
          style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: quizChoices
              .map((c) => ElevatedButton(
                    onPressed: () => chooseAnswer(c),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      c,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ))
              .toList(),
        ),
        const Spacer(),
        Text("Score: $score / Attempts: $attempts"),
        const SizedBox(height: 20),
      ],
    );
  }
}
