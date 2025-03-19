import 'package:bloc/bloc.dart';

class SubmissionCubit extends Cubit<List<Map<String, String>>> {
  SubmissionCubit()
    : super([
        {
          "nama": "Sulaiman Shadiqin",
          "jenis": "Kartu Keluarga",
          "tanggal": "2 Februari 2025",
          "status": "Ditolak",
        },
        {
          "nama": "Pengguna Lain",
          "jenis": "KTP",
          "tanggal": "2 Februari 2025",
          "status": "Proses",
        },
        {
          "nama": "Sulaiman Shadiqin",
          "jenis": "Kartu Keluarga",
          "tanggal": "2 Mei 2025",
          "status": "Ditolak",
        },
        {
          "nama": "Pengguna Lain",
          "jenis": "KTP",
          "tanggal": "2 Maret 2025",
          "status": "Disetujui",
        },
      ]);
}
