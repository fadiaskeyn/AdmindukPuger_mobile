import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class DocumentCubit extends Cubit<List<DocumentModel>> {
  DocumentCubit() : super([]);

  Future<void> loadDocuments() async {
    final response = await http.get(
      Uri.parse('https://adminduk-kec-puger.my.id/api/docs'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<DocumentModel> documents =
          (data['data'] as List).map((e) => DocumentModel.fromJson(e)).toList();
      emit(documents);
    } else {
      emit([]);
    }
  }

  // Buat fungsi download menjadi static
  static Future<void> downloadDocument(
    String fileName,
    String url,
    BuildContext context,
  ) async {
    try {
      // Minta izin penyimpanan
      if (Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Izin penyimpanan ditolak")),
          );
          return;
        }
      }

      // Tentukan lokasi penyimpanan
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (!await directory.exists()) {
        directory = await getApplicationDocumentsDirectory();
      }

      String savePath = '${directory.path}/$fileName.pdf';

      // Mulai download
      Dio dio = Dio();
      await dio.download(url, savePath);

      // Tampilkan notifikasi berhasil
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Dokumen disimpan di: $savePath")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal download: $e")));
    }
  }
}

class DocumentModel {
  final int id;
  final String judul;
  final String path;

  DocumentModel({required this.id, required this.judul, required this.path});

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'],
      judul: json['name'],
      path: json['location'],
    );
  }
}
