import 'package:flutter/material.dart';
import 'package:adminduk_puger/theme.dart';
import 'package:adminduk_puger/widget/bottom_nav.dart';
import 'package:adminduk_puger/widget/submission_list.dart';

class SubmissionPage extends StatelessWidget {
  final int _currentIndex = 1;

  final List<String> _routes = ['/home', '/submission', '/setting'];

  void _onTap(BuildContext context, int index) {
    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Background Header
          Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomCenter,
                colors: [putih, biru],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(34),
                bottomRight: Radius.circular(34),
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 30), // Spasi atas
                Text(
                  "Pengajuan Dokumen",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15), // Spasi atas
                _buildSearchBar(), // Search Bar
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: SubmissionList(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => _onTap(context, index),
      ),
    );
  }
}

Widget _buildSearchBar() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 1),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white, // Latar belakang putih
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Warna shadow
            spreadRadius: 1, // Seberapa luas shadow
            blurRadius: 5, // Seberapa kabur shadow
            offset: Offset(0, 3), // Posisi shadow (horizontal, vertical)
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: "Search",
          filled: true, // Mengaktifkan latar belakang
          fillColor: Colors.white, // Latar belakang TextField tetap putih
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.blue,
            ), // Menambahkan warna border saat fokus
          ),
        ),
      ),
    ),
  );
}
