import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_header.dart';
import 'package:my_mini_app/been/post_around_been.dart';
import 'package:my_mini_app/been/post_detail_argument.dart';
import 'package:my_mini_app/detail/DetailPage.dart';
import 'package:my_mini_app/home/post_item_view.dart';
import 'package:my_mini_app/util/api_util.dart';

//从后台获取数据
Future<List<Post>> getData(int pageId) async {
  List<Post> posts = new List();
  await ApiUtil.getInstance()
      .netFetch(
          "/post/getPostsAround",
          RequestMethod.GET,
          {"longitude": 113.347868, "latitude": 23.007985, "pageId": pageId},
          null)
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
  List<Post> _posts; //保存首页列表数据，下拉刷新，推荐点赞、评论最多，或者热门商家里的点评数据
//  LinkedList _linkedList = new LinkedList as LinkedList<LinkedListEntry>;
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();

  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();

  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    super.initState();
    _posts = List();
    print("post length is: ${_posts.length}");
    setData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    print("fragment show build");
    return EasyRefresh(
        refreshHeader: PhoenixHeader(
          key: _headerKey,
        ),
        firstRefresh: true,
        refreshFooter: ClassicsFooter(
            key: _footerKey,
            loadHeight: 50.0,
            loadText: "加载中",
            loadReadyText: "加载中",
            noMoreText: "已推荐10条点评信息",
            bgColor: Colors.white,
            textColor: Colors.black),
        key: _easyRefreshKey,
        child: ListView.builder(
          itemCount: _posts.length,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return GestureDetector(
              child: PostInfoItem(
                key: new ObjectKey(_posts[index].id),
                data: _posts[index],
              ),
              onTap: () {
                //进入详情页
                PostDetailArgument postDetailArgument = new PostDetailArgument(
                    _posts[index].id, 113.347868, 23.007985);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        new DetailPageLessWidget(postDetailArgument)));
              },
            );
          },
          controller: _scrollController,
        ),
        autoLoad: true,
        onRefresh: () async {
          _refresh();
        },
        loadMore: () async {
          _loadMore();
        });
  }

  //下拉刷新，推荐点赞、评论最多，或者热门商家里的点评数据
  Future<Null> _refresh() async {
    _posts.insertAll(0, await getData(2));
    setState(() {});
    return;
  }

  //上拉加载更多，按照时间顺序排序的点评数据
  Future<Null> _loadMore() async {
    _posts.addAll(await getData(2));
    setState(() {});
    return;
  }

  //控制页面重绘
  @override
  bool get wantKeepAlive => true;

  void setData() async {
    _posts = await getData(1);
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
    return PostItemView(
      key: widget.key,
      data: widget.data,
    );
  }
}
