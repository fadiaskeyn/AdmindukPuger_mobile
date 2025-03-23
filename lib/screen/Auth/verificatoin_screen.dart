import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adminduk_puger/cubit/Auth/Auth_cubit.dart';
import 'package:adminduk_puger/cubit/Auth/Auth_state.dart';

class VerifyScreen extends StatelessWidget {
  final int userId;
  final String email;

  const VerifyScreen({super.key, required this.userId, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verifikasi Email")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Email Anda belum diverifikasi",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Kami telah mengirim email verifikasi ke $email. Silakan periksa email Anda dan klik link verifikasi.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
