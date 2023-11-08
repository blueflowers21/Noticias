// ignore_for_file: file_names, avoid_print

import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:univalle_news/controller/image_picker_controller.dart';

class NewsManagement extends StatefulWidget {
  const NewsManagement({Key? key}) : super(key: key);

  @override
  State<NewsManagement> createState() => _NewsManagementState();
}

class _NewsManagementState extends State<NewsManagement> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  List<DocumentSnapshot> newsList = [];
  int selectedNewsIndex = -1;
   String imageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  void _loadNews() {
    _firestore.collection('news').get().then((querySnapshot) {
      setState(() {
        newsList = querySnapshot.docs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(ImagePickerController());
    return Scaffold(
       appBar: AppBar(
          title: const Text('News Management'),
          backgroundColor: const Color.fromARGB(255, 0, 26, 158),
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Add News:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'New Title'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
              ),             
            ),
            ElevatedButton(
                onPressed: () {
                  controller.pickImage();
                },
                child: const Text('Pick your Image'),
              ),
              Obx(() {
                return Container(
                  child: controller.image.value == null
                      ? const Icon(Icons.camera, size: 50,)
                      : Image.file(                       
                          File(controller.image.value!.path),
                        ),
                );
              }),
                ElevatedButton(
                onPressed: () async {
                  await controller.uploadImageToFirebase();
                },
                child: const Text('Upload to Firebase Storage'),
              ),
                      
            ElevatedButton(
               style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 254, 254, 255), backgroundColor: const Color.fromARGB(255, 0, 26, 158),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
              onPressed: () {
                if (selectedNewsIndex == -1) {                
                  _addNews();                 
                } else {
                  _updateNews(selectedNewsIndex);
                }
              },
              child: Text(selectedNewsIndex == -1 ? 'Add News' : 'Save Changes'),
            ),
            const Divider(),
            if (newsList.isNotEmpty)
              const Text(
                'Existing News:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 10),
            if (newsList.isEmpty)
              const Text('Theres no news :( )'),
            if (newsList.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  final news = newsList[index].data() as Map<String, dynamic>;
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        news['titulo'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Description: ${news['descripcion']}'),
                          Text('Category: ${news['categoria']}'),
                          Text('Author: ${news['autor']}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _editNews(index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deleteNews(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _addNews() {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final category = _categoryController.text;
    final author = _authorController.text;
    final controller = Get.put(ImagePickerController());
    

    if (title.isEmpty || description.isEmpty || category.isEmpty || author.isEmpty) {
      return;
    }

     

    _firestore.collection('news').add({
      'titulo': title,
      'descripcion': description,
      'categoria': category,
      'autor': author,
      'imageURL': controller.networkImage.value.toString(),
      
    }).then((value) {
      _titleController.clear();
      _descriptionController.clear();
      _categoryController.clear();
      _authorController.clear();

      controller.image.value = null;

    controller.networkImage.value = '';
      
      
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Success!'),
      ));
      _loadNews();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $error'),
      ));
    });
  }

  void _updateNews(int index) {
    final newsId = newsList[index].id;
    final title = _titleController.text;
    final description = _descriptionController.text;
    final category = _categoryController.text;
    final author = _authorController.text;
    final controller = Get.put(ImagePickerController());

    if (title.isEmpty || description.isEmpty || category.isEmpty || author.isEmpty) {
      return;
    }

    _firestore.collection('news').doc(newsId).update({
      'titulo': title,
      'descripcion': description,
      'categoria': category,
      'autor': author,
      'imageURL': controller.networkImage.value.toString(),
    }).then((_) {
      _titleController.clear();
      _descriptionController.clear();
      _categoryController.clear();
      _authorController.clear();
      controller.image.value = null;
    controller.networkImage.value = '';
      selectedNewsIndex = -1;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Updated New Succesfully'),
      ));
      _loadNews();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error when updating : $error'),
      ));
    });
  }

  void _editNews(int index) {
  final news = newsList[index].data() as Map<String, dynamic>;
  _titleController.text = news['titulo'];
  _descriptionController.text = news['descripcion'];
  _categoryController.text = news['categoria'];
  _authorController.text = news['autor'];

  final controller = Get.find<ImagePickerController>();

  // Para que el URL se mantenga igual si no se ha cambiado
  if (news['imageURL'] != null && news['imageURL'].isNotEmpty) {
    controller.networkImage.value = news['imageURL'];
  } else {
    controller.image.value = null;
  }

  setState(() {
    selectedNewsIndex = index;
  });
}


  void _deleteNews(int index) {
    final newsId = newsList[index].id;
    _firestore.collection('news').doc(newsId).delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('New Eliminated Succesfully'),
      ));
      _loadNews();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error when eliminating new: $error'),
      ));
    });
  }
}

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: Center(
        child: NewsManagement(),
      ),
    ),
  ));
}
