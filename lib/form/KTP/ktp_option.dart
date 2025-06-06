import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KtpOption extends StatelessWidget {
  const KtpOption({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> jenisKtp = ['KTP Baru', 'KTP Hilang', 'KTP Rusak'];
    final List<String> routes = [
      '/newktp',
      '/lostktp',
      '/damagedktp',
    ]; // Sesuaikan dengan route yang kamu definisikan

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jenis Pembuatan KTP',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView.builder(
        itemCount: jenisKtp.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            color: Colors.white,
            child: SizedBox(
              height: 80,
              width: double.infinity,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const Icon(Icons.edit_document),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_circle_right_rounded),
                  onPressed: () {
                    Navigator.pushNamed(context, routes[index]);
                  },
                ),
                title: Text(
                  jenisKtp[index],
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
