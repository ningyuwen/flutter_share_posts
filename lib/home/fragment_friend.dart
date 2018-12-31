import 'package:flutter/material.dart';
import 'package:my_mini_app/been/post_around_been.dart';
import 'package:my_mini_app/util/api_util.dart';
import 'package:my_mini_app/util/toast_util.dart';
import 'package:my_mini_app/home/timeline_two_page.dart';

//从后台获取数据
Future<List<Post>> getData() async {
  List<Post> posts = new List();
  await ApiUtil.getInstance()
      .netFetch("/post/getPostsAround", RequestMethod.GET,
          {"longitude": 113.347868, "latitude": 23.007985, "pageId": 1}, null)
      .then((values) {
    for (var value in values) {
      Post post = Post.fromJson(value);
      print("ningyuwen post username: ${post.username}");
      posts.add(post);
    }
  });
  //不能在then里返回
  return posts;
}

Future<String> loadLastName2(String firstName) async {
  await new Future.delayed(Duration(milliseconds: 200));
  return firstName + 'son';
}


//好友fragment
class FragmentFriend extends StatelessWidget {
  static FragmentFriend _instance;

  factory FragmentFriend() => _getInstance();

  static FragmentFriend get instance => _getInstance();

  FragmentFriend._internal() {
    // 初始化
//    createState();
  }

  static FragmentFriend _getInstance() {
    if (_instance == null) {
      _instance = new FragmentFriend._internal();
    }
    return _instance;
  }

  @override
  Widget build(BuildContext context) {
    return FragmentFriendAndAround();
  }
}

//附近的人fragment
class FragmentAround extends StatelessWidget {
  static FragmentAround _instance;

  factory FragmentAround() => _getInstance();

  static FragmentAround get instance => _getInstance();

  FragmentAround._internal() {
    // 初始化
//    createState();
  }

  static FragmentAround _getInstance() {
    if (_instance == null) {
      _instance = new FragmentAround._internal();
    }
    return _instance;
  }

  @override
  Widget build(BuildContext context) {
    return FragmentFriendAndAround();
  }
}

class FragmentFriendAndAround extends StatefulWidget {
  @override
  FriendState createState() {
    return FriendState();
  }
}

class FriendState extends State<FragmentFriendAndAround>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = new ScrollController();
  List<Post> _posts;

  @override
  void initState() {
    super.initState();
    _posts = List();
    print("post length is: ${_posts.length}");
    setData();
    setOnClickListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
          child: ListView.builder(
            itemCount: _posts.length,
            itemBuilder: (context, index) {
              return PostInfoItem(
                key: new ObjectKey(_posts[index].id),
                data: _posts[index],
              );
            },
            controller: _scrollController,
          ),
          onRefresh: _refresh,
      )
    );
  }

  //下拉刷新
  Future<Null> _refresh() async {
    _posts.clear();
    setData();
    return;
  }

  void setOnClickListener() {
//    _scrollController.addListener(() {
//      print(
//          "fragment_friend scroll position is: ${_scrollController.position}");
//      ToastUtil.showToast(
//          "fragment_friend scroll position is: ${_scrollController.position}");
//    });
  }

  @override
  bool get wantKeepAlive => true;

  void setData() async {
    _posts = await getData();
    setState(() {});
  }
}

class PostInfoItem extends StatefulWidget {
  final Post data;

  PostInfoItem({Key key, this.data}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PostInfoState();
  }
}

class PostInfoState extends State<PostInfoItem> {
  @override
  Widget build(BuildContext context) {
    return TimelineTwoPage(key: widget.key, data: widget.data,);
  }
}
