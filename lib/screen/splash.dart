import 'package:flutter/material.dart';
import 'package:adminduk_puger/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [putih, biru],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar Utama
            Image.asset(
              'assets/images/splash.png', // Path ke gambarr
              height: 200,
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Adminduk",
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.0, // Mengurangi jarak vertikal antar teks
                  ),
                ),
                Text(
                  "PUGER",
                  style: GoogleFonts.poppins(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: dongker,
                    height: 1.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 35),
            // Tombol Masuk
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  SizedBox(height: 150),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Atur berkas berkas penting anda",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          height: 1.0, // Mengurangi jarak vertikal antar teks
                        ),
                      ),
                      Text(
                        "dengan adminduk",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                print("alooo");
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size.fromWidth(250),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Center(
                child: Text(
                  "Mulai Sekarang",

                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
