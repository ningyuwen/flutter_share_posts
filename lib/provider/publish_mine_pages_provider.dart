import 'package:my_mini_app/been/consume_post_been.dart';
import 'package:rxdart/rxdart.dart';

class PublishMinePagesProvider {
  PublishMinePagesProvider._internal();

  factory PublishMinePagesProvider() {
    return _instance;
  }

  static final PublishMinePagesProvider _instance =
      new PublishMinePagesProvider._internal();

  final _fetcher = new PublishSubject<Posts>();

  void dispose() {
    if (!_fetcher.isClosed) {
      _fetcher.close();
    }
  }

  PublishSubject<Posts> getFetcher() {
    return _fetcher;
  }

  void addPost(Posts post) {
//    _fetcher.startWith(post);
//  _fetcher.add(event)
    _fetcher.add(post);
  }
}
