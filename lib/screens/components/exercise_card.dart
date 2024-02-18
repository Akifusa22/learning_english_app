import 'package:edu_pro/model/exercise_model.dart';
import 'package:edu_pro/screens/lessons/lesson1.dart';
import 'package:edu_pro/screens/lessons/lesson2.dart';
import 'package:flutter/material.dart';

class ExerciseList extends StatelessWidget {
  const ExerciseList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.75,
      ),
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          // Xử lý sự kiện khi sản phẩm được nhấn và điều hướng đến màn hình tương ứng
          if (index == 0) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Lesson1(),
            ));
          } else if (index == 1) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Lesson2(),
            ));
          } else if (index == 2) {
          } else if (index == 3) {
          }
        },
        child: CategoryCard(
          product: products[index],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.product,
  }) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity, // Adjust this value for the desired width
        height:
            150.0, // Adjust this value for the desired heightSet the height as per your preference
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: product.color,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            Text(
              product.title,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
