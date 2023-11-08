// ignore_for_file: unrelated_type_equality_checks, unused_import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:univalle_news/controller/image_picker_controller.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  @override
  Widget build(BuildContext context) {
   //final controller = Get.put(ImagePickerController());
    return const Scaffold(
      /*appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: SingleChildScrollView( 
        child: Center(
          child: Column(
            children: [
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
              Obx(() {
                return controller.networkImage.value.isEmpty
                    ? Container()
                    : Image.network(controller.networkImage.value);
              }),
              Text(controller.networkImage.value.toString())
            ],
          ),
        ),
      ),*/
    );
  }
}
