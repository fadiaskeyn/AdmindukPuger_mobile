import 'package:flutter/material.dart';
import 'package:adminduk_puger/widget/bottom_nav.dart';
import 'package:adminduk_puger/widget/card_item.dart';
import 'package:adminduk_puger/theme.dart';
import 'package:adminduk_puger/widget/header.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<String> _routes = ['/home', '/submission', '/setting'];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan efek melengkung
            SizedBox(
              width: double.infinity,
              child: Container(
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
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    top: 30,
                  ), // Tambahkan padding kiri & atas
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Posisi ke kiri
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Posisi ke atas
                    children: [
                      Text(
                        "Adminduk\nPuger",
                        style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left, // Pastikan teks rata kiri
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ), // Padding tambahan
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildServiceButtons(),
                    SizedBox(height: 10),
                    _buildDocumentGrid(),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceButtons() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCategoryItem(
            icon: Icons.add_circle_outline,
            label: "Daftar\nDokumen",
          ),
          _buildCategoryItem(
            icon: Icons.folder_outlined,
            label: "Riwayat\nPengajuan",
          ),
          _buildCategoryItem(
            icon: Icons.help_outline,
            label: "Bantuan &\nPanduan",
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem({required IconData icon, required String label}) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.blue, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDocumentGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.3,
        children: [
          CardItem(title: "Kartu Tanda\nPenduduk (KTP)", iconPath: "ktp.png"),
          CardItem(title: "Kartu Keluarga\n(KK)", iconPath: "kk.png"),
          CardItem(title: "Akta Kelahiran", iconPath: "aktehidup.png"),
          CardItem(title: "Akta Kematian", iconPath: "aktemati.png"),
          CardItem(title: "Surat Pindah", iconPath: "suratpindah.png"),
        ],
      ),
    );
  }
}
