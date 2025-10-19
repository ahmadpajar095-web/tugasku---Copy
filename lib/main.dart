// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/matkul_provider.dart';
import 'screens/home_page.dart';
import 'screens/detail_matkul_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita bungkus seluruh aplikasi dengan ChangeNotifierProvider
    // agar data bisa diakses dari halaman manapun.
    return ChangeNotifierProvider(
      create: (ctx) => MatkulProvider(),
      child: MaterialApp(
        title: 'Tugas Kuliah App',

        // === INI BAGIAN YANG DIGANTI ===
        // Kita pakai theme versi lama (Material 2) yang pasti kompatibel
        // dengan versi Flutter kamu.
        theme: ThemeData(
          // Ini akan otomatis memberi warna ungu ke AppBar, dll.
          primarySwatch: Colors.deepPurple,
        ),
        // === SELESAI ===

        // Halaman awal kita adalah HomePage
        home: const HomePage(),
        // Kita daftarkan rute untuk halaman detail
        routes: {DetailMatkulPage.routeName: (ctx) => const DetailMatkulPage()},
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
