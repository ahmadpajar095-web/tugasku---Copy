// lib/screens/detail_matkul_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/tugas.dart';
import '../providers/matkul_provider.dart';

class DetailMatkulPage extends StatelessWidget {
  static const routeName = '/detail-matkul';

  const DetailMatkulPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil ID matkul yang dikirim dari halaman sebelumnya
    final matkulId = ModalRoute.of(context)!.settings.arguments as String;

    // Gunakan Consumer agar halaman ini ikut update jika ada perubahan data
    return Consumer<MatkulProvider>(
      builder: (context, provider, child) {
        final matkul = provider.findById(matkulId);
        final daftarTugas = matkul.daftarTugas;
        // Urutkan tugas: yang belum selesai & deadline terdekat di atas
        daftarTugas.sort((a, b) {
          if (a.isSelesai != b.isSelesai) {
            return a.isSelesai ? 1 : -1;
          }
          return a.deadline.compareTo(b.deadline);
        });

        return Scaffold(
          appBar: AppBar(title: Text(matkul.namaMatkul)),
          body: daftarTugas.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada tugas untuk mata kuliah ini.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: daftarTugas.length,
                  itemBuilder: (ctx, index) {
                    final tugas = daftarTugas[index];
                    return TugasCard(tugas: tugas, matkulId: matkulId);
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Panggil dialog untuk Tambah Tugas
              _showTugasDialog(context, provider, matkulId);
            },
            child: const Icon(Icons.add_task),
          ),
        );
      },
    );
  }

  // Dialog untuk TAMBAH atau EDIT Tugas
  void _showTugasDialog(
    BuildContext context,
    MatkulProvider provider,
    String matkulId, [
    Tugas? tugas,
  ]) {
    final isEditing = tugas != null;
    final formKey = GlobalKey<FormState>();

    final judulController = TextEditingController(
      text: tugas?.judulMateri ?? '',
    );
    final penjelasanController = TextEditingController(
      text: tugas?.penjelasan ?? '',
    );
    DateTime? selectedDeadline = tugas?.deadline;

    showDialog(
      context: context,
      builder: (ctx) {
        // Gunakan StatefulBuilder agar dialog bisa update (untuk tanggal)
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? "Edit Tugas" : "Tambah Tugas Baru"),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: judulController,
                        decoration: const InputDecoration(
                          labelText: "Judul Materi/Tugas",
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Judul tidak boleh kosong" : null,
                      ),
                      TextFormField(
                        controller: penjelasanController,
                        decoration: const InputDecoration(
                          labelText: "Penjelasan Tugas",
                        ),
                        maxLines: 3,
                        validator: (value) => value!.isEmpty
                            ? "Penjelasan tidak boleh kosong"
                            : null,
                      ),
                      const SizedBox(height: 16),
                      // Input Deadline
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedDeadline == null
                                  ? "Pilih Deadline..."
                                  : "Deadline: ${DateFormat('dd MMMM yyyy').format(selectedDeadline!)}",
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_month),
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedDeadline ?? DateTime.now(),
                                firstDate: DateTime.now().subtract(
                                  const Duration(days: 30),
                                ),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 365),
                                ),
                              );
                              if (pickedDate != null) {
                                setDialogState(() {
                                  selectedDeadline = pickedDate;
                                });
                              }
                            },
                          ),
                        ],
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
                    if (formKey.currentState!.validate() &&
                        selectedDeadline != null) {
                      if (isEditing) {
                        // Panggil fungsi Update Tugas
                        provider.updateTugas(
                          matkulId,
                          tugas.id,
                          judulController.text,
                          selectedDeadline!,
                          penjelasanController.text,
                        );
                      } else {
                        // Panggil fungsi Add Tugas
                        provider.addTugas(
                          matkulId,
                          judulController.text,
                          selectedDeadline!,
                          penjelasanController.text,
                        );
                      }
                      Navigator.of(ctx).pop();
                    } else if (selectedDeadline == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Harap pilih tanggal deadline!"),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    }
                  },
                  child: const Text("Simpan"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// WIDGET CARD UNTUK TUGAS
class TugasCard extends StatelessWidget {
  final Tugas tugas;
  final String matkulId;

  const TugasCard({super.key, required this.tugas, required this.matkulId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MatkulProvider>(context, listen: false);

    return Card(
      // Beri warna pudar jika sudah selesai
      color: tugas.isSelesai ? Colors.grey.shade300 : Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(8, 10, 12, 10),
        // Checkbox untuk status selesai (sesuai instruksi)
        leading: Checkbox(
          value: tugas.isSelesai,
          onChanged: (bool? value) {
            // Panggil provider untuk update status
            provider.toggleTugasStatus(matkulId, tugas.id);
          },
          activeColor: Colors.deepPurple,
        ),
        title: Text(
          tugas.judulMateri,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: tugas.isSelesai
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: tugas.isSelesai ? Colors.black54 : Colors.black87,
          ),
        ),
        subtitle: Text(
          "Deadline: ${DateFormat('dd MMM yyyy').format(tugas.deadline)}\n${tugas.penjelasan}",
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tombol Edit
            IconButton(
              icon: Icon(Icons.edit_outlined, color: Colors.grey.shade700),
              onPressed: () {
                // Panggil dialog dari DetailMatkulPage untuk Edit
                (context as Element)
                    .findAncestorWidgetOfExactType<DetailMatkulPage>()
                    ?._showTugasDialog(context, provider, matkulId, tugas);
              },
            ),
            // Tombol Hapus dengan konfirmasi
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
              onPressed: () => _showDeleteConfirmation(context, provider),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog konfirmasi hapus tugas
  void _showDeleteConfirmation(BuildContext context, MatkulProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Hapus Tugas?"),
          content: const Text("Anda yakin ingin menghapus tugas ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Batal"),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                provider.deleteTugas(matkulId, tugas.id);
                Navigator.of(ctx).pop();
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }
}
