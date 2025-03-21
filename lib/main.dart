import 'package:adminduk_puger/cubit/submission_cubit.dart';
import 'package:flutter/material.dart';
import 'package:adminduk_puger/screen/login.dart';
import 'package:adminduk_puger/screen/splash.dart';
import 'package:adminduk_puger/screen/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adminduk_puger/screen/setting.dart';
import 'package:adminduk_puger/screen/submission.dart';
import 'package:adminduk_puger/form/ktp_form.dart';
import 'package:adminduk_puger/cubit/Auth/Auth_cubit.dart';
import 'package:adminduk_puger/cubit/Auth/Auth_repository.dart';
import 'package:adminduk_puger/form/kk_form.dart';
import 'package:adminduk_puger/form/akte_lahir.dart';
import 'package:adminduk_puger/form/akte_mati.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authCubit = AuthCubit(AuthRepository());

  runApp(MyApp(authCubit: authCubit));
}

class MyApp extends StatelessWidget {
  final AuthCubit authCubit;

  const MyApp({super.key, required this.authCubit});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: authCubit.getToken(),
      builder: (context, snapshot) {
        debugPrint('Token: ${snapshot.data}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(home: SplashScreen());
        }
        final token = snapshot.data;
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => authCubit..loaduser()),
            BlocProvider(create: (context) => SubmissionCubit()),
          ],
          child: MaterialApp(
            initialRoute: token == null ? '/login' : '/home',
            routes: {
              '/splash': (context) => SplashScreen(),
              '/login': (context) => LoginScreen(),
              '/home': (context) => HomeScreen(),
              '/setting': (context) => SettingsPage(),
              '/submission': (context) => SubmissionPage(),
              '/ktpform': (context) => KtpForm(),
              '/kkform': (context) => KkForm(),
              '/birthcertif': (context) => BirthCertif(),
              '/diecertif': (context) => DieCertif(),
            },
          ),
        );
      },
    );
  }
}
