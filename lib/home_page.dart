import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final user = FirebaseAuth.instance.currentUser!;
    final prefs = await SharedPreferences.getInstance();
    final List<String> images = prefs.getStringList('images') ?? [];
    final path = 'files/${user.email}/img${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    // ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    images.add(urlDownload);
    prefs.setStringList('images', images);
    print('download link: $urlDownload');

    setState(() {
      uploadTask = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Logout'),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.arrow_back))
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (pickedFile != null) Text(pickedFile!.name),
              // Text(user.email!, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 30),
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  onPressed: selectFile,
                  child: const Text(
                    'Select File',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                    onPressed: uploadFile,
                    child: const Text('Upload File',
                        style: TextStyle(fontSize: 24))),
              ),
              const SizedBox(height: 15),
              buildProgress(),
            ],
          ),
        ));
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;
          return SizedBox(
              height: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey,
                    color: Colors.green,
                  ),
                  Center(
                    child: Text('${(100 * progress).roundToDouble()}%'),
                  )
                ],
              ));
        } else {
          return const SizedBox(height: 50);
        }
      });
}
