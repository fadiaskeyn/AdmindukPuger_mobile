import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:adminduk_puger/widget/upload_photo.dart';
import 'package:adminduk_puger/cubit/Auth/Auth_cubit.dart';
import 'package:adminduk_puger/cubit/Auth/Auth_state.dart';

import 'package:form_builder_validators/form_builder_validators.dart';

class KkForm extends StatefulWidget {
  KkForm({Key? key}) : super(key: key);

  @override
  _KKFormState createState() => _KKFormState();
}

class _KKFormState extends State<KkForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState?.saveAndValidate() == true) {
      setState(() => _isLoading = true);

      final authState = context.read<AuthCubit>().state;
      if (authState is! AuthSuccess) {
        setState(() => _isLoading = false);
        return;
      }

      final userId = authState.userId;
      final token = authState.token;
      final formData = FormData.fromMap({
        'user_id': userId,

        'name': _formKey.currentState!.value['name'],
        'form': await MultipartFile.fromFile(
          _formKey.currentState!.value['form'][0].path,
        ),
        'ktp': await MultipartFile.fromFile(
          _formKey.currentState!.value['ktp'][0].path,
        ),
        'maried_certificated': await MultipartFile.fromFile(
          _formKey.currentState!.value['maried_certificated'][0].path,
        ),
      });

      try {
        Dio dio = Dio();
        Response response = await dio.post(
          'https://admindukpuger.punyapadias.my.id/api/kk',
          data: formData,
          options: Options(
            headers: {"Au_KtpFormStatethorization": "Bearer $token"},
          ),
        );

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
        title: const Text('Pembuatan Kartu Keluarga'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
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
                    const SizedBox(height: 20),

                    ImagePickerField(
                      name: 'form',
                      labelText:
                          'Upload foto Formulir Perekaman yang sudah diisi',
                      maxImages: 1,
                    ),
                    const SizedBox(height: 15),
                    ImagePickerField(
                      name: 'ktp',
                      labelText: 'Upload Foto KTP',
                      maxImages: 1,
                    ),
                    const SizedBox(height: 20),
                    ImagePickerField(
                      name: 'maried_certificated',
                      labelText: 'Akte Nikah jika sudah menikah',
                      maxImages: 1,
                    ),
                    const SizedBox(height: 10),

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
    );
  }
}
