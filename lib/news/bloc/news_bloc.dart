import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  NewsBloc() : super(NewsInitialState());

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    if (event is AddCommentEvent) {
      yield NewsLoadingState();
      try {
        await _addComment(event.newsId, event.comment);
        yield NewsInitialState();
      } catch (e) {
        yield NewsErrorState('Error al agregar comentario: $e');
      }
    }
  }

  Future<void> _addComment(String newsId, String comment) async {
    DocumentReference newsRef = _firestore.collection('news').doc(newsId);
    List<Map<String, dynamic>> currentComments = [];

    final newsDocument = await newsRef.get();

    if (newsDocument.exists) {
      Map<String, dynamic>? newsData =
          newsDocument.data() as Map<String, dynamic>?;

      if (newsData != null && newsData.containsKey('comentarios')) {
        currentComments =
            List<Map<String, dynamic>>.from(newsData['comentarios']);
      }

      Map<String, dynamic> newComment = {
        'comentario': comment,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
      };
      currentComments.add(newComment);

      await newsRef.update({
        'comentarios': currentComments,
      });
    }
  }
}
