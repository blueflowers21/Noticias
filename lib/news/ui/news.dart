import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:univalle_news/news/bloc/news_bloc.dart';
import 'package:univalle_news/news/bloc/news_event.dart';
import 'package:univalle_news/news/bloc/news_state.dart';

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Noticias'),
        ),
        body: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state is NewsInitialState) {
              // Mostrar lista de noticias
              return buildNewsList();
            } else if (state is NewsLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is NewsErrorState) {
              return Center(
                child: Text(state.error),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget buildNewsList() {
    final newsBloc = BlocProvider.of<NewsBloc>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('news').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
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

        return ListView.separated(
          itemCount: newsByCategory.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final category = newsByCategory.keys.toList()[index];
            final newsList = newsByCategory[category]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Categoría: $category',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
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
                    final newsId = newsList[index].id;

                    String comment = '';

                    // Crea un controlador para este TextField
                    TextEditingController commentController =
                        TextEditingController();

                    return Card(
                      margin: const EdgeInsets.all(10),
                      elevation: 4,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.article,
                              size: 48,
                              color: Colors.blue,
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
                                  'Descripción: ${newsData['descripcion']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  'Autor: ${newsData['autor']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                TextField(
                                  controller:
                                      commentController, // Asigna el controlador individual
                                  decoration: InputDecoration(
                                    labelText: 'Comentario',
                                  ),
                                  onChanged: (value) {
                                    comment = value;
                                  },
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Agrega el comentario a la noticia correspondiente utilizando el BLoC.
                                    newsBloc
                                        .add(AddCommentEvent(newsId, comment));
                                    commentController
                                        .clear(); // Limpia el controlador individual
                                  },
                                  icon: const Icon(Icons.send),
                                  label: const Text('Enviar'),
                                ),
                              ],
                            ),
                          ),
                          // Mostrar comentarios existentes de esta noticia.
                          if (newsData.containsKey('comentarios'))
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Comentarios:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                for (var commentData in newsData['comentarios'])
                                  Card(
                                    margin: const EdgeInsets.all(8),
                                    child: ListTile(
                                      title: Text(
                                        commentData['comentario'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Fecha: ${commentData['timestamp']}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
