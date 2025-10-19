// lib/screens/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/matkul_provider.dart';
import '../models/mata_kuliah.dart';
import 'detail_matkul_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil data dari provider
    final matkulProvider = Provider.of<MatkulProvider>(context);
    final daftarMatkul = matkulProvider.items;

    return Scaffold(
      appBar: AppBar(title: const Text("Pengingat Tugas Kuliah")),
      body: daftarMatkul.isEmpty
          ? const Center(
              child: Text(
                "Belum ada mata kuliah.\nSilakan tambahkan.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: daftarMatkul.length,
              itemBuilder: (ctx, index) {
                final matkul = daftarMatkul[index];
                return MatkulCard(matkul: matkul);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Panggil dialog untuk Tambah Matkul
          _showMatkulDialog(context, matkulProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Dialog untuk TAMBAH atau EDIT Mata Kuliah
  void _showMatkulDialog(
    BuildContext context,
    MatkulProvider provider, [
    MataKuliah? matkul,
  ]) {
    final isEditing = matkul != null;
    final formKey = GlobalKey<FormState>();

    // Isi controller dengan data yang ada jika sedang edit
    final namaController = TextEditingController(
      text: matkul?.namaMatkul ?? '',
    );
    final kelasController = TextEditingController(text: matkul?.kelas ?? '');
    final dosenController = TextEditingController(text: matkul?.dosen ?? '');

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(isEditing ? "Edit Mata Kuliah" : "Tambah Mata Kuliah"),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: namaController,
                    decoration: const InputDecoration(
                      labelText: "Nama Mata Kuliah",
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Nama tidak boleh kosong" : null,
                  ),
                  TextFormField(
                    controller: kelasController,
                    decoration: const InputDecoration(labelText: "Kelas"),
                    validator: (value) =>
                        value!.isEmpty ? "Kelas tidak boleh kosong" : null,
                  ),
                  TextFormField(
                    controller: dosenController,
                    decoration: const InputDecoration(labelText: "Nama Dosen"),
                    validator: (value) =>
                        value!.isEmpty ? "Dosen tidak boleh kosong" : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (isEditing) {
                    // Panggil fungsi Update
                    provider.updateMatkul(
                      matkul.id,
                      namaController.text,
                      kelasController.text,
                      dosenController.text,
                    );
                  } else {
                    // Panggil fungsi Add
                    provider.addMatkul(
                      namaController.text,
                      kelasController.text,
                      dosenController.text,
                    );
                  }
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }
}

// WIDGET CARD UNTUK MATKUL
class MatkulCard extends StatelessWidget {
  final MataKuliah matkul;
  const MatkulCard({super.key, required this.matkul});

  @override
  Widget build(BuildContext context) {
    // Ambil provider (listen: false) untuk fungsi hapus/edit
    final provider = Provider.of<MatkulProvider>(context, listen: false);

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
        title: Text(
          matkul.namaMatkul,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text("${matkul.kelas} - ${matkul.dosen}"),
        // Ini dia penanda status di sebelah kanan (sesuai instruksi)
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Kotak berwarna dan teks status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: matkul.statusColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                matkul.statusText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 4),
            // Tombol Edit
            IconButton(
              icon: Icon(Icons.edit_outlined, color: Colors.grey.shade700),
              onPressed: () {
                // Panggil dialog dari HomePage untuk Edit
                (context as Element)
                    .findAncestorWidgetOfExactType<HomePage>()
                    ?._showMatkulDialog(context, provider, matkul);
              },
            ),
            // Tombol Hapus dengan konfirmasi
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
              onPressed: () => _showDeleteConfirmation(context, provider),
            ),
          ],
        ),
        onTap: () {
          // Pindah ke halaman detail
          Navigator.of(
            context,
          ).pushNamed(DetailMatkulPage.routeName, arguments: matkul.id);
        },
      ),
    );
  }

  // Dialog konfirmasi hapus (sesuai instruksi "pertanyaan ulang")
  void _showDeleteConfirmation(BuildContext context, MatkulProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Hapus Mata Kuliah?"),
          content: const Text(
            "Anda yakin ingin menghapus mata kuliah ini? Semua tugas di dalamnya juga akan terhapus.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Batal"),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                provider.deleteMatkul(matkul.id);
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Mata kuliah berhasil dihapus."),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }
}
