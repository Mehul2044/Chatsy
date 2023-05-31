import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function imagePickFunction;

  const UserImagePicker({Key? key, required this.imagePickFunction})
      : super(key: key);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _displayPicture;

  void _pickImage(bool isCamera) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage != null) {
      final pickedImageFile = File(pickedImage.path);
      setState(() => _displayPicture = pickedImageFile);
      widget.imagePickFunction(_displayPicture);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
            backgroundImage:
                _displayPicture == null ? null : FileImage(_displayPicture!),
            radius: 40,
            backgroundColor: Theme.of(context).colorScheme.secondary),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () => _pickImage(false),
              icon: const Icon(Icons.image),
              label: const Text("Choose from Gallery"),
            ),
            TextButton.icon(
              onPressed: () => _pickImage(true),
              icon: const Icon(Icons.camera),
              label: const Text("Open Camera"),
            ),
          ],
        )
      ],
    );
  }
}
