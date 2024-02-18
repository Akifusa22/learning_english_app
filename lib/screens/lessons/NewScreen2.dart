import 'package:edu_pro/screens/components/category_card.dart';
import 'package:flutter/material.dart';

class NewScreen2 extends StatelessWidget {
  const NewScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: Text(
          'Lý thuyết về cách phát âm',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 54, 30, 171),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 7,
        iconTheme: IconThemeData(color: Colors.black),
        actionsIconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ExerciseList2(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
