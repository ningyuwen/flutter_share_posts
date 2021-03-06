import 'package:flutter/widgets.dart';
import 'package:my_mini_app/been/post_around_been.dart';
import 'package:my_mini_app/util/api_util.dart';
import 'package:my_mini_app/util/toast_util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';

class FragmentAroundProvider {
  final String _EMPTY = "_empty_";

  final _fetcher = new PublishSubject<List<Posts>>();

  List<Posts> _data = new List();

  bool _firstLoad = true;

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

  //拉取后面页的数据
  Future<ReturnData> fetchQueryList() async {
    dynamic map = await getData(1);
    ReturnData returnData = _convertMap(map, false);
    if (returnData.success) {
      if (_data.length <= 10) {
        _fetcher.sink.add(_data);
      }
    }
    return returnData;
  }

  int lengthOfData() {
    return _data.length;
  }

  ReturnData _convertMap(map, refresh) {
    print(map);
    if (map is List) {
      for (var value in map) {
        Posts post = Posts.fromJson(value);
        if (refresh) {
          _data.insert(0, post);
        } else {
          _data.add(post);
        }
      }
      return ReturnData(true, map.length);
    } else {
      if (_firstLoad) {
        _fetcher.sink.addError(map);
      } else {
        ToastUtil.showToast(map);
      }
      return ReturnData(false, 0);
    }
  }

  //拉取第一页数据
  Future<ReturnData> refreshData() async {
    dynamic map = await getData(1);
    ReturnData returnData = _convertMap(map, true);
    return returnData;
  }

  Future<ReturnData> loadMore() async {
    ReturnData returnData = await fetchQueryList();
    return returnData;
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
            _firstLoad = false;
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
    dynamic map = await ApiUtil.getInstance().netFetch(
        "/post/getPostsAround",
        RequestMethod.GET,
        {"longitude": 113.347868, "latitude": 23.007985, "pageId": pageId},
        null);
    //不能在then里返回
    return map;
  }

  static FragmentAroundProvider newInstance() => new FragmentAroundProvider();

  void deleteDataAtItem(int index) {
    _data.removeAt(index);
  }

  void addDataAtItem(int index, Posts post) {
    _data.insert(index, post);
  }
}

class ReturnData {

  bool success;
  int dataSize;

  ReturnData(this.success, this.dataSize);
}