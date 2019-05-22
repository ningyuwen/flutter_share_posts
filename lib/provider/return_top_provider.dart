
import 'package:rxdart/rxdart.dart';

class ReturnTopProvider {

  final _fetcher = new PublishSubject<int>();

  int _indexPage = 0;

  Observable<int> stream() => _fetcher.stream;

  void dispose() {
    if (!_fetcher.isClosed) {
      _fetcher.close();
    }
  }

  void addEvent(int indexPage) {
    _indexPage = indexPage;
    _fetcher.sink.add(_indexPage);
  }

  ReturnTopProvider._internal() {
    print("创建了对象");
  }

  factory ReturnTopProvider() {
    return _instance;
  }

  static final ReturnTopProvider _instance = new ReturnTopProvider._internal();

}