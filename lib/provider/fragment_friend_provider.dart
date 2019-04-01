import 'package:flutter/widgets.dart';
import 'package:my_mini_app/been/post_around_been.dart';
import 'package:my_mini_app/util/api_util.dart';
import 'package:rxdart/rxdart.dart';

class FragmentFriendProvider {
  final String _EMPTY = "_empty_";

  final _fetcher = new PublishSubject<List<Post>>();

  List<Post> _data = new List();

  stream() => _fetcher.stream;

  void dispose() {
    if (!_fetcher.isClosed) {
      _fetcher.close();
    }
  }

  @override
  String toString() {
    return super.toString();
  }

  void fetchQueryList() async {
    Observable.fromFuture(getData(1)).map((map) {
      try {
        for (var value in map) {
          Post post = Post.fromJson(value);
          print("ningyuwen post username: ${post.username}");
          _data.add(post);
        }
        return true;
      } catch (e) {
        return false;
      }
    }).listen((success) {
      if (success) {
        _fetcher.sink.add(_data);
      }
    });
  }

  void refreshData() async {
    Observable.fromFuture(getData(1)).map((map) {
      try {
        for (var value in map) {
          Post post = Post.fromJson(value);
          print("ningyuwen post username: ${post.username}");
          _data.insert(0, post);
        }
        return true;
      } catch (e) {
        return false;
      }
    }).listen((success) {
      if (success) {
        _fetcher.sink.add(_data);
      }
    });
  }

  void loadMore() async {
    fetchQueryList();
  }

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

  //从后台获取数据
  Future<dynamic> getData(int pageId) async {
//    List<Post> posts = new List();
    dynamic map = await ApiUtil.getInstance().netFetch(
        "/post/getPostsAround",
        RequestMethod.GET,
        {"longitude": 113.347868, "latitude": 23.007985, "pageId": pageId},
        null);
    //不能在then里返回
    return map;
  }

  static FragmentFriendProvider newInstance() => new FragmentFriendProvider();
}
