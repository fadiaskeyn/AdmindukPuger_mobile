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
            assetPath: 'assets/images/icons/documents.png',
            label: "Daftar\nFormulir",
          ),
          _buildCategoryItem(
            assetPath: 'assets/images/icons/riwayat.png',
            label: "Riwayat\nPengajuan",
            onTap: () {
              Navigator.pushNamed(context, '/submission');
            },
          ),
          _buildCategoryItem(
            icon: Icons.help_outline,
            label: "Bantuan &\nPanduan",
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem({
    IconData? icon,
    String? assetPath,
    VoidCallback? onTap,
    required String label,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                icon != null
                    ? Icon(icon, color: Colors.blue, size: 24)
                    : Image.asset(assetPath!, width: 24, height: 24),
          ),
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
          CardItem(
            title: "Kartu Tanda\nPenduduk (KTP)",
            iconPath: "ktp.png",
            onPress: () {
              Navigator.pushNamed(context, '/ktpform');
              print('diclick');
            },
          ),
          CardItem(
            title: "Kartu Keluarga\n(KK)",
            iconPath: "kk.png",
            onPress: () {
              Navigator.pushNamed(context, '/kkform');
              print('diclick');
            },
          ),
          CardItem(
            title: "Akta Kelahiran",
            iconPath: "aktehidup.png",
            onPress: () {
              Navigator.pushNamed(context, '/birthcertif');
              print('diclick');
            },
          ),
          CardItem(
            title: "Akta Kematian",
            iconPath: "aktemati.png",
            onPress: () {
              Navigator.pushNamed(context, '/diecertif');
              print('diclick');
            },
          ),
          CardItem(
            title: "Surat Pindah",
            iconPath: "suratpindah.png",
            onPress: () {
              Navigator.pushNamed(context, '/moving_letter');
              print('diclick');
            },
          ),
        ],
      ),
    );
  }
}
