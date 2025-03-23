import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adminduk_puger/cubit/submission_cubit.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmissionList extends StatelessWidget {
  const SubmissionList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmissionCubit, List<Map<String, dynamic>>>(
      builder: (context, pengajuanList) {
        if (pengajuanList.isEmpty) {
          return const Center(child: Text("Tidak ada pengajuan"));
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pengajuanList.length,
          itemBuilder: (context, index) {
            final pengajuan = pengajuanList[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              color: Colors.white,
              child: SizedBox(
                height: 80,
                width: double.infinity,
                child: ListTile(
                  title: Text(
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    pengajuan["nama"] ?? "",
                  ),
                  subtitle: Text(pengajuan["jenis"] ?? ""),
                  trailing: SizedBox(
                    width: 120,
                    height: 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          width: 90,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:
                                pengajuan["status"] == "Ditolak"
                                    ? Colors.red[100]
                                    : pengajuan["status"] == "Diproses"
                                    ? Colors.amber[100]
                                    : Colors.green[100],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            pengajuan["status"] ?? "",
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  pengajuan["status"] == "Ditolak"
                                      ? Colors.red[800]
                                      : pengajuan["status"] == "Diproses"
                                      ? Colors.amber[800]
                                      : Colors.green[800],
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          pengajuan["tanggal"] ?? "",
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
