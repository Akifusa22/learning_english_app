import 'dart:async';

import 'package:flutter/material.dart';

class Lesson2 extends StatefulWidget {
  @override
  State<Lesson2> createState() => _Lesson2State();
}

class _Lesson2State extends State<Lesson2> {
  Map<String, bool> languageStates = {};
  final List<String> imagePaths = [
    'assets/images/hientaitiepdien3-1.jpg',
    'assets/images/hientaitiepdien3-2.jpg',
    'assets/images/hientaitiepdien3-3.jpg',
    'assets/images/hientaitiepdien3-4.jpg',
  ];

  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _startAutoPlay();
  }

  void _startAutoPlay() {
  _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
    if (_currentPage < imagePaths.length - 1) {
      _currentPage++;
    } else {
      _currentPage = 0;
    }

    if (_pageController.hasClients) {
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  });
}


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          title: Text(
            'Thì hiện tại tiếp diễn',
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
                      'Thì hiện tại tiếp diễn là thì được dùng để diễn tả những sự việc/hành động '
                      'xảy ra ngay lúc chúng ta nói hoặc xung quanh thời điểm nói, và hành động/sự việc '
                      'đó vẫn chưa chấm dứt (còn tiếp tục diễn ra) trong thời điểm nói.',
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
                            context, 'assets/images/hientaitiepdien1.png');
                      },
                      child: Transform.scale(
                        scale: 0.8,
                        child: Image.asset(
                          'assets/images/hientaitiepdien1.png',
                          fit: BoxFit.cover,
                          width: 400, // Đặt chiều rộng theo kích thước ảnh
                          height: 220, // Đặt chiều cao theo kích thước ảnh
                        ),
                      ),
                    )
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
                          "1. Diễn tả một hành động đang xảy ra ngay tại thời điểm nói:",
                          [
                            {
                              "vietnamese": "Trời đang mưa",
                              "english": "It’s raining now"
                            },
                            {
                              "vietnamese": "Cô ấy đang xem phim",
                              "english": "She is watching a movie"
                            },
                          ]),
                      buildUsageCategoryTile(
                          "2. Đề cập đến một hành động hoặc sự việc đang diễn ra nhưng không nhất thiết phải xảy ra ngay lúc nói:",
                          [
                            {
                              "vietnamese":
                                  "Tôi hiện đang viết mã cho ứng dụng",
                              "english":
                                  "I am currently writing code for the application"
                            },
                            {
                              "vietnamese": "Tom đang tìm việc",
                              "english": "Tom is looking for a job"
                            },
                          ]),
                      buildUsageCategoryTile(
                          "3. Diễn tả một hành động sẽ xảy ra trong tương lai gần, thường là đề cập về kế hoạch đã được lên lịch sẵn:",
                          [
                            {
                              "vietnamese":
                                  "Nam sẽ bay đến Hà Nội vào ngày mai",
                              "english": "Nam is flying to Ha Noi tomorrow"
                            },
                          ]),
                      buildUsageCategoryTile(
                          "4. Diễn tả một sự phàn nàn về hành động nào đó do người khác gây ra, thường đi cùng với always:",
                          [
                            {
                              "vietnamese":
                                  "Anh ấy luôn gây ồn ào khi tôi đang cố gắng làm việc",
                              "english":
                                  "He always makes noise when I am trying to work"
                            },
                            {
                              "vietnamese": "An lúc nào cũng đến trễ",
                              "english": "An is always coming late"
                            },
                          ]),
                      buildUsageCategoryTile(
                          "5. Diễn tả sự phát triển, thay đổi theo hướng tích cực hơn:",
                          [
                            {
                              "vietnamese":
                                  "Kỹ năng tiếng anh của tôi đang được cải thiện nhờ có EduPro",
                              "english":
                                  "My English skills are improving thanks to EduPro"
                            },
                          ]),
                      buildUsageCategoryTile(
                          "6. Mô tả sự đổi mới (sự khác biệt so với ngày trước và bây giờ:",
                          [
                            {
                              "vietnamese":
                                  "Hầu hết mọi người đang sử dụng email thay vì viết thư",
                              "english":
                                  "Almost people are using email instead of writing letters"
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
                            context, 'assets/images/hientaitiepdien2.jpg');
                      },
                      child: Hero(
                        tag: 'enlarged-image2',
                        child: Image.asset(
                          'assets/images/hientaitiepdien2.jpg',
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
                    Container(
                      height: 200, // Điều chỉnh độ cao của Slider theo nhu cầu
                      child: PageView.builder(
                        itemCount: imagePaths.length,
                        controller: _pageController,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            imagePaths[index],
                            fit: BoxFit.cover,
                          );
                        },
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
