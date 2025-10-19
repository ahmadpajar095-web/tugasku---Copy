# TugasKu: Aplikasi Pengingat Tugas Kuliah

TugasKu adalah aplikasi pelacak tugas sederhana yang dibuat menggunakan Flutter. Aplikasi ini dirancang untuk membantu mahasiswa mengelola daftar mata kuliah beserta tugas-tugas yang terkait dengan setiap mata kuliah.

Aplikasi ini menerapkan konsep CRUD (Create, Read, Update, Delete) penuh dan menggunakan `provider` untuk manajemen state (data) di seluruh aplikasi. 

**Penting:** Data pada versi ini bersifat sementara dan akan **hilang** saat aplikasi ditutup (tidak menggunakan database).

---

## 🚀 Fitur Utama

### Manajemen Mata Kuliah (Halaman Utama)

* **Create**: Menambahkan mata kuliah baru (Nama Matkul, Kelas, Nama Dosen).
* **Read**: Menampilkan semua mata kuliah dalam bentuk daftar kartu (`Card`).
* **Update**: Mengedit data mata kuliah yang sudah ada.
* **Delete**: Menghapus mata kuliah (lengkap dengan dialog konfirmasi agar tidak salah pencet).

### Manajemen Tugas (Halaman Detail)

* **Create**: Menambahkan tugas baru untuk mata kuliah tertentu (Judul Materi, Deadline, Penjelasan).
* **Read**: Menampilkan daftar tugas spesifik untuk mata kuliah yang dipilih.
* **Update**: Mengedit detail tugas yang sudah ada.
* **Delete**: Menghapus tugas (lengkap dengan dialog konfirmasi).

### Fitur Tambahan

* **Status Warna Otomatis**: Halaman utama memiliki penanda status visual di setiap kartu mata kuliah:
    * **Merah**: Ada tugas dengan deadline 1 hari lagi (atau kurang).
    * **Kuning**: Ada tugas dengan deadline lebih dari 1 hari.
    * **Hijau**: Tidak ada tugas yang aktif (semua sudah selesai atau tidak ada tugas sama sekali).
* **Tandai Selesai**: Tugas di halaman detail dapat ditandai sebagai "selesai" menggunakan *checkbox*.
* **Visual Feedback**: Tugas yang sudah selesai akan otomatis dicoret dan warnanya memudar.

---

## 🛠️ Teknologi yang Digunakan

* **Framework:** Flutter
* **Bahasa:** Dart
* **State Management:** `provider`
* **Paket Tambahan:**
    * `intl`: Untuk memformat tanggal deadline agar mudah dibaca.
    * `uuid`: Untuk menghasilkan ID unik bagi setiap mata kuliah dan tugas.

---

## 📂 Struktur Folder

Proyek ini disusun dengan struktur yang rapi untuk memisahkan logika, data, dan tampilan: