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
                            child: SizedBox(
                              width: 150,
                              height: 200,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          images[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      SizedBox(
                                        height: 150,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text('Lorem Ipsum'),
                                            Text('Lorem Ipsum'),
                                            Text('Lorem Ipsum'),
                                            Text('Lorem Ipsum'),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 80),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: const [
                                          Icon(Icons.share, color: Colors.red),
                                          SizedBox(height: 10),
                                          Icon(Icons.delete, color: Colors.red),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
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
