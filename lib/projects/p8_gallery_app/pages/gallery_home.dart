import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class GalleryHomePage extends StatefulWidget {
  const GalleryHomePage({super.key});

  @override
  State<GalleryHomePage> createState() => _GalleryHomePageState();
}

class _GalleryHomePageState extends State<GalleryHomePage> {
  final Color primary = const Color(0xFF53B175);

  final List<File> images = [];
  final ImagePicker _picker = ImagePicker();

  // 📸 Chụp ảnh
  Future<void> _takePhoto() async {
    var status = await Permission.camera.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Camera permission denied")));
      return;
    }

    final XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1080,
    );

    if (file != null) {
      setState(() {
        images.add(File(file.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photo Gallery"),
        backgroundColor: primary,
      ),

      body: images.isEmpty
          ? const Center(
        child: Text(
          "No photos yet.\nTap the camera button to take one!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.file(
              images[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        child: const Icon(Icons.camera_alt, color: Colors.white),
        onPressed: _takePhoto,
      ),
    );
  }
}
