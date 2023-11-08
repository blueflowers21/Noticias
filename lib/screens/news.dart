import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _filter = 'autor';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DropdownButton<String>(
            value: _filter,
            items: ['autor', 'titulo', 'categoria'].map((String choice) {
              return DropdownMenuItem<String>(
                value: choice,
                child: Text('Ordenar por $choice'),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                _filter = value!;
              });
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  _firestore.collection('news').orderBy(_filter).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final newsDocs = snapshot.data!.docs;

                final Map<String, List<QueryDocumentSnapshot>> newsByFilter =
                    {};
                for (var doc in newsDocs) {
                  final newsData = doc.data() as Map<String, dynamic>;
                  final filterValue = newsData[_filter] as String;

                  if (newsByFilter.containsKey(filterValue)) {
                    newsByFilter[filterValue]!.add(doc);
                  } else {
                    newsByFilter[filterValue] = [doc];
                  }
                }

                return ListView.builder(
                  itemCount: newsByFilter.length,
                  itemBuilder: (context, index) {
                    final filterValue = newsByFilter.keys.toList()[index];
                    final newsList = newsByFilter[filterValue]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '$_filter: $filterValue',
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
                            final newsData =
                                newsList[index].data() as Map<String, dynamic>;
                            return Card(
                              margin: const EdgeInsets.all(10),
                              elevation: 4,
                              child: ListTile(
                                leading: const Icon(Icons.article,
                                    size: 48,
                                    color: Color.fromARGB(255, 0, 26, 158)),
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
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                    Text(
                                      'Author: ${newsData['autor']}',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
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
          ),
        ],
      ),
    );
  }
}
