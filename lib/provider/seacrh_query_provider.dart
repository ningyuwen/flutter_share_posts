import 'package:flutter/material.dart';
import 'package:my_mini_app/been/post_around_been.dart';
import 'package:my_mini_app/util/api_util.dart';
import 'package:rxdart/rxdart.dart';

class SearchQueryProvider {
  final String _EMPTY = "_empty_";

  final _fetcher = new PublishSubject<List<Posts>>();

  List<Posts> _data = new List();

  stream() => _fetcher.stream;

  SearchQueryProvider () {
    print("创建对象");
  }

  void dispose() {
    if (!_fetcher.isClosed) {
      _fetcher.close();
    }
  }

  static SearchQueryProvider newInstance() => new SearchQueryProvider();

  Widget streamBuilder<T>({
    T initialData,
    Function success,
    Function error,
    Function empty,
    Function loading,
    Function finished,
  }) {
    return StreamBuilder(
        stream: stream(),
        initialData: initialData,
        builder: (context, AsyncSnapshot<T> snapshot) {
          if (finished != null) {
            finished();
          }
          print("是否有数据：${snapshot.hasData}");
          if (_data.isNotEmpty) {
            return success(_data);
          }
          if (snapshot.hasData) {
            if (success != null) return success(snapshot.data);
          } else if (snapshot.hasError) {
            final errorStr = snapshot.error;
            if (errorStr == _EMPTY) {
              if (empty != null) return empty();
            } else {
              if (error != null) return error(errorStr);
            }
          } else {
            if (loading != null) return loading();
          }
        });
  }

  void fetchQueryTag(String keyword) {
    if (keyword.toString().isEmpty) {
      if (_data.isNotEmpty) {
        _fetcher.sink.add(_data);
      }
    } else {
      Observable.fromFuture(_queryData(keyword)).map((List<Posts> data) {
        if (data.isEmpty) {
          return false;
        }
        _data = data;
        return true;
      }).listen((success) {
        if (success) {
          _fetcher.sink.add(_data);
        } else {
          _fetcher.sink.addError("未找到您想要的内容，请切换关键词再次尝试");
        }
      });
    }
  }

  Future<List<Posts>> _queryData(String keyword) async {
    print("keyword is: $keyword");
    List<Posts> data = new List();
    dynamic map = await ApiUtil.getInstance().netFetch("/search/queryByKeyword",
        RequestMethod.GET, {"keyword": keyword}, null);
    print(map);
    if (map is List) {
      if (map.isEmpty) {
        return data;
      }
      for (var item in map) {
//        print(item.toString());
        data.add(Posts.fromJson(item));
      }
    } else {
      print("不是list");
    }
    return data;
  }
}
