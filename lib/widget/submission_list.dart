import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adminduk_puger/cubit/submission_cubit.dart';

class SubmissionList extends StatelessWidget {
  const SubmissionList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmissionCubit, List<Map<String, String>>>(
      builder: (context, pengajuanList) {
        return Column(
          children:
              pengajuanList.map((pengajuan) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 4,
                  ),
                  color: Colors.white,
                  child: Container(
                    width: double.tryParse('390'),
                    child: ListTile(
                      title: Text(pengajuan["nama"] ?? ""),
                      subtitle: Text(pengajuan["jenis"] ?? ""),
                      trailing: Container(
                        width: 100, // Mengatur lebar trailing
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.end, // Rata kanan
                          children: [
                            // Container yang membungkus teks 'status' dan memberikan warna latar belakang
                            Container(
                              padding: EdgeInsets.all(2),
                              color:
                                  pengajuan["status"] == "Ditolak"
                                      ? Colors.red[100]
                                      : pengajuan["status"] == "Proses"
                                      ? Colors.amber[100]
                                      : Colors
                                          .green[100], // Warna latar belakang sesuai status
                              child: Text(
                                pengajuan["status"] ?? "",
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      pengajuan["status"] == "Ditolak"
                                          ? Colors.red
                                          : pengajuan["status"] == "Proses"
                                          ? Colors.amber
                                          : Colors.green,
                                ),
                              ),
                            ),
                            // Tanggal di bawah
                            Container(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                pengajuan["tanggal"] ?? "",
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        );
      },
    );
  }
}
