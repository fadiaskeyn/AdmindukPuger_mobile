import 'package:adminduk_puger/cubit/submission_cubit.dart';
import 'package:flutter/material.dart';
import 'package:adminduk_puger/screen/login.dart';
import 'package:adminduk_puger/screen/splash.dart';
import 'package:adminduk_puger/screen/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adminduk_puger/screen/setting.dart';
import 'package:adminduk_puger/screen/submission.dart';
import 'package:adminduk_puger/form/ktp_form.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (context) => SubmissionCubit())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: SplashScreen(),
      initialRoute: '/home',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/setting': (context) => SettingsPage(),
        '/submission': (context) => SubmissionPage(),
        '/ktpform': (context) => KtpForm(),
      },
    );
  }
}
