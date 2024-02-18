import 'package:flutter/material.dart';

class Product {
  final String title;
  final int id;
  final Color color;
  Product({
    required this.color,
    required this.id,
    required this.title,
  });
}

List<Product> products = [
  Product(
    id: 1,
    title: "Quy tắc trọng âm (stress)",
    color: Color(0xFF71b8ff),
  ),
  Product(
    id: 2,
    title: "Quy tắc nối âm",
    color: Color(0xFFff6374),
  ),
  Product(
    id: 3,
    title: "Quy tắc chunking (ngắt giọng)",
    color: Color(0xFFffaa5b),
  ),
  Product(
    id: 4,
    title: "Quy tắc intonation (ngữ điệu)",
    color: Color(0xFF9ba0fc),
  ),
  Product(
    id: 5,
    title: "Quy tắc phát âm đuôi",
    color: Color(0xFF9ba0fc),
  ),
];
