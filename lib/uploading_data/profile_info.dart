import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  File? profilepic;

  void saveUser() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String ageString = ageController.text.trim();

    int age = int.parse(ageString);

    nameController.clear();
    emailController.clear();
    ageController.clear();

    if (name != "" && email != "" && profilepic != null) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("profilepictures")
          .child(Uuid().v1())
          .putFile(profilepic!);

      // StreamSubscription taskSubscription =
      //     uploadTask.snapshotEvents.listen((snapshot) {
      //   double percentage =
      //       snapshot.bytesTransferred / snapshot.totalBytes * 100;
      //   log(percentage.toString());
      // });

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // taskSubscription.cancel();

      Map<String, dynamic> userData = {
        "userId": widget.userId,
        "name": name,
        "email": email,
        "age": age,
        "profilepic": downloadUrl,
        "samplearray": [name, email, age, widget.userId]
      };
      FirebaseFirestore.instance.collection("users").add(userData);
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      log("User created!");
    } else {
      log("Please fill all the fields!");
    }

    setState(() {
      profilepic = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              // logOut();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              CupertinoButton(
                onPressed: () async {
                  XFile? selectedImage =
                      await ImagePicker().pickImage(source: ImageSource.camera);

                  if (selectedImage != null) {
                    File convertedFile = File(selectedImage.path);
                    setState(() {
                      profilepic = convertedFile;
                    });
                    log("Image selected!");
                  } else {
                    log("No image selected!");
                  }
                },
                padding: EdgeInsets.zero,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      (profilepic != null) ? FileImage(profilepic!) : null,
                  backgroundColor: Colors.grey,
                ),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: "Name"),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(hintText: "Email Address"),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(hintText: "Age"),
              ),
              SizedBox(
                height: 10,
              ),
              CupertinoButton(
                onPressed: () {
                  saveUser();
                },
                child: Text("Save"),
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("age", isGreaterThanOrEqualTo: 19)
                    .orderBy("age", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> userMap =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(userMap["profilepic"]),
                              ),
                              title: Text(userMap["name"] +
                                  " (${userMap["age"]})" +
                                  " (${userMap["userId"]})"),
                              subtitle: Text(userMap["email"]),
                              trailing: IconButton(
                                onPressed: () {
                                  // Delete
                                },
                                icon: Icon(Icons.delete),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Text("No data!");
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
