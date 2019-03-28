import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'package:my_mini_app/been/post_detail_argument.dart';
import 'package:my_mini_app/been/post_detail_been.dart';
import 'package:my_mini_app/util/api_util.dart';

//enum BlocEvent { start, loading, loaded, error }

abstract class BaseEvent extends Equatable {}

class DetailPageEventLoading extends BaseEvent {
  PostDetailArgument postDetailArgument;

  DetailPageEventLoading(this.postDetailArgument);
}

class DetailPageEventLoaded extends BaseEvent {}

abstract class BaseState extends Equatable {}

class DetailPageStateLoading extends BaseState {}

class DetailPageStateLoaded extends BaseState {
  PostDetail postDetail;

  DetailPageStateLoaded(this.postDetail);

  @override
  String toString() {
    return super.toString();
  }
}

class DetailPageProvider extends Bloc<BaseEvent, BaseState> {
  @override
  BaseState get initialState => DetailPageStateLoading();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
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
    }
  }
}
