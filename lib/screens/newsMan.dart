// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NewsManejo extends StatefulWidget {
  const NewsManejo({Key? key}) : super(key: key);

  @override
  _NewsManejoState createState() => _NewsManejoState();
}

class _NewsManejoState extends State<NewsManejo> {
  DatabaseReference dbref = FirebaseDatabase.instance.ref();
  final TextEditingController _edtNameController = TextEditingController();
  final TextEditingController _edtDescController = TextEditingController();
  final TextEditingController _edtImageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticias'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dialog(context);
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  void dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: _edtNameController,
                  decoration: const InputDecoration(helperText: "Name"),
                ),
                TextField(
                  controller: _edtDescController,
                  decoration: const InputDecoration(helperText: "Desc"),
                ),
                TextField(
                  controller: _edtImageController,
                  decoration: const InputDecoration(helperText: "Image"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Map<String, dynamic> data ={
                      "name": _edtNameController.text.toString(),
                      "desc": _edtDescController.text.toString(),
                      "image": _edtImageController.text.toString()

                    };
                    dbref.child("News").push().set(data).then((value) {
                        Navigator.of(context).pop();
                    });
                    
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
