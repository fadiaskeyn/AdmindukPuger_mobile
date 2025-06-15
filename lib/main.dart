import 'package:adminduk_puger/cubit/submission_cubit.dart';
import 'package:adminduk_puger/form/KIA/kia_under_5.dart';
import 'package:adminduk_puger/screen/setting_account.dart';
import 'package:flutter/material.dart';
import 'package:adminduk_puger/screen/Auth/login.dart';
import 'package:adminduk_puger/screen/splash.dart';
import 'package:adminduk_puger/screen/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adminduk_puger/screen/setting.dart';
import 'package:adminduk_puger/screen/submission.dart';
import 'package:adminduk_puger/form/KTP/new_ktp.dart';
import 'package:adminduk_puger/cubit/Auth/Auth_cubit.dart';
import 'package:adminduk_puger/cubit/Auth/Auth_repository.dart';
import 'package:adminduk_puger/form/kk_form.dart';
import 'package:adminduk_puger/form/akte_lahir.dart';
import 'package:adminduk_puger/form/akte_mati.dart';
import 'package:adminduk_puger/form/surat_pindah.dart';
import 'package:adminduk_puger/screen/Auth/register.dart';
import 'package:adminduk_puger/screen/Auth/verificatoin_screen.dart';
import 'package:adminduk_puger/screen/document.dart';
import 'package:adminduk_puger/form/KTP/ktp_option.dart';
import 'package:adminduk_puger/form/KTP/lost_ktp.dart';
import 'package:adminduk_puger/form/KTP/damaged_ktp.dart';
import 'package:adminduk_puger/form/KIA/kia_option.dart';
import 'package:adminduk_puger/form/KIA/kia5.dart';

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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(home: SplashScreen());
        }
        final token = snapshot.data;

        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => authCubit..loaduser()),
            BlocProvider(
              create: (context) {
                return SubmissionCubit();
              },
              child: HomeScreen(),
            ),
          ],

          child: MaterialApp(
            initialRoute: token == null ? '/splash' : '/home',
            routes: {
              '/splash': (context) => SplashScreen(),
              '/login': (context) => LoginScreen(),
              '/home': (context) => HomeScreen(),
              '/setting': (context) => SettingsPage(),
              '/submission': (context) => SubmissionPage(),
              '/kia_option': (context) => KiaOption(),
              '/under5': (context) => KiaUnder5(),
              '/5tahun': (context) => Kia5(),
              '/newktp': (context) => NewKtp(),
              '/lostktp': (context) => LostKtp(),
              '/damagedktp': (context) => DamagedKtp(),
              '/ktp_option': (context) => KtpOption(),
              '/kkform': (context) => KkForm(),
              '/birthcertif': (context) => BirthCertif(),
              '/diecertif': (context) => DieCertif(),
              '/moving_letter': (context) => MovingForm(),
              '/profile': (context) => SettingAccount(),
              '/regist': (context) => RegisterScreen(),
              '/document': (context) => DocumentPage(),
              '/verify': (context) {
                final args =
                    ModalRoute.of(context)!.settings.arguments
                        as Map<String, dynamic>;
                return VerifyScreen(
                  userId: args["userId"],
                  email: args["email"],
                );
              },
            },
          ),
        );
      },
    );
  }
}
