// lib/models/mata_kuliah.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'tugas.dart';

// Enum untuk status yang diminta
enum StatusTugas { hijau, kuning, merah }

class MataKuliah {
  final String id;
  String namaMatkul;
  String kelas;
  String dosen;
  final List<Tugas> daftarTugas;

  MataKuliah({
    String? id, // Dibuat opsional untuk edit
    required this.namaMatkul,
    required this.kelas,
    required this.dosen,
  }) : id = id ?? const Uuid().v4(),
       daftarTugas = [];

  // INI LOGIKA UTAMA UNTUK STATUS WARNA (sesuai instruksi)
  StatusTugas get status {
    // 1. Filter hanya tugas yang belum selesai
    final tugasAktif = daftarTugas.where((t) => !t.isSelesai).toList();

    // 2. HIJAU: Jika tidak ada tugas aktif (list kosong atau semua selesai)
    if (tugasAktif.isEmpty) {
      return StatusTugas.hijau;
    }

    // 3. Urutkan untuk menemukan deadline terdekat
    tugasAktif.sort((a, b) => a.deadline.compareTo(b.deadline));
    final deadlineTerdekat = tugasAktif.first.deadline;
    final now = DateTime.now();
    final sisaHari = deadlineTerdekat.difference(now).inHours;

    // 4. MERAH: jika deadline sisa 1 hari (24 jam) atau kurang
    if (sisaHari <= 24) {
      return StatusTugas.merah;
    }
    // 5. KUNING: jika deadline masih lama (lebih dari 1 hari)
    else {
      return StatusTugas.kuning;
    }
  }

  // Helper untuk teks status
  String get statusText {
    switch (status) {
      case StatusTugas.hijau:
        return "Aman";
      case StatusTugas.kuning:
        return "Segera"; // Sesuai instruksi: "masih lama"
      case StatusTugas.merah:
        return "Deadline!"; // Sesuai instruksi: "sehari"
    }
  }

  // Helper untuk warna status
  Color get statusColor {
    switch (status) {
      case StatusTugas.hijau:
        return Colors.green.shade600;
      case StatusTugas.kuning:
        return Colors.yellow.shade800;
      case StatusTugas.merah:
        return Colors.red.shade700;
    }
  }
}
