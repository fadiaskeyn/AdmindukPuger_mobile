import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';

class ImagePickerField extends StatelessWidget {
  final String name;
  final String labelText;
  final int maxImages;

  const ImagePickerField({
    Key? key,
    required this.name,
    required this.labelText,
    this.maxImages = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderImagePicker(
      backgroundColor: Colors.white,
      name: name,
      maxImages: maxImages,
      cameraIcon: Icon(Icons.add_a_photo, color: Colors.deepPurple),
      previewAutoSizeWidth: true,
      maxWidth: MediaQuery.of(context).size.width,
      fit: BoxFit.fitWidth,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.deepPurpleAccent.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
