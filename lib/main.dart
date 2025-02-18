import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey, // Navigator Key Tanımlandı
      home: const WordListScreen(),
    );
  }
}

// 🔹 Global Navigator Key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class WordListScreen extends StatefulWidget {
  const WordListScreen({super.key});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> with WidgetsBindingObserver {
  final List<Map<String, String>> words = [
    {"en": "Apple", "tr": "Elma"},
    {"en": "Book", "tr": "Kitap"},
    {"en": "Car", "tr": "Araba"},
    {"en": "Dog", "tr": "Köpek"},
    {"en": "House", "tr": "Ev"},
  ];
  List<String> learnedWords = [];

  @override
  void initState() {
    super.initState();
    _loadLearnedWords();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 🔹 Uygulama Ön Planda mı?
  bool isAppForeground() {
    return WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
  }

  // 📌 Telefonun kilidi açıldığında çalışır
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!isAppForeground()) {
        _showRandomWordPopup();
      }
    }
  }

  Future<void> _loadLearnedWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      learnedWords = prefs.getStringList("learnedWords") ?? [];
    });
  }

  Future<void> _markAsLearned(String word) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      learnedWords.add(word);
    });
    await prefs.setStringList("learnedWords", learnedWords);
  }

  void _showRandomWordPopup() {
    if (words.isEmpty) return;

    final random = Random();
    final randomWord = words[random.nextInt(words.length)];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentContext != null) {
        showDialog(
          context: navigatorKey.currentContext!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(randomWord["en"]!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              content: Text(randomWord["tr"]!, style: const TextStyle(fontSize: 20)),
              actions: [
                TextButton(
                  onPressed: () {
                    _markAsLearned(randomWord["en"]!);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Öğrendim"),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("İngilizce - Türkçe Sözlük")),
      body: ListView.builder(
        itemCount: words.length,
        itemBuilder: (context, index) {
          final word = words[index];
          final isLearned = learnedWords.contains(word["en"]);
          return ListTile(
            title: Text(word["en"]!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text(word["tr"]!, style: const TextStyle(fontSize: 18)),
            trailing: isLearned ? const Icon(Icons.check, color: Colors.green) : null,
          );
        },
      ),
    );
  }
}
