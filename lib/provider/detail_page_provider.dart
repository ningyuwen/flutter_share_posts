import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'package:my_mini_app/been/detail_comment.dart';
import 'package:my_mini_app/been/post_detail_argument.dart';
import 'package:my_mini_app/been/post_detail_been.dart';
import 'package:my_mini_app/provider/base_event.dart';
import 'package:my_mini_app/provider/base_state.dart';
import 'package:my_mini_app/util/api_util.dart';

//enum BlocEvent { start, loading, loaded, error }

class DetailPageEventLoading extends BaseEvent {
  PostDetailArgument postDetailArgument;

  DetailPageEventLoading(this.postDetailArgument);
}

class DetailPageEventLoaded extends BaseEvent {}

class DetailPageEventPostComment extends BaseEvent {
  int postId;
  String content;

  DetailPageEventPostComment(this.postId, this.content);
}

class DetailPageStateLoading extends BaseState {}

class DetailPageStateLoaded extends BaseState {
  PostDetail postDetail;

  DetailPageStateLoaded(this.postDetail);

  DetailPageStateLoaded copyWith({
    PostDetail detail,
  }) {
    return DetailPageStateLoaded(
        detail ?? this.postDetail
    );
  }

  @override
  String toString() {
    return super.toString();
  }
}

class DetailPageProvider extends Bloc<BaseEvent, BaseState> {
  @override
  BaseState get initialState => DetailPageStateLoading();

//  @override
//  Stream<BaseState> mapEventToState(BaseEvent event) async* {
//    print("mapEventToState() event is: $event");
//    if (event is DetailPageEventLoading) {
//      //先读取缓存
//      MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
//      // 读取缓存数据
//      String localData = await mmkv
//          .getString("/post/getPostDetails+${event.postDetailArgument.postId}");
//      if ("" != localData) {
//        //有缓存数据
//        print("localData has data is: $localData");
//        yield DetailPageStateLoaded(PostDetail.fromJson(jsonDecode(localData)));
//      }
//
//      dynamic map = await ApiUtil.getInstance().netFetch(
//          "/post/getPostDetails",
//          RequestMethod.GET,
//          {
//            "id": event.postDetailArgument.postId,
//            "longitude": event.postDetailArgument.longitude,
//            "latitude": event.postDetailArgument.latitude
//          },
//          null);
//      if (map is Map) {
//        String remoteData = jsonEncode(map);
//        if (remoteData != localData) {
//          print("不相同");
//          mmkv.setString(
//              "/post/getPostDetails+${event.postDetailArgument.postId}",
//              remoteData);
//          yield DetailPageStateLoaded(PostDetail.fromJson(map));
//        } else {
//          print("相同");
//        }
//      }
//    } else if (event is DetailPageEventPostComment) {
//      //发布评论
//      if (currentState is DetailPageStateLoaded) {
//        DetailComment comment = await postComment(event);
//        MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
//        comment.headUrl = await mmkv.getString("headUrl");
//        comment.username = await mmkv.getString("username");
//        PostDetail detail = (currentState as DetailPageStateLoaded).postDetail;
//        detail.mCommentList.insert(0, comment);
//        print("评论成功: ${comment.content}");
////        currentState = state;
////        return;
//
////        (currentState as DetailPageStateLoaded).props.add(comment);
//        yield DetailPageStateLoaded(detail);
//      }
//    }
//  }

  Future<DetailComment> postComment(DetailPageEventPostComment event) async {
    dynamic map = await ApiUtil.getInstance().netFetch(
        "/comment/comment",
        RequestMethod.POST,
        {"postId": event.postId, "content": event.content},
        null);
    return DetailComment.fromJson(map);
  }

  @override
  Stream<BaseState> mapEventToState(BaseState currentState, BaseEvent event) async* {
    print("mapEventToState() event is: $event");
    if (event is DetailPageEventLoading) {
      //先读取缓存
      MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
      // 读取缓存数据
      String localData = await mmkv
          .getString("/post/getPostDetails+${event.postDetailArgument.postId}");
      if ("" != localData) {
        //有缓存数据
        print("localData has data is: $localData");
        yield DetailPageStateLoaded(PostDetail.fromJson(jsonDecode(localData)));
      }

      dynamic map = await ApiUtil.getInstance().netFetch(
          "/post/getPostDetails",
          RequestMethod.GET,
          {
            "id": event.postDetailArgument.postId,
            "longitude": event.postDetailArgument.longitude,
            "latitude": event.postDetailArgument.latitude
          },
          null);
      if (map is Map) {
        String remoteData = jsonEncode(map);
        if (remoteData != localData) {
          print("不相同");
          mmkv.setString(
              "/post/getPostDetails+${event.postDetailArgument.postId}",
              remoteData);
          yield DetailPageStateLoaded(PostDetail.fromJson(map));
        } else {
          print("相同");
        }
      }
    } else if (event is DetailPageEventPostComment) {
      //发布评论
      if (currentState is DetailPageStateLoaded) {
        DetailComment comment = await postComment(event);
        MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
        comment.headUrl = await mmkv.getString("headUrl");
        comment.username = await mmkv.getString("username");
        PostDetail detail = currentState.postDetail;
        detail.mCommentList.insert(0, comment);
        print("评论成功: ${comment.content}");
//        currentState = state;
//        return;

//        (currentState as DetailPageStateLoaded).props.add(comment);
        yield DetailPageStateLoaded(detail);
      }
    }
  }
}
