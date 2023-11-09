import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('News'),
          backgroundColor: const Color.fromARGB(255, 0, 26, 158),
        ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('news').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final newsDocs = snapshot.data!.docs;

          final Map<String, List<QueryDocumentSnapshot>> newsByCategory = {};
          for (var doc in newsDocs) {
            final newsData = doc.data() as Map<String, dynamic>;
            final category = newsData['categoria'] as String;

            if (newsByCategory.containsKey(category)) {
              newsByCategory[category]!.add(doc);
            } else {
              newsByCategory[category] = [doc];
            }
          }
          

          return ListView.builder(
            itemCount: newsByCategory.length,
            itemBuilder: (context, index) {
              final category = newsByCategory.keys.toList()[index];
              final newsList = newsByCategory[category]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Category: $category',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 26, 158),
                      ),
                    ),
                  ),
                 ListView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: newsList.length,
  itemBuilder: (context, index) {
    final newsData = newsList[index].data() as Map<String, dynamic>;
    
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 4,
      child: ListTile(
        leading: newsData['imageURL'] != null && newsData['imageURL'].isNotEmpty
            ? Image.network(
                newsData['imageURL'],
                width: 48,
                height: 48,
              )
            : const Icon(Icons.image, size: 48),
        title: Text(
          newsData['titulo'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description: ${newsData['descripcion']}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              'Author: ${newsData['autor']}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
