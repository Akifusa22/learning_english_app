import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Lesson1 extends StatefulWidget {
  @override
  State<Lesson1> createState() => _Lesson1State();
}

class _Lesson1State extends State<Lesson1> {
  Map<String, bool> languageStates = {};
  Future<String> createDynamicLink(String refCode) async {
    final String url = "https://com.aokijisapplication.app?ref=$refCode";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      androidParameters: AndroidParameters(
        packageName: "com.aokijisapplication.app",
        minimumVersion: 0,
      ),
      iosParameters: IOSParameters(
        bundleId: "com.aokijisapplication.app",
        minimumVersion: "0",
      ),
      link: Uri.parse(url),
      uriPrefix: "https://aokijisapplication.page.link",
    );

    final FirebaseDynamicLinks link = FirebaseDynamicLinks.instance;

    final refLink = await link.buildShortLink(parameters);

    return refLink.shortUrl.toString();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () async {
                final dynamicLink = await createDynamicLink("lesson1");

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Share Dynamic Link'),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Here is your dynamic link:'),
                          SizedBox(height: 8),
                          SelectableText(dynamicLink),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text('Close'),
                        ),
                        TextButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: dynamicLink));
                            Navigator.of(context).pop(); // Close the dialog
                            // You can show a message here to indicate that the link is copied.
                          },
                          child: Text('Copy'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          title: Text(
            'Thì hiện tại đơn',
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
            Card(
              child: ListTile(
                title: Text(
                  'Tổng quan',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 54, 30, 171),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' Thì hiện tại đơn được dùng để diễn tả một sự thật hiển nhiên hoặc 1 hành động lặp đi lặp lại theo thói quen,…',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        _showImageDialog(
                            context, 'assets/images/hientaidon1.png');
                      },
                      child: Hero(
                        tag: 'enlarged-image1',
                        child: Image.asset(
                          'assets/images/hientaidon1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Redesigned Cách sử dụng section
            Card(
              child: ListTile(
                  title: Text(
                    'Cách sử dụng',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 54, 30, 171),
                    ),
                  ),
                  subtitle: Column(
                    children: [
                      buildUsageCategoryTile(
                          "1. Dùng để diễn tả những hiện tượng, quy luật chung khó có thể thay đổi:",
                          [
                            {
                              "vietnamese":
                                  "Mặt trời mọc ở đằng đông và lặn ở đằng tây",
                              "english":
                                  "The sun rises in the east and sets in the west"
                            },
                            {
                              "vietnamese": "Nước sôi ở 100 độ C",
                              "english": "Water boils at 100 degrees Celsius"
                            },
                          ]),
                      buildUsageCategoryTile(
                          "2. Dùng để diễn tả những thói quen, sở thích hoặc quan điểm:",
                          [
                            {
                              "vietnamese": "Cô ấy thích ăn cơm rang",
                              "english": "She likes to eat fried rice"
                            },
                            {
                              "vietnamese":
                                  "Tôi nghĩ rằng học tiếng Anh rất quan trọng",
                              "english":
                                  "I think learning English is very important"
                            },
                          ]),
                      buildUsageCategoryTile(
                          "3. Dùng để diễn tả những cảm nhận bằng giác quan trong thời điểm nói:",
                          [
                            {
                              "vietnamese": "Tôi thấy trời nắng",
                              "english": "I see it's sunny"
                            },
                            {
                              "vietnamese": "Tôi cảm thấy lạnh",
                              "english": "I feel cold"
                            },
                          ]),
                      buildUsageCategoryTile(
                          "4. Dùng để diễn tả lịch trình đã được định sẵn:", [
                        {
                          "vietnamese": "Chuyến tàu khởi hành lúc 2:30 chiều",
                          "english": "The train departs at 2:30 pm"
                        },
                      ]),
                      // Add more categories as needed
                    ],
                  )),
            ),

            Card(
              child: Container(
                margin: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Công thức',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 54, 30, 171),
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        _showImageDialog(
                            context, 'assets/images/hientaidon3.png');
                      },
                      child: Hero(
                        tag: 'enlarged-image2',
                        child: Image.asset(
                          'assets/images/hientaidon3.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                margin: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Những từ nhận biết',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 54, 30, 171),
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        _showImageDialog(
                            context, 'assets/images/hientaidon2.png');
                      },
                      child: Hero(
                        tag: 'enlarged-image3',
                        child: Image.asset(
                          'assets/images/hientaidon2.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showImageDialog(
                            context, 'assets/images/hientaidon2-2.png');
                      },
                      child: Hero(
                        tag: 'enlarged-image4',
                        child: Image.asset(
                          'assets/images/hientaidon2-2.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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

  void _showImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Hero(
              tag: 'enlarged-image-dialog',
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 500,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}

class UsageCategoryTile extends StatelessWidget {
  final String title;
  final List<String> examples;

  UsageCategoryTile({required this.title, required this.examples});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 17,
        ),
      ),
      children: examples.map((example) => _buildUsageItem(example)).toList(),
    );
  }

  Widget _buildUsageItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 17,
          color: Colors.redAccent,
        ),
      ),
    );
  }
}
