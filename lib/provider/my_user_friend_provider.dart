import 'package:flutter/material.dart';
import 'package:my_mini_app/been/my_user_friend_been.dart';
import 'package:my_mini_app/util/api_util.dart';
import 'package:my_mini_app/util/toast_util.dart';
import 'package:rxdart/rxdart.dart';

class MyUserFriendProvider {
  final String _EMPTY = "_empty_";

  final _fetcher = new PublishSubject<List<MyUserFriendsBeen>>();

  List<MyUserFriendsBeen> _data = new List();

  stream() => _fetcher.stream;

  void dispose() {
    if (!_fetcher.isClosed) {
      _fetcher.close();
      _data.forEach((element) {
        element.publishSubject.close();
      });
    }
  }

  @override
  String toString() {
    return super.toString();
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

  Future<Null> getMyUserFriendsData() async {
    Observable.fromFuture(_getMyUserFriends()).listen((success) {
      if (success) {
        _fetcher.sink.add(_data);
      }
    });
  }

  Future<bool> _getMyUserFriends() async {
    dynamic data = await ApiUtil.getInstance()
        .netFetch("/user/myUserFriends", RequestMethod.GET, {}, null);
    if (data is List) {
      List<MyUserFriendsBeen> list = new List();
      data.forEach((dynamic map) {
        list.add(MyUserFriendsBeen.fromJson(map));
      });
      _data.forEach((MyUserFriendsBeen been) {
        been.publishSubject.sink.add(true);
      });
      _data = list;
      return true;
    } else {
      //错误
      _fetcher.sink.addError(data);
      return false;
    }
  }

  static MyUserFriendProvider newInstance() => new MyUserFriendProvider();

  void postUserFriend(int index, bool isFriend) {
    if (isFriend) {
      //取消关注
      Observable.fromFuture(_postCancelUserFriend(_data[index].userId))
          .listen((success) {
        if (success) {
          _data[index].isFriend = false;
          _data[index].publishSubject.sink.add(_data[index].isFriend);
        } else {
          ToastUtil.showToast("取消关注失败，请稍后重试...");
        }
      });
    } else {
      //关注
      Observable.fromFuture(_postUserFriend(_data[index].userId))
          .listen((success) {
        if (success) {
          _data[index].isFriend = true;
          _data[index].publishSubject.sink.add(_data[index].isFriend);
        } else {
          ToastUtil.showToast("关注失败，请稍后重试...");
        }
      });
    }
  }

  Future<bool> _postUserFriend(int userId) async {
    dynamic map = await ApiUtil.getInstance().netFetch(
        "/user/userFriend", RequestMethod.POST, {"targetUserId": userId}, null);
    if ("" == map) {
      return true;
    }
    return false;
  }

  Future<bool> _postCancelUserFriend(int userId) async {
    dynamic map = await ApiUtil.getInstance().netFetch("/user/cancelUserFriend",
        RequestMethod.POST, {"targetUserId": userId}, null);
    if ("" == map) {
      return true;
    }
    return false;
  }
}
