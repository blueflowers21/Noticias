abstract class NewsEvent {}

class AddCommentEvent extends NewsEvent {
  final String newsId;
  final String comment;

  AddCommentEvent(this.newsId, this.comment);
}
