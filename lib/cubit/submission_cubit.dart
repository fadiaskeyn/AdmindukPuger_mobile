import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmissionState {
  final Map<String, dynamic> data;
  final List<String> submittedTypes;

  SubmissionState({required this.data, required this.submittedTypes});
}

class SubmissionCubit extends Cubit<Map<String, List<Map<String, dynamic>>>> {
  SubmissionCubit() : super({});

  Map<String, List<Map<String, dynamic>>> _originalSubmissions = {};

  String formatTanggal(String? tanggalStr) {
    if (tanggalStr == null || tanggalStr.isEmpty) return "-";
    try {
      DateTime tanggal = DateTime.parse(tanggalStr);
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

      String hari = namaHari[tanggal.weekday - 1];
      String bulan = namaBulan[tanggal.month - 1];

      return "$hari, ${tanggal.day} $bulan ${tanggal.year}";
    } catch (e) {
      print("Error formatting date: $e");
      return tanggalStr ?? "-";
    }
  }

  List<String> get submittedTypes {
    return _originalSubmissions.keys.toList();
  }

  Future<void> fetchSubmissions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("Token tidak ditemukan, tidak dapat mengambil data");
      return;
    }
    final url = Uri.parse('https://adminduk-kec-puger.my.id/api/submission');
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
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        final Map<String, dynamic> data = jsonData['data'] ?? {};

        Map<String, List<Map<String, dynamic>>> categorizedSubmissions = {};

        for (var category in data.keys) {
          List<dynamic> submissions = data[category];

          categorizedSubmissions[category] =
              submissions.map((item) {
                return {
                  "nama": item["name"] ?? "Tidak diketahui",
                  "jenis": item["type"] ?? category,
                  "status": item["status"] ?? "Belum ada status",
                  "tanggal": formatTanggal(item["created_at"]),
                  "catatan": item["notes"],
                };
              }).toList();
        }

        _originalSubmissions = categorizedSubmissions;
        emit(categorizedSubmissions);
      } else {
        print("Error fetching submissions: ${response.statusCode}");
        print("Error message: ${response.body}");
      }
    } catch (e) {
      print("Error detail: $e");
    }
  }

  void filterSubmissions(String query) {
    if (query.isEmpty) {
      emit(_originalSubmissions);
    } else {
      Map<String, List<Map<String, dynamic>>> filteredData = {};
      _originalSubmissions.forEach((category, submissions) {
        final filteredList =
            submissions.where((submission) {
              final nama = submission['nama'].toLowerCase();
              final jenis = submission['jenis'].toLowerCase();
              final status = submission['status'].toLowerCase();
              final searchQuery = query.toLowerCase();

              return nama.contains(searchQuery) ||
                  jenis.contains(searchQuery) ||
                  status.contains(searchQuery);
            }).toList();

        if (filteredList.isNotEmpty) {
          filteredData[category] = filteredList;
        }
      });

      emit(filteredData);
    }
  }
}
