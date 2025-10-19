// lib/models/tugas.dart
import 'package:uuid/uuid.dart';

class Tugas {
  final String id;
  String judulMateri;
  DateTime deadline;
  String penjelasan;
  bool isSelesai;

  Tugas({
    String? id, // Dibuat opsional untuk edit
    required this.judulMateri,
    required this.deadline,
    required this.penjelasan,
    this.isSelesai = false,
  }) : id = id ?? const Uuid().v4();
}
