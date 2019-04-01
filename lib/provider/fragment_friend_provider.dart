import 'package:bloc/bloc.dart';
import 'package:my_mini_app/been/post_around_been.dart';
import 'package:my_mini_app/provider/base_event.dart';
import 'package:my_mini_app/provider/base_state.dart';
import 'package:my_mini_app/util/api_util.dart';

class FragmentFriendEventLoading extends BaseEvent {
  final LoadType type;

  FragmentFriendEventLoading(this.type);
}

class FragmentFriendEventLoaded extends BaseEvent {}

class FragmentFriendStateLoading extends BaseState {}

enum LoadType { loadMore, refresh }

class FragmentFriendStateLoaded extends BaseState {
  final List<Post> posts;
  final LoadType type;
  final int page;

  FragmentFriendStateLoaded(this.posts, this.type, this.page);
}

class FragmentFriendProvider extends Bloc<BaseEvent, BaseState> {
  int _page = 1;

  @override
  BaseState get initialState => FragmentFriendStateLoading();

//  @override
//  Stream<BaseState> mapEventToState(BaseEvent event) async* {
//    if (event is FragmentFriendEventLoading) {
//      //加载数据
//      List<Post> posts = await getData(_page++);
//      yield FragmentFriendStateLoaded(posts, event.type, _page);
//    }
//  }

  Future<List<Post>> getData(int pageId) async {
    List<Post> posts = new List();
    dynamic list = await ApiUtil.getInstance().netFetch(
        "/post/getPostsAround",
        RequestMethod.GET,
        {"longitude": 113.347868, "latitude": 23.007985, "pageId": pageId},
        null);
    if (list is List) {
      for (var value in list) {
        Post post = Post.fromJson(value);
        print("ningyuwen post username: ${post.username}");
        posts.add(post);
      }
    }
    //不能在then里返回
    return posts;
  }

  @override
  Stream<BaseState> mapEventToState(
      BaseState currentState, BaseEvent event) async* {
    if (event is FragmentFriendEventLoading) {
      //加载数据
      List<Post> posts = await getData(_page++);
      yield FragmentFriendStateLoaded(posts, event.type, _page);
    }
  }
}
