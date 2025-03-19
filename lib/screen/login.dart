import 'package:adminduk_puger/theme.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true; // Menyimpan status tampilan password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 150),
              Text(
                "Adminduk",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  height: 1.0,
                ),
              ),
              Text(
                "PUGER",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.0,
                ),
              ),
              SizedBox(height: 60),
              Text('Silahkan login ke akun anda', style: TextStyle()),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Masukan Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Sudut melengkung
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                obscureText:
                    _obscureText, // Menggunakan nilai dari _obscureText
                decoration: InputDecoration(
                  labelText: 'Masukan Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Sudut melengkung
                  ),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.remove_red_eye_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText =
                            !_obscureText; // Toggle antara true/false
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight, // Menempatkan teks di kanan
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
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  print("Login button pressed");
                },
                child: Text(
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  'Login',
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  textStyle: TextStyle(fontSize: 18),
                  backgroundColor: dongker,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  maximumSize: Size.fromHeight(150),
                ),
              ),
              SizedBox(
                height: 20,
              ), // Jarak antara tombol Login dan teks pendaftaran
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Belum punya akun? ",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: "Daftar",
                      style: TextStyle(
                        color: dongker,
                        fontWeight: FontWeight.bold,
                      ),
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
