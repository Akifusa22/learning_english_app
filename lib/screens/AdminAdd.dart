import 'package:edu_pro/model/questions.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ThemCauHoiScreen extends StatefulWidget {
  @override
  _ThemCauHoiScreenState createState() => _ThemCauHoiScreenState();
}

class _ThemCauHoiScreenState extends State<ThemCauHoiScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController idController = TextEditingController();
  TextEditingController noiDungController = TextEditingController();
  TextEditingController dapAnAController = TextEditingController();
  TextEditingController dapAnBController = TextEditingController();
  TextEditingController dapAnCController = TextEditingController();
  TextEditingController dapAnDController = TextEditingController();
  TextEditingController dapAnDungController = TextEditingController();
  TextEditingController giaiThichController = TextEditingController();
  TextEditingController dichNghiaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm câu hỏi trắc nghiệm'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: idController,
                  decoration: InputDecoration(labelText: 'ID'),
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nhập ID.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: noiDungController,
                  decoration: InputDecoration(labelText: 'Nội Dung Câu Hỏi'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nhập nội dung câu hỏi.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: dapAnAController,
                  decoration: InputDecoration(labelText: 'Đáp án A'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nhập đáp án A.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: dapAnBController,
                  decoration: InputDecoration(labelText: 'Đáp án B'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nhập đáp án B.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: dapAnCController,
                  decoration: InputDecoration(labelText: 'Đáp án C'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nhập đáp án C.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: dapAnDController,
                  decoration: InputDecoration(labelText: 'Đáp án D'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nhập đáp án D.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: dapAnDungController,
                  decoration: InputDecoration(labelText: 'Đáp án đúng'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nhập đáp án đúng.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: giaiThichController,
                  decoration: InputDecoration(labelText: 'Giải thích'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nhập lời giải.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: dichNghiaController,
                  decoration: InputDecoration(labelText: 'Dịch nghĩa'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nhập dịch nghĩa.';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      CauHoi cauHoi = CauHoi(
                        id: idController.text,
                        noiDung: noiDungController.text,
                        dapAnA: dapAnAController.text,
                        dapAnB: dapAnBController.text,
                        dapAnC: dapAnCController.text,
                        dapAnD: dapAnDController.text,
                        dapAnDung: dapAnDungController.text,
                        loaiCauHoi: 'Trắc nghiệm',
                        giaiThich: giaiThichController.text,
                        dichNghia: dichNghiaController.text,
                      );

                      themCauHoi(cauHoi);
                    }
                  },
                  child: Text('Thêm Câu Hỏi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> themCauHoi(CauHoi cauHoi) async {
    try {
      CollectionReference cauHoiCollection =
          FirebaseFirestore.instance.collection('cau_hoi');

      await cauHoiCollection.add({
        'id': cauHoi.id,
        'noiDung': cauHoi.noiDung,
        'dapAnA': cauHoi.dapAnA,
        'dapAnB': cauHoi.dapAnB,
        'dapAnC': cauHoi.dapAnC,
        'dapAnD': cauHoi.dapAnD,
        'dapAnDung': cauHoi.dapAnDung,
        'loaiCauHoi': 'Trắc nghiệm',
        'giaiThich': cauHoi.giaiThich,
        'dichNghia': cauHoi.dichNghia,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Câu hỏi đã được thêm vào Firestore.'),
      ));

      idController.clear();
      noiDungController.clear();
      dapAnAController.clear();
      dapAnBController.clear();
      dapAnCController.clear();
      dapAnDController.clear();
      dapAnDungController.clear();
      giaiThichController.clear();
      dichNghiaController.clear();
    } catch (e) {
      print("Lỗi khi thêm câu hỏi vào Firestore: $e");
    }
  }
}
