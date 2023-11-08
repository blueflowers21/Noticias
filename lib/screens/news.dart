import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sprint1/screens/likeButton.dart';

class NewsItem extends StatefulWidget {
  final QueryDocumentSnapshot newsDoc;
  final bool isLiked;
  final Function toggleLike;

  NewsItem(
      {required this.newsDoc, required this.isLiked, required this.toggleLike});

  @override
  _NewsItemState createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  @override
  Widget build(BuildContext context) {
    final newsData = widget.newsDoc.data() as Map<String, dynamic>;

    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 4,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ListTile(
            leading: const Icon(
              Icons.article,
              size: 48,
              color: Color.fromARGB(255, 0, 26, 158),
            ),
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
          Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 15),
                child: LikeButton(
                  isLiked: widget.isLiked,
                  onTap: () => widget.toggleLike(widget.newsDoc),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 10),
                child: Text(
                  'Likes: ${newsData['likes']?.length ?? 0}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class News extends StatefulWidget {
  final String newID;
  final List<String> likes;
  const News({Key? key, required this.newID, required this.likes})
      : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  Map<String, bool> likedNews = {};

  @override
  void initState() {
    super.initState();
    // Obtén las noticias y sus likes cuando se inicia la pantalla
    _getNewsAndLikes();
  }

  Future<void> _getNewsAndLikes() async {
    final newsCollection = _firestore.collection('news');
    final newsQuery = await newsCollection.get();

    for (final newsDocument in newsQuery.docs) {
      final newsID = newsDocument.id;
      final likes = newsDocument['likes'] as List<dynamic>;
      final isLiked = likes.contains(currentUser?.email);
      likedNews[newsID] = isLiked;
    }

    setState(() {
      // Actualiza el estado para que la pantalla refleje los likes
      likedNews = likedNews;
    });
  }

  void toggleLike(QueryDocumentSnapshot newsDoc) async {
    final newsID = newsDoc.id;
    final isCurrentlyLiked = likedNews[newsID] ?? false;

    final newRef = _firestore.collection('news').doc(newsID);

    if (isCurrentlyLiked) {
      await newRef.update({
        'likes': FieldValue.arrayRemove([currentUser?.email])
      });
    } else {
      await newRef.update({
        'likes': FieldValue.arrayUnion([currentUser?.email])
      });
    }

    setState(() {
      // Actualiza el estado solo para la noticia específica
      likedNews[newsID] = !isCurrentlyLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('news').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final newsDocs = snapshot.data!.docs;
          // Crear una lista de noticias ordenadas por la cantidad de likes
          final sortedNews = List<QueryDocumentSnapshot>.from(newsDocs);
          sortedNews.sort((a, b) {
            final likesA =
                (a.data() as Map<String, dynamic>)['likes']?.length ?? 0;
            final likesB =
                (b.data() as Map<String, dynamic>)['likes']?.length ?? 0;
            return likesB.compareTo(likesA); // Ordenar de manera descendente
          });

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
            itemCount: newsByCategory.length +
                1, // +1 para la sección de noticias populares
            itemBuilder: (context, index) {
              if (index == 0) {
                // La primera sección muestra noticias populares
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Noticias Populares',
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
                      itemCount: sortedNews.length,
                      itemBuilder: (context, index) {
                        final newsDoc = sortedNews[index];
                        final newsID = newsDoc.id;
                        final isLiked = likedNews[newsID] ?? false;

                        return NewsItem(
                          newsDoc: newsDoc,
                          isLiked: isLiked,
                          toggleLike: toggleLike,
                        );
                      },
                    ),
                  ],
                );
              } else {
                // Las siguientes secciones son las noticias organizadas por categoría
                final category = newsByCategory.keys.toList()[index - 1];
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
                        final newsDoc = newsList[index];
                        final newsID = newsDoc.id;
                        final isLiked = likedNews[newsID] ?? false;

                        return NewsItem(
                          newsDoc: newsDoc,
                          isLiked: isLiked,
                          toggleLike: toggleLike,
                        );
                      },
                    ),
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }
}
