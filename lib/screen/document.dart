import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:adminduk_puger/cubit/document_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentPage extends StatelessWidget {
  const DocumentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dokumen',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocProvider(
        create: (context) => DocumentCubit()..loadDocuments(),
        child: BlocBuilder<DocumentCubit, List<DocumentModel>>(
          builder: (context, documents) {
            if (documents.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  color: Colors.white,
                  child: SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: const Icon(Icons.document_scanner),
                      trailing: IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () async {
                          final url =
                              'http://localhost:8000/storage/${documents[index].path}';
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(
                              Uri.parse(url),
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Gagal membuka dokumen')),
                            );
                          }
                        },
                      ),
                      title: Text(
                        documents[index].judul,
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
