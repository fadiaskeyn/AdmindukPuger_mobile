import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adminduk_puger/cubit/Auth/Auth_cubit.dart';
import 'package:adminduk_puger/cubit/Auth/Auth_state.dart';

class SettingAccount extends StatefulWidget {
  @override
  _SettingAccountState createState() => _SettingAccountState();
}

class _SettingAccountState extends State<SettingAccount> {
  String name = 'Loading...';
  String email = 'Loading...';
  String phone = 'Loading...';
  String password = '********'; // For display purposes
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Function to load user profile from API
  Future<void> _loadUserProfile() async {
    setState(() {
      isLoading = true;
    });

    final authCubit = context.read<AuthCubit>();
    final userId = await authCubit.getUserId();

    if (userId != null) {
      final profileData = await authCubit.getProfile(userId);

      if (profileData != null) {
        setState(() {
          name = profileData['name'] ?? 'Anonymous';
          email = profileData['email'] ?? 'anonymous@example.com';
          phone = profileData['phone'] ?? 'Tambahkan No. Telp';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat data profil')));
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('User ID tidak ditemukan')));
    }
  }

  Future<void> _editProfile(
    BuildContext context,
    String label,
    String currentValue,
  ) async {
    final controller = TextEditingController(text: currentValue);

    // Step 1: Show dialog, ambil hasil inputan
    final newValue = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Edit $label"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: TextField(
              controller: controller,
              obscureText: label == "Password",
              decoration: InputDecoration(
                hintText: "Masukkan $label baru",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () {
                  final text = controller.text.trim();
                  if (text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$label tidak boleh kosong')),
                    );
                    return;
                  }
                  Navigator.of(context).pop(text); // return value
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Simpan",
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
    );

    // Step 2: Kalau user batal, newValue = null
    if (newValue == null) return;

    // Step 3: Update profile di sini, context aman!
    setState(() {
      isLoading = true;
    });

    final authCubit = context.read<AuthCubit>();
    final userId = await authCubit.getUserId();

    if (userId != null) {
      try {
        switch (label) {
          case "Nama":
            await authCubit.updateProfile(
              userId,
              newValue,
              email,
              phone,
              password,
            );
            setState(() {
              name = newValue;
            });
            break;
          case "Email":
            await authCubit.updateProfile(
              userId,
              name,
              newValue,
              phone,
              password,
            );
            setState(() {
              email = newValue;
            });
            break;
          case "No. Telp":
            await authCubit.updateProfile(
              userId,
              name,
              email,
              newValue,
              password,
            );
            setState(() {
              phone = newValue;
            });
            break;
          case "Password":
            await authCubit.updateProfile(
              userId,
              name,
              email,
              newValue,
              password,
            );
            setState(() {
              password = newValue;
            });
            break;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$label berhasil diperbarui')));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memperbarui $label: $e')));
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Hapus Akun"),
            content: const Text(
              "Apakah Anda yakin ingin menghapus akun? Tindakan ini tidak dapat dibatalkan.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Hapus",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      setState(() {
        isLoading = true;
      });

      final authCubit = context.read<AuthCubit>();
      final userId = await authCubit.getUserId();

      if (userId != null) {
        final success = await authCubit.deleteAccount(userId);

        if (success) {
          // Navigate to login screen
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/login', (route) => false);
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Gagal menghapus akun')));
        }
      }
    }
  }

  Widget buildFormField(
    BuildContext context, {
    required String label,
    required String value,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  isPassword ? '********' : value,
                  style: const TextStyle(color: Colors.black87, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed:
                    () => _editProfile(context, label, isPassword ? '' : value),
                icon: Icon(Icons.edit, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/setting');
          },
        ),
        title: const Text(
          "Pengaturan Akun",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthLoading) {
                    setState(() {
                      isLoading = true;
                    });
                  } else if (state is AuthSuccess) {
                    setState(() {
                      isLoading = false;
                    });
                    // Reload user profile after a successful update
                    _loadUserProfile();
                  } else if (state is AuthFailure) {
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      buildFormField(context, label: "Nama", value: name),
                      const SizedBox(height: 16),
                      buildFormField(context, label: "Email", value: email),
                      const SizedBox(height: 16),
                      buildFormField(context, label: "No. Telp", value: phone),
                      const SizedBox(height: 16),
                      buildFormField(
                        context,
                        label: "Password",
                        value: "********",
                        isPassword: true,
                      ),

                      // Hapus Akun Section
                      const SizedBox(height: 32),
                      Divider(color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hapus Akun",
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Setelah akun dihapus, Seluruh data terkait akun Anda akan dihapus dari sistem.",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _deleteAccount,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Hapus Akun",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "© 2024 Medalert. Semua Hak Dilindungi.",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
