import 'package:flutter/material.dart';

class Product {
  final String title;
  final int id;
  final Color color;

  Product({
    required this.title,
    required this.color,
    required this.id,
  });
}

List<Product> products = [
  Product(
    id: 1,
    title: "Thì hiện tại đơn",
    color: Color(0xFF71b8ff),
  ),
  Product(
    id: 2,
    title: "Thì hiện tại tiếp diễn",
    color: Color(0xFFff6374),
  ),
  Product(
    id: 3,
    title: "Thì hiện tại hoàn thành",
    color: Color(0xFFffaa5b),
  ),
  Product(
    id: 4,
    title: "Thì hiện tại hoàn thành tiếp diễn",
    color: Color(0xFF9ba0fc),
  ),
  Product(
    id: 5,
    title: "Thì quá khứ đơn",
    color: Color(0xFF9ba0fc),
  ),
  Product(
    id: 6,
    title: "Thì quá khứ tiếp diễn",
    color: Color.fromARGB(255, 96, 50, 122),
  ),
  Product(
    id: 7,
    title: "Thì quá khứ hoàn thành",
    color: Color.fromARGB(255, 84, 84, 95),
  ),
  Product(
    id: 8,
    title: "Thì quá khứ hoàn thành tiếp diễn",
    color: Color.fromARGB(255, 33, 16, 29),
  ),
  Product(
    id: 9,
    title: "Thì tương lai đơn",
    color: Color.fromARGB(255, 96, 50, 122),
  ),
  Product(
    id: 10,
    title: "Thì tương lai tiếp diễn",
    color: Color.fromARGB(255, 106, 135, 20),
  ),
  Product(
    id: 11,
    title: "Thì tương lai hoàn thành",
    color: Color.fromARGB(255, 79, 69, 30),
  ),
  Product(
    id: 12,
    title: "Thì tương lai hoàn thành tiếp diễn",
    color: Color.fromARGB(255, 88, 181, 181),
  ),
];
