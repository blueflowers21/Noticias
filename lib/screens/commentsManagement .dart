// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comments extends StatefulWidget {
  const Comments({Key? key}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot> commentsList = [];

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  void _loadComments() {
    _firestore.collection('comments').get().then((querySnapshot) {
      setState(() {
        commentsList = querySnapshot.docs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: ListView.builder(
        itemCount: commentsList.length,
        itemBuilder: (context, index) {
          final comment = commentsList[index].data() as Map<String, dynamic>;
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                comment['comment'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('User: ${comment['user']}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteComment(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _deleteComment(int index) {
    final commentId = commentsList[index].id;
    _firestore.collection('comments').doc(commentId).delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Comment Eliminated Successfully'),
      ));
      _loadComments();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error when eliminating comment: $error'),
      ));
    });
  }
}

void main() {
  runApp(const MaterialApp(
    home: Comments(),
  ));
}
