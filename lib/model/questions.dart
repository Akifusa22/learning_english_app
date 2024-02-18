class CauHoi {
  final String id; // ID của câu hỏi
  final String noiDung; // Nội dung câu hỏi
  final String dapAnA; // Đáp án A
  final String dapAnB; // Đáp án B
  final String dapAnC; // Đáp án C
  final String dapAnD; // Đáp án D
  final String dapAnDung; // Đáp án đúng
  final String loaiCauHoi;
  final String giaiThich;
  final String dichNghia;
  String? userAnswer; // User's answer
  bool get isCorrect => userAnswer == dapAnDung;

  CauHoi({
    required this.id,
    required this.noiDung,
    required this.dapAnA,
    required this.dapAnB,
    required this.dapAnC,
    required this.dapAnD,
    required this.dapAnDung,
    required this.loaiCauHoi,
    required this.giaiThich,
    required this.dichNghia,
    this.userAnswer,
  });

  factory CauHoi.fromMap(Map<String, dynamic> map) {
    return CauHoi(
      id: map['id'] ?? '',
      noiDung: map['noiDung'] ?? '',
      dapAnA: map['dapAnA'] ?? '',
      dapAnB: map['dapAnB'] ?? '',
      dapAnC: map['dapAnC'] ?? '',
      dapAnD: map['dapAnD'] ?? '',
      dapAnDung: map['dapAnDung'] ?? '',
      loaiCauHoi: map['loaiCauHoi'] ?? '',
      userAnswer: map['userAnswer'],
      giaiThich: map['giaiThich'] ?? '',
      dichNghia: map['dichNghia'] ?? '',// Add userAnswer directly from the map
    );
  }
}
