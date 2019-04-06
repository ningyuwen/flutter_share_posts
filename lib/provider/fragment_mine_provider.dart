import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'package:my_mini_app/been/mine_post_been.dart';
import 'package:my_mini_app/provider/publish_mine_pages_provider.dart';
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
//      PublishMinePagesProvider().dispose();
    }
  }

  @override
  String toString() {
    return super.toString();
  }

  void fetchMinePostData(int userId) async {
    Observable.fromFuture(_getDataFromLocal(userId)).map((String data) {
      if (data.isEmpty) {
        return false;
      }
      _data = MinePost.fromJson(jsonDecode(data));
      return true;
    }).listen((success) {
      print("是否有缓存 is: $success");
      if (success) {
        _fetcher.sink.add(_data);
        //有缓存，还是需要再拉一次数据，如果数据相同则不刷新页面，不同再刷新
      }
      _getDataFromRemote(userId);
    });
  }

  Future<String> _getDataFromLocal(int userId) async {
    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
    String data = await mmkv.getString("/post/getPostsByUserId+$userId");
    return data;
  }

  //从后台获取数据
  Future<dynamic> _getData(int userId) async {
    dynamic map = await ApiUtil.getInstance().netFetch(
        userId == -1 ? "/post/getMyPosts" : "/post/getPostsByUser",
        RequestMethod.GET,
        userId == -1 ? null : {"id": userId},
        null);
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

  void listenFromPublishPageReturn() async {
    PublishMinePagesProvider().getFetcher().listen((Posts post) {
      print("PublishMinePagesProvider() return post is: ${post.position}");
      _data.posts.insert(0, post);
      _data.cost += post.cost;
      _fetcher.sink.add(_data);
    });
  }

  void _saveDataToLocal(int userId, Map map) async {
    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
    await mmkv.setString("/post/getPostsByUserId+$userId", jsonEncode(map));
  }

  void _getDataFromRemote(int userId) async {
    Observable.fromFuture(_getData(userId)).map((map) {
      try {
        if (_data.cost == map['cost']) {
          //相同，不需要刷新
          return false;
        }
        _data = MinePost.fromJson(map);
        _saveDataToLocal(userId, map);
        return true;
      } catch (e) {
        print("catch ${e.toString()}");
        return false;
      }
    }).listen((success) {
      print("是否需要刷新 is: $success");
      if (success) {
        _fetcher.sink.add(_data);
      }
    });
  }
}
