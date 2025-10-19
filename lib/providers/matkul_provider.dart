// lib/providers/matkul_provider.dart
import 'package:flutter/material.dart';
import '../models/mata_kuliah.dart';
import '../models/tugas.dart';

class MatkulProvider extends ChangeNotifier {
  // Database "sementara" kita
  final List<MataKuliah> _items = [];

  List<MataKuliah> get items => [..._items];

  MataKuliah findById(String id) {
    return _items.firstWhere((matkul) => matkul.id == id);
  }

  // --- CRUD Mata Kuliah ---

  void addMatkul(String nama, String kelas, String dosen) {
    final newMatkul = MataKuliah(namaMatkul: nama, kelas: kelas, dosen: dosen);
    _items.add(newMatkul);
    notifyListeners(); // Beri tahu UI untuk update
  }

  void updateMatkul(String id, String nama, String kelas, String dosen) {
    final matkul = findById(id);
    matkul.namaMatkul = nama;
    matkul.kelas = kelas;
    matkul.dosen = dosen;
    notifyListeners();
  }

  void deleteMatkul(String id) {
    _items.removeWhere((matkul) => matkul.id == id);
    notifyListeners();
  }

  // --- CRUD Tugas ---

  void addTugas(
    String matkulId,
    String judul,
    DateTime deadline,
    String penjelasan,
  ) {
    final matkul = findById(matkulId);
    final newTugas = Tugas(
      judulMateri: judul,
      deadline: deadline,
      penjelasan: penjelasan,
    );
    matkul.daftarTugas.add(newTugas);
    notifyListeners();
  }

  void updateTugas(
    String matkulId,
    String tugasId,
    String judul,
    DateTime deadline,
    String penjelasan,
  ) {
    final matkul = findById(matkulId);
    final tugas = matkul.daftarTugas.firstWhere((t) => t.id == tugasId);
    tugas.judulMateri = judul;
    tugas.deadline = deadline;
    tugas.penjelasan = penjelasan;
    notifyListeners();
  }

  void deleteTugas(String matkulId, String tugasId) {
    final matkul = findById(matkulId);
    matkul.daftarTugas.removeWhere((tugas) => tugas.id == tugasId);
    notifyListeners();
  }

  // Fungsi untuk Checkbox (sesuai instruksi)
  void toggleTugasStatus(String matkulId, String tugasId) {
    final matkul = findById(matkulId);
    final tugas = matkul.daftarTugas.firstWhere((t) => t.id == tugasId);
    tugas.isSelesai = !tugas.isSelesai;
    notifyListeners(); // Ini akan otomatis memicu update warna di home page
  }
}
