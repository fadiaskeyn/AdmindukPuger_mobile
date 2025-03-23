import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:adminduk_puger/theme.dart';
import 'package:adminduk_puger/cubit/Auth/Auth_cubit.dart';
import 'package:adminduk_puger/cubit/Auth/Auth_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 150),

              // Logo & Title
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Adminduk",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    "PUGER",
                    style: GoogleFonts.poppins(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: dongker,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              const Text('Silahkan login ke akun anda'),

              const SizedBox(height: 20),

              // Email Input
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Masukan Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 20),

              // Password Input
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Masukan Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.remove_red_eye_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    print("Lupa Password pressed");
                  },
                  child: Text(
                    "Lupa Password?",
                    style: TextStyle(color: dongker),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthEmailNotVerified) {
                    // Tampilkan snackbar saat email belum diverifikasi
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Email belum terverifikasi, silahkan cek email',
                        ),
                        duration: Duration(seconds: 5),
                      ),
                    );
                  } else if (state is AuthFailure) {
                    // Tampilkan error message
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.error)));
                  } else if (state is AuthSuccess) {
                    // Navigasi ke halaman beranda atau dashboard
                    Navigator.of(context).pushReplacementNamed('/home');
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed:
                        state is AuthLoading
                            ? null
                            : () {
                              context.read<AuthCubit>().login(
                                _emailController.text,
                                _passwordController.text,
                              );
                            },
                    child:
                        state is AuthLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text('Masuk'),
                  );
                },
              ),

              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "Belum punya akun? ",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: "Daftar",
                      style: TextStyle(
                        color: dongker,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, '/regist');
                            },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
