import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adminduk_puger/cubit/submission_cubit.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmissionList extends StatelessWidget {
  const SubmissionList({super.key});

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength).trimRight() + "...";
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "ditolak":
        return Colors.red[100]!;
      case "diproses":
        return Colors.amber[100]!;
      case "disetujui":
        return Colors.green[100]!;
      default:
        return Colors.grey[200]!;
    }
  }

  Color _getTextColor(String status) {
    switch (status.toLowerCase()) {
      case "ditolak":
        return Colors.red[800]!;
      case "diproses":
        return Colors.amber[800]!;
      case "disetujui":
        return Colors.green[800]!;
      default:
        return Colors.grey[800]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      SubmissionCubit,
      Map<String, List<Map<String, dynamic>>>
    >(
      builder: (context, pengajuanMap) {
        final allList =
            pengajuanMap.entries.expand((entry) => entry.value).toList();

        if (allList.isEmpty) {
          return const Center(child: Text("Belum ada pengajuan"));
        }

        return ListView.builder(
          itemCount: allList.length,
          itemBuilder: (context, index) {
            final item = allList[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Catatan Pengajuan"),
                        content: Text(
                          item["catatan"] ?? "Tidak ada catatan.",
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Tutup"),
                          ),
                        ],
                      );
                    },
                  );
                },
                title: Text(
                  _truncateText(item['nama'] ?? "", 15),
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(item['jenis']),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(item['status']),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        item['status'],
                        style: TextStyle(color: _getTextColor(item['status'])),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item['tanggal'],
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
