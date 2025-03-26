import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adminduk_puger/theme.dart';
import 'package:adminduk_puger/widget/bottom_nav.dart';
import 'package:adminduk_puger/widget/submission_list.dart';
import 'package:adminduk_puger/cubit/submission_cubit.dart';
import 'package:adminduk_puger/cubit/Auth/Auth_cubit.dart';

class SubmissionPage extends StatefulWidget {
  const SubmissionPage({super.key});

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  final int _currentIndex = 1;
  final List<String> _routes = ['/home', '/submission', '/setting'];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final authCubit = context.read<AuthCubit>();
    final String userId = authCubit.getUserId().toString();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubmissionCubit>().fetchSubmissions();
    });

    // Tambahkan listener untuk TextEditingController untuk memantau input pencarian
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi ini akan dipanggil setiap kali teks di search bar berubah
  void _onSearchChanged() {
    final query = _searchController.text;
    context.read<SubmissionCubit>().filterSubmissions(query);
  }

  void _onTap(BuildContext context, int index) {
    Navigator.pushReplacementNamed(context, _routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomCenter,
                  colors: [putih, biru],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(34),
                  bottomRight: Radius.circular(34),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Pengajuan Dokumen",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  _buildSearchBar(),
                ],
              ),
            ),

            // Biarkan SubmissionList yang handle scroll
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child:
                    SubmissionList(), // Sesuaikan SubmissionList dengan hasil filter
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNav(
          currentIndex: _currentIndex,
          onTap: (index) => _onTap(context, index),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 1),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: "Search",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
      ),
    );
  }
}
