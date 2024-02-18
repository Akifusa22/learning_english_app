import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Lesson1_1_1 extends StatefulWidget {
  @override
  State<Lesson1_1_1> createState() => _Lesson1_1_1State();
}

class _Lesson1_1_1State extends State<Lesson1_1_1> {
  Map<String, bool> languageStates = {};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          title: Text(
            'Quy tắc trọng âm (stress)',
            style: TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 54, 30, 171),
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          elevation: 7,
          iconTheme: IconThemeData(color: Colors.black),
          actionsIconTheme: IconThemeData(color: Colors.black),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 8,
            ),
            // Redesigned Cách sử dụng section
            Card(
              child: ListTile(
                  title: Text(
                    'Từ có 2 âm tiết ',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 54, 30, 171),
                    ),
                  ),
                  subtitle: Column(
                    children: [
                      UsageCategoryTile(
                        title: 'Quy tắc 1:',
                        examples: [
                          'Với các động từ có 2 âm tiết, trọng âm chính được nhấn vào âm tiết thứ 2',
                          'Ví dụ: assist (trợ lý) /əˈsɪst/;',
                          'destroy (phá hủy) /dɪˈstrɔɪ/'
                        ],
                      ),
                      UsageCategoryTile(
                        title: 'Quy tắc 2:',
                        examples: [
                          'Một số từ có trọng âm thay đổi khi từ loại của chúng thay đổi. Đối với từ vừa là danh từ vừa là động từ, nếu là danh từ, trọng âm rơi vào âm tiết thứ nhất, nếu là động từ, trọng âm rơi vào âm tiết thứ 2. ',
                          'Ví dụ: Record (ghi âm) (v) /rɪˈkɔːrd/',
                          'bản ghi âm (n) /ˈrek.ɚd/ ',
                          'Trường hợp ngoại lệ: visit (thăm) /ˈvɪz.ɪt/',
                          'travel (du lịch) /ˈtræv.əl/',
                          'promise (hứa) /ˈprɑː.mɪs/ trọng âm luôn rơi vào âm tiết thứ nhất.',
                        ],
                      ),
                      UsageCategoryTile(
                        title: 'Quy tắc 3:',
                        examples: [
                          'Đa số các danh từ và tính từ có 2 âm tiết, trọng âm chính sẽ rơi vào âm tiết thứ nhất.',
                          'Ví dụ: mountain (núi) /ˈmaʊn.tən/',
                          'handsome (đẹp trai) /ˈhæn.səm/'
                        ],
                      ),
                    ],
                  )),
            ),
            SizedBox(height: 8),
            Card(
              child: ListTile(
                  title: Text(
                    'Từ có 3 âm tiết trở lên',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 54, 30, 171),
                    ),
                  ),
                  subtitle: Column(
                    children: [
                      UsageCategoryTile(
                        title: 'Quy tắc 1:',
                        examples: [
                          'Hầu như các từ tận cùng là đuôi ic, ian, tion, sion, trọng âm sẽ rơi vào âm liền kề trước nó.',
                          'Ví dụ: precision (rõ ràng) /prɪˈsɪʒ.ən/',
                          'scientific (tính khoa học) /ˌsaɪənˈtɪf.ɪk/'
                        ],
                      ),
                      UsageCategoryTile(
                        title: 'Quy tắc 2:',
                        examples: [
                          'Các từ tận cùng là ade, ee, ese, eer, eete, oo, oon, ique, aire, trọng âm nhấn vào chính đuôi nó',
                          'Ví dụ: Vietnamese (Việt Nam) /ˌvjet.nəˈmiːz/',
                          'questionnaire (bản câu hỏi) /ˌkwes.tʃəˈneər/',
                        ],
                      ),
                      UsageCategoryTile(
                        title: 'Quy tắc 3:',
                        examples: [
                          'Các từ tận cùng là al, ful, y, trọng âm nhấn vào âm tiết thứ 3 từ dưới lên',
                          'Ví dụ: natural (tự nhiên) /ˈnætʃ.ər.əl',
                          'ability (khả năng) /əˈbɪl.ə.ti/'
                        ],
                      ),
                      UsageCategoryTile(
                        title: 'Quy tắc 4:',
                        examples: [
                          'Các tiền tố không có trọng âm, thường nhấn vào âm thứ 2',
                          'Ví dụ: unable (không thể) /ʌnˈeɪ.bəl/',
                          'illegal (bất hợp pháp) /ɪˈliː.ɡəl/'
                        ],
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUsageCategoryTile(
    String title,
    List<Map<String, String>> textPairs,
  ) {
    languageStates.putIfAbsent(title, () => true);

    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: textPairs.length,
          itemBuilder: (context, index) {
            final vietnameseExample = textPairs[index]['vietnamese']!;
            final englishExample = textPairs[index]['english']!;

            String selectedText = languageStates[title] ?? true
                ? englishExample
                : vietnameseExample;

            return ListTile(
              title: GestureDetector(
                onTap: () {
                  // Toggle language state for the specific category
                  setState(() {
                    languageStates[title] = !(languageStates[title] ?? true);
                  });
                },
                child: Text(
                  selectedText,
                  style: TextStyle(
                    color: Colors.red, // This sets the text color to red
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class UsageCategoryTile extends StatefulWidget {
  final String title;
  final List<String> examples;

  UsageCategoryTile({required this.title, required this.examples});

  @override
  State<UsageCategoryTile> createState() => _UsageCategoryTileState();
}

class _UsageCategoryTileState extends State<UsageCategoryTile> {
  FlutterTts flutterTts = FlutterTts();
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          widget.title,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 54, 30, 171),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            widget.examples.length,
            (index) => Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: InkWell(
                onTap: () {
                  final lowerCaseExample = widget.examples[index].toLowerCase();
                  if (lowerCaseExample.contains('assist')) {
                    speakAssist();
                  } else if (lowerCaseExample.contains('destroy')) {
                    speakDestroy();
                  } else if (lowerCaseExample.contains('record')) {
                    speakRecord();
                  } else if (lowerCaseExample.contains('visit') ||
                      lowerCaseExample.contains('travel') ||
                      lowerCaseExample.contains('promise')) {
                    speakVisitTravelPromise();
                  } else if (lowerCaseExample.contains('mountain') ||
                      lowerCaseExample.contains('handsome')) {
                    speakMountainHandsome();
                  } else if (lowerCaseExample.contains('precision') ||
                      lowerCaseExample.contains('scientific')) {
                    speakPrecisionScientific();
                  } else if (lowerCaseExample.contains('vietnamese') ||
                      lowerCaseExample.contains('questionnaire')) {
                    speakVietnameseQuestionnaire();
                  } else if (lowerCaseExample.contains('natural') ||
                      lowerCaseExample.contains('ability')) {
                    speakNaturalAbility();
                  } else if (lowerCaseExample.contains('unable') ||
                      lowerCaseExample.contains('illegal')) {
                    speakUnableIllegal();
                  }
                },
                child: Text(
                  '• ${widget.examples[index]}',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> speakAssist() async {
    await flutterTts.speak('assist');
  }

  Future<void> speakDestroy() async {
    await flutterTts.speak('destroy');
  }

  Future<void> speakRecord() async {
    await flutterTts.speak('record');
  }

  Future<void> speakVisitTravelPromise() async {
    await flutterTts.speak('visit, travel, promise');
  }

  Future<void> speakMountainHandsome() async {
    await flutterTts.speak('mountain, handsome');
  }

  Future<void> speakPrecisionScientific() async {
    await flutterTts.speak('precision, scientific');
  }

  Future<void> speakVietnameseQuestionnaire() async {
    await flutterTts.speak('Vietnamese, questionnaire');
  }

  Future<void> speakNaturalAbility() async {
    await flutterTts.speak('natural, ability');
  }

  Future<void> speakUnableIllegal() async {
    await flutterTts.speak('unable, illegal');
  }
}

Widget _buildUsageItem(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Text(
      text,
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 17,
        color: Colors.black,
      ),
    ),
  );
}
