import 'package:flutter/material.dart';
import 'package:adminduk_puger/widget/bottom_nav.dart';
import 'package:adminduk_puger/widget/card_item.dart';
import 'package:adminduk_puger/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:adminduk_puger/cubit/submission_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String kontak =
    '<p><b>Langkah langkah mengirim data perekaman :</b></p><ol><li><b>PIlih jenis dokumen yang ingin dibuat (KTP,KK,Akta,dll)</b></li><li><b>Perhatikan jenis formulir yang diperlukan</b></li><li><b>Unduh formulir yang dibutuhkan di fitur "Daftar Formulir"<br></b><img src="data:image/png;base64,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" data-filename="image.png" style="width: 260.5px; height: 142.785px;"></li><li><b>Cetak Formulir di tempat foto copy terdekat</b></li><li><b>Mengisi data formulir&nbsp;</b></li><li><b>Mengisi kelengkapan kebutuhan data pada pembuatan dokumen</b></li><li><b>Apabila masih bingung atau ada yang perlu ditanyakan <a href="http://127.0.0.1:8000" target="_blank">bisa menghubungi admin dengan cara menekan text ini, lalu tekan bagian "Contact"</a></b></li></ol>';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<String> _routes = ['/home', '/submission', '/setting'];

  @override
  void initState() {
    super.initState();
    context.read<SubmissionCubit>().fetchSubmissions();
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final submissionState = context.watch<SubmissionCubit>().state;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
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
                  padding: EdgeInsets.only(left: 20, top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Adminduk\nPuger",
                        style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildServiceButtons(),
                    SizedBox(height: 10),
                    _buildDocumentGrid(
                      submissionState,
                      submissionState.keys.toList(),
                      context,
                    ),
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
            onTap: () {
              Navigator.pushNamed(context, '/document');
            },
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
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.7,
                    minChildSize: 0.3,
                    maxChildSize: 0.95,
                    builder: (context, scrollController) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text(
                              "Kontak Bantuan",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: HtmlWidget(
                                  kontak,
                                  onTapUrl: (url) async {
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(
                                        Uri.parse(url),
                                        mode: LaunchMode.externalApplication,
                                      );
                                    } else {
                                      print("Gagal membuka URL: $url");
                                    }
                                    return true;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Tutup"),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
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

  Widget _buildDocumentGrid(
    Map<String, dynamic> data,
    List<String> submittedTypes,
    BuildContext context,
  ) {
    // Helper untuk ngecek status 'Diproses'
    bool hasPending(List<dynamic>? items) {
      if (items == null) return false;
      return items.any((item) => item['status'] == 'Diproses');
    }

    // Helper buat munculin snackbar
    void showPendingSnackBar() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Anda masih memiliki pengajuan yang berstatus 'Diproses'",
          ),
        ),
      );
    }

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
          if (submittedTypes.contains('ektp'))
            CardItem(
              title: "Kartu Tanda\nPenduduk (KTP)",
              iconPath: "ktp.png",
              onPress:
                  hasPending(data['ektp'])
                      ? showPendingSnackBar
                      : () => Navigator.pushNamed(context, '/ktp_option'),
            ),
          if (submittedTypes.contains('kia'))
            CardItem(
              title: "Kartu Identitas Anak (KIA)",
              iconPath: "kids.png",
              onPress:
                  hasPending(data['kia'])
                      ? showPendingSnackBar
                      : () => Navigator.pushNamed(context, '/kia_option'),
            ),
          if (submittedTypes.contains('kk'))
            CardItem(
              title: "Kartu Keluarga\n(KK)",
              iconPath: "kk.png",
              onPress:
                  hasPending(data['kk'])
                      ? showPendingSnackBar
                      : () => Navigator.pushNamed(context, '/kkform'),
            ),
          if (submittedTypes.contains('birth_certif'))
            CardItem(
              title: "Akta Kelahiran",
              iconPath: "aktehidup.png",
              onPress:
                  hasPending(data['birth_certif'])
                      ? showPendingSnackBar
                      : () => Navigator.pushNamed(context, '/birthcertif'),
            ),
          if (submittedTypes.contains('die_certif'))
            CardItem(
              title: "Akta Kematian",
              iconPath: "aktemati.png",
              onPress:
                  hasPending(data['die_certif'])
                      ? showPendingSnackBar
                      : () => Navigator.pushNamed(context, '/diecertif'),
            ),
          if (submittedTypes.contains('moving_letter'))
            CardItem(
              title: "Surat Pindah",
              iconPath: "suratpindah.png",
              onPress:
                  hasPending(data['moving_letter'])
                      ? showPendingSnackBar
                      : () => Navigator.pushNamed(context, '/moving_letter'),
            ),
        ],
      ),
    );
  }
}
