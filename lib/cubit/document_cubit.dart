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
      Uri.parse('http://localhost:8000/api/docs'),
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

  Future<void> downloadDocument(String fileName, String url, context) async {
    try {
      // Minta izin
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Izin penyimpanan ditolak")),
        );
        return;
      }
      Directory directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getApplicationDocumentsDirectory();
      }
      String savePath = '${directory.path}/$fileName';
      Dio dio = Dio();
      await dio.download(url, savePath);

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
