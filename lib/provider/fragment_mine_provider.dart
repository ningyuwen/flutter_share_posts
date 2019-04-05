import 'package:flutter/widgets.dart';
import 'package:my_mini_app/been/mine_post_been.dart';
import 'package:my_mini_app/util/api_util.dart';
import 'package:rxdart/rxdart.dart';

class FragmentMineProvider {
  final String _EMPTY = "_empty_";

  final _fetcher = new PublishSubject<MinePost>();

  MinePost _data = new MinePost();

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

  void fetchMinePostData() async {
    Observable.fromFuture(getData()).map((map) {
      try {
        print(map);
        _data = MinePost.fromJson(map);
        print("_data is: ${_data}");
        return true;
      } catch (e) {
        print("catch ${e.toString()}");
        return false;
      }
    }).listen((success) {
      print("success is: $success");
      if (success) {
        _fetcher.sink.add(_data);
      }
    });
  }

  //从后台获取数据
  Future<dynamic> getData() async {
    dynamic map = await ApiUtil.getInstance()
        .netFetch("/post/getMyPosts", RequestMethod.GET, null, null);
    return map;
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

  static FragmentMineProvider newInstance() => new FragmentMineProvider();
}
