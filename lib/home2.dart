import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preview extends StatefulWidget {
  const Preview({Key? key}) : super(key: key);

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  bool isLoading = true;
  List<String> images = [];
  @override
  void initState() {
    getCounterValue();
    super.initState();
  }

  Future<void> getCounterValue() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedImages = prefs.getStringList('images') ?? [];
    images.addAll(savedImages);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      body: isLoading
          ? const CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Uploaded Images',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, right: 10, left: 10),
                            child: Image.network(
                              images[index],
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
    );
  }
}
