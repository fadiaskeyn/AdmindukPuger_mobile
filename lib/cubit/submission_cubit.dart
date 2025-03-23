import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SubmissionCubit extends Cubit<List<Map<String, dynamic>>> {
  SubmissionCubit() : super([]);

  String formatTanggal(String? tanggalStr) {
    if (tanggalStr == null || tanggalStr.isEmpty) return "-";

    try {
      // Parse ISO format dari API
      DateTime tanggal = DateTime.parse(tanggalStr);

      // Format ke format Indonesia
      List<String> namaBulan = [
        "Januari",
        "Februari",
        "Maret",
        "April",
        "Mei",
        "Juni",
        "Juli",
        "Agustus",
        "September",
        "Oktober",
        "November",
        "Desember",
      ];

      List<String> namaHari = [
        "Senin",
        "Selasa",
        "Rabu",
        "Kamis",
        "Jumat",
        "Sabtu",
        "Minggu",
      ];

      // Hari dimulai dari 1 (Senin) hingga 7 (Minggu) di DateTime.weekday
      String hari = namaHari[tanggal.weekday - 1];
      String bulan = namaBulan[tanggal.month - 1];

      return "$hari, ${tanggal.day} $bulan ${tanggal.year}";
    } catch (e) {
      print("Error formatting date: $e");
      return tanggalStr ?? "-";
    }
  }

  Future<void> fetchSubmissions(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("Token tidak ditemukan, tidak dapat mengambil data");
      return;
    }

    final url = Uri.parse('http://localhost:8000/api/submission/$userId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Mapping untuk nama kategori yang lebih readable
        final Map<String, String> categoryNames = {
          'birth_certifs': 'Akta Kelahiran',
          'die_certifs': 'Akta Kematian',
          'ektps': 'Kartu Tanda Penduduk',
          'family_cards': 'Kartu Keluarga',
          'moving_letters': 'Surat Pindah',
        };

        final List<Map<String, dynamic>> formattedData = [];
        data.forEach((key, value) {
          if (value is List) {
            for (var item in value) {
              // Gunakan nama kategori yang lebih baik jika tersedia
              String kategori = categoryNames[key] ?? key;

              formattedData.add({
                "nama": item["name"] ?? "",
                "jenis": kategori,
                "status": item["status"] ?? "belum ada status",
                "tanggal": formatTanggal(item["created_at"]),
              });
            }
          }
        });

        emit(formattedData);
      } else {
        print("Error fetching submissions: ${response.statusCode}");
        print("Error message: ${response.body}");
      }
    } catch (e) {
      print("Error detail: $e");
    }
  }
}
