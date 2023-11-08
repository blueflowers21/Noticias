import 'package:sprint1/api/episode.dart';

class Noticias {
  Noticias();

  static List<Noticia> fromJsonList(List<dynamic> jsonList) {
    List<Noticia> listaEpisodio = [];
    if (jsonList != null) {
      for (var noticia in jsonList) {
        final neww = Noticia.fromJson(noticia);
        listaEpisodio.add(neww);
      }
    }
    return listaEpisodio;
  }
}
