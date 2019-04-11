import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'package:my_mini_app/been/detail_comment.dart';
import 'package:my_mini_app/been/post_detail_argument.dart';
import 'package:my_mini_app/been/post_detail_been.dart';
import 'package:my_mini_app/provider/auth_provider.dart';
import 'package:my_mini_app/util/api_util.dart';
import 'package:my_mini_app/util/toast_util.dart';
import 'package:rxdart/rxdart.dart';

class DetailPageProvider {
  final String _EMPTY = "_empty_";

  final _fetcher = new PublishSubject<PostDetail>();

  PostDetail _data = new PostDetail();

  stream() => _fetcher.stream;

  final _userFriendFetcher = new PublishSubject<bool>();

//  bool _isUserFriend = false;

  userFriendStream() => _userFriendFetcher.stream;

  void dispose() {
    if (!_fetcher.isClosed) {
      _fetcher.close();
      _userFriendFetcher.close();
      _saveDataToLocal();
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

  static DetailPageProvider newInstance() => new DetailPageProvider();

  void getDetailData(PostDetailArgument postDetailArgument) async {
    //先读取缓存
    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
    // 读取缓存数据
    String localData = await mmkv
        .getString("/post/getPostDetails+${postDetailArgument.postId}");
    if ("" != localData) {
      //有缓存数据
      print("localData has data is: $localData");
      _data = PostDetail.fromJson(jsonDecode(localData));
      _fetcher.sink.add(_data);
      print("isFriend 1: ${_data.isFriend}");
      _userFriendFetcher.sink.add(_data.isFriend);
      print("全局刷新");
    } else {
      print("没有缓存数据");
      _userFriendFetcher.sink.add(false);
    }

    dynamic map = await ApiUtil.getInstance().netFetch(
        "/post/getPostDetails",
        RequestMethod.GET,
        {
          "id": postDetailArgument.postId,
          "longitude": postDetailArgument.longitude,
          "latitude": postDetailArgument.latitude
        },
        null);
//    print("详情页面数据：$map");
    if (map is Map) {
      String remoteData = jsonEncode(map);
      if (remoteData != localData) {
        print("不相同");
        mmkv.setString(
            "/post/getPostDetails+${postDetailArgument.postId}", remoteData);
        _data = PostDetail.fromJson(map);
        _fetcher.sink.add(_data);
        print("isFriend 2: ${_data.isFriend}");
        _userFriendFetcher.sink.add(_data.isFriend);
        print("全局刷新");
      } else {
        print("相同");
        _userFriendFetcher.sink.add(_data.isFriend);
      }
    }
  }

  Future<DetailComment> _postCommentToRemote(int postId, String content) async {
    dynamic map = await ApiUtil.getInstance().netFetch("/comment/comment",
        RequestMethod.POST, {"postId": postId, "content": content}, null);
    print("_postCommentToRemote() map is: $map");
    DetailComment comment =
        DetailComment.fromJson(map); //为了适配，后台返回字段不一致的问题，commentId和id
    comment.commentId = map["id"];
    return comment;
  }

  void postComment(int postId, String content) async {
    DetailComment comment = await _postCommentToRemote(postId, content);
    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
    comment.headUrl = await mmkv.getString("headUrl");
    comment.username = await mmkv.getString("username");
    _data.mCommentList.insert(0, comment);
    print("评论成功: ${comment.content} commentId is: ${comment.commentId}");
    _fetcher.sink.add(_data);
  }

  void postUserFriend(bool isFriend) {
    if (!AuthProvider().isLogin()) {
      AuthProvider().showLoginDialog("添加关注需要您先登录，是否需要进行登录？");
      return;
    }
    if (isFriend) {
      //取消关注
      Observable.fromFuture(_postCancelUserFriend()).listen((success) {
        if (success) {
          _data.isFriend = false;
          _userFriendFetcher.sink.add(_data.isFriend);
        } else {
          ToastUtil.showToast("取消关注失败，请稍后重试...");
        }
      });
    } else {
      //关注
      Observable.fromFuture(_postUserFriend()).listen((success) {
        if (success) {
          _data.isFriend = true;
          _userFriendFetcher.sink.add(_data.isFriend);
        } else {
          ToastUtil.showToast("关注失败，请稍后重试...");
        }
      });
    }
  }

  Future<bool> _postUserFriend() async {
    dynamic map = await ApiUtil.getInstance().netFetch("/user/userFriend",
        RequestMethod.POST, {"targetUserId": _data.userId}, null);
    if ("" == map) {
      return true;
    }
    return false;
  }

  Future<bool> _postCancelUserFriend() async {
    dynamic map = await ApiUtil.getInstance().netFetch("/user/cancelUserFriend",
        RequestMethod.POST, {"targetUserId": _data.userId}, null);
    if ("" == map) {
      return true;
    }
    return false;
  }

  void deleteComment(DetailComment comment) {
    Observable.fromFuture(_deleteComment(comment.commentId)).listen((success) {
      if (success) {
        //删除成功，刷新页面
        _data.comments--;
        _data.mCommentList.remove(comment);
        _fetcher.sink.add(_data);
      } else {
        ToastUtil.showToast("删除失败，请稍后重试");
      }
    });
  }

  Future<bool> _deleteComment(int commentId) async {
    dynamic map = await ApiUtil.getInstance().netFetch("/comment/deleteComment",
        RequestMethod.POST, {"commentId": commentId}, null);
    if ("" == map) {
      return true;
    }
    return false;
  }

  void _saveDataToLocal() async {
//    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
//    mmkv.setString(
//        "/post/getPostDetails+${_data.id}", jsonEncode(_data.toJson()));
  }
}
