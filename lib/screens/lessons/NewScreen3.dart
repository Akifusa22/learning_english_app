import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class NewScreen3 extends StatefulWidget {
  @override
  _NewScreen3State createState() => _NewScreen3State();
}

class _NewScreen3State extends State<NewScreen3> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String word = '';
  String audio = '';
  String spell = '';
  String definite = '';
  String type = '';
  String meaning = '';
  String exampleEN = '';
  String exampleVN = '';

  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    getRandomTopic();
  }

  Future<void> addCurrentWordToFavourite() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String userEmail = user.email ?? '';

        // Reference to the "favourite" collection
        CollectionReference<Map<String, dynamic>> favouriteCollection =
            FirebaseFirestore.instance.collection('favourite');

        // Create a document reference using the user's email
        DocumentReference<Map<String, dynamic>> userDocument =
            favouriteCollection.doc(userEmail);

        // Check if the document already exists
        bool documentExists = (await userDocument.get()).exists;

        if (!documentExists) {
          // If the document doesn't exist, create it with an initial list of words
          await userDocument.set({
            'words': [
              {
                'word': word,
                'type': type,
                'meaning': meaning,
              }
            ]
          });
        } else {
          // If the document exists, update the list of words
          await userDocument.update({
            'words': FieldValue.arrayUnion([
              {
                'word': word,
                'type': type,
                'meaning': meaning,
              }
            ])
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thêm từ yêu thích thành công'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print('Error adding word to favorites: $e');
    }
  }

  // Function to get a random document from the 'topics' collection
  Future<void> getRandomTopic() async {
    try {
      QuerySnapshot<Map<String, dynamic>> topicsSnapshot =
          await FirebaseFirestore.instance.collection('topics').get();
      print("Firebase Data: ${topicsSnapshot.docs.length} documents");
      if (topicsSnapshot.docs.isNotEmpty) {
        int randomIndex =
            DateTime.now().millisecondsSinceEpoch % topicsSnapshot.docs.length;
        Map<String, dynamic> randomTopicData =
            topicsSnapshot.docs[randomIndex].data();

        setState(() {
          word = randomTopicData['word'] ?? '';
          audio = randomTopicData['audio'] ?? '';
          spell = randomTopicData['spell'] ?? '';
          definite = randomTopicData['definite'] ?? '';
          type = randomTopicData['type'] ?? '';
          meaning = randomTopicData['meaning'] ?? '';
          exampleEN = randomTopicData['exampleEN'] ?? '';
          exampleVN = randomTopicData['exampleVN'] ?? '';
        });
        await playSpellAudio();
      }
    } catch (e) {
      print('Error fetching random topic: $e');
    }
  }

  Future<void> playSpellAudio() async {
    if (spell.isNotEmpty) {
      await flutterTts.setLanguage("en-AU");
      await flutterTts.setVolume(1.0); // Volume level (0.0 to 1.0)
      await flutterTts.setSpeechRate(0.5); // Speech rate (0.5 to 2.0)
      await flutterTts.setPitch(1.0); // Pitch level (1.0 is normal)
      await flutterTts.speak(word);
      await flutterTts.isLanguageInstalled("en-AU");

      await flutterTts.areLanguagesInstalled(["en-AU", "en-US"]);
    }
  }

  void dispose() {
    flutterTts.stop(); // Stop TTS when the widget is disposed
    super.dispose();
  }

  // Function to create a new word
  Future<void> createNewWord() async {
    getRandomTopic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: Text(
          word,
          style: TextStyle(
            fontSize: 22,
            color: Color.fromARGB(255, 54, 30, 171),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 7,
        iconTheme: IconThemeData(color: Colors.black),
        actionsIconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  word,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.volume_up),
                  onPressed: playSpellAudio,
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Spell: $spell',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Type: $type',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Meaning: $meaning',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Example (VN): $exampleVN',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Example (EN): $exampleEN',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createNewWord,
              child: Text(
                'Tạo từ mới',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addCurrentWordToFavourite,
              child: Text(
                'Lưu từ vào danh sách yêu thích',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
