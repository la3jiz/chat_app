import 'dart:io';

import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File imageFile) imagePickFn;

  UserImagePicker(this.imagePickFn, {super.key});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(''),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              ElevatedButton(
                child: const Text('Camera'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  final _pickedImageFile = await imagePicker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 50,
                      maxWidth: 150);
                  setState(() {
                    if (_pickedImageFile == null) return;
                    _pickedImage = File(_pickedImageFile!.path);
                  });
                  widget.imagePickFn(_pickedImage as File);
                },
              ),
              ElevatedButton(
                child: const Text('Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  final _pickedImageFile =
                      await imagePicker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    if (_pickedImageFile == null) return;
                    _pickedImage = File(_pickedImageFile!.path);
                  });
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white,
          backgroundImage: _pickedImage != null
              ? FileImage(_pickedImage as File)
              : const AssetImage('assets/images/profile_avatar.jpg')
                  as ImageProvider,
        ),
        TextButton.icon(
          style: TextButton.styleFrom(
        foregroundColor: Colors.green,
      ),
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Add Image'),
        ),
      ],
    );
  }
}
