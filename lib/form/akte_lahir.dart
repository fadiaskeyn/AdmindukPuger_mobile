import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:adminduk_puger/widget/upload_photo.dart';
import 'package:adminduk_puger/cubit/Auth/Auth_cubit.dart';
import 'package:adminduk_puger/cubit/Auth/Auth_state.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class BirthCertif extends StatefulWidget {
  BirthCertif({Key? key}) : super(key: key);

  @override
  _KtpFormState createState() => _KtpFormState();
}

class _KtpFormState extends State<BirthCertif> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState?.saveAndValidate() == true) {
      setState(() => _isLoading = true);
      print("Form valid, mulai submit...");

      final authState = context.read<AuthCubit>().state;
      if (authState is! AuthSuccess) {
        print("User tidak login, membatalkan submit");
        setState(() => _isLoading = false);
        return;
      }
      final String status = "Diproses";
      final userId = authState.userId;
      final token = authState.token;
      print("User ID: $userId");

      final formData = FormData.fromMap({
        'user_id': userId,
        'name': _formKey.currentState!.value['name'],
        'form': await MultipartFile.fromFile(
          _formKey.currentState!.value['form'][0].path,
        ),
        'mom_ktp': await MultipartFile.fromFile(
          _formKey.currentState!.value['mom_ktp'][0].path,
        ),
        'dad_ktp': await MultipartFile.fromFile(
          _formKey.currentState!.value['dad_ktp'][0].path,
        ),
        'maried_certif': await MultipartFile.fromFile(
          _formKey.currentState!.value['maried_certif'][0].path,
        ),
        'birth_certificate': await MultipartFile.fromFile(
          _formKey.currentState!.value['birth_certificate'][0].path,
        ),
        'new_kk': await MultipartFile.fromFile(
          _formKey.currentState!.value['new_kk'][0].path,
        ),
        'witness1_ktp': await MultipartFile.fromFile(
          _formKey.currentState!.value['witness1_ktp'][0].path,
        ),
        'witness2_ktp': await MultipartFile.fromFile(
          _formKey.currentState!.value['witness2_ktp'][0].path,
        ),
        'status': status,
      });
      print("Mengirim data ke API...");

      try {
        Dio dio = Dio();
        Response response = await dio.post(
          'https://adminduk-kec-puger.my.id/api/birthcertif',
          data: formData,
          options: Options(headers: {"Authorization": "Bearer $token"}),
        );

        print("Respons diterima: ${response.data}");

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Upload berhasil')));
          _formKey.currentState?.reset();
          Navigator.pushNamed(context, '/home');
        } else {
          throw Exception('Upload gagal');
        }
      } catch (e) {
        print("Terjadi kesalahan: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Pembuatan Akte Kelahiran'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Silahkan lengkapi Dokumen yang diperlukan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      FormBuilderTextField(
                        name: 'name',
                        decoration: const InputDecoration(
                          labelText: 'Nama Pengaju',
                          border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      const SizedBox(height: 15),

                      ImagePickerField(
                        name: 'form',
                        labelText:
                            'Upload foto Formulir Perekaman yang sudah diisi',
                        maxImages: 1,
                      ),

                      const SizedBox(height: 15),
                      ImagePickerField(
                        name: 'mom_ktp',
                        labelText: 'Upload Foto KTP Ibu',
                        maxImages: 1,
                      ),
                      const SizedBox(height: 20),
                      ImagePickerField(
                        name: 'dad_ktp',
                        labelText: 'Upload Foto KTP Ayah',
                        maxImages: 1,
                      ),
                      const SizedBox(height: 20),
                      ImagePickerField(
                        name: 'maried_certif',
                        labelText: 'Upload Foto Akte Nikah',
                        maxImages: 1,
                      ),
                      const SizedBox(height: 20),
                      ImagePickerField(
                        name: 'birth_certificate',
                        labelText:
                            'Foto Keterangan Lahir dari Rumah Sakit atau RT',
                        maxImages: 1,
                      ),
                      const SizedBox(height: 20),
                      ImagePickerField(
                        name: 'new_kk',
                        labelText: 'Foto Kartu Keluarga Terbaru',
                        maxImages: 1,
                      ),
                      const SizedBox(height: 20),
                      ImagePickerField(
                        name: 'witness1_ktp',
                        labelText: 'Foto KTP Saksi 1',
                        maxImages: 1,
                      ),
                      const SizedBox(height: 20),
                      ImagePickerField(
                        name: 'witness2_ktp',
                        labelText: 'Foto KTP Saksi 2',
                        maxImages: 1,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child:
                                _isLoading
                                    ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : const Text(
                                      'Kirim',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            onPressed: _isLoading ? null : _submitForm,
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.deepPurple),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              'Reset',
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                            onPressed:
                                _isLoading
                                    ? null
                                    : () {
                                      _formKey.currentState?.reset();
                                    },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
