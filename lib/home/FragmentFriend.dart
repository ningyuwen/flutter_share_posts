//附近的人fragment
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_header.dart';
import 'package:my_mini_app/been/post_around_been.dart';
import 'package:my_mini_app/been/post_detail_argument.dart';
import 'package:my_mini_app/detail/DetailPage.dart';
import 'package:my_mini_app/home/post_item_view.dart';
import 'package:my_mini_app/provider/base_state.dart';
import 'package:my_mini_app/provider/fragment_friend_provider.dart';

class FragmentAround2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    print("FragmentAround2 createState()");
    return new FriendState();
  }
}

class FriendState extends State<FragmentAround2>
    with AutomaticKeepAliveClientMixin {
  FragmentFriendProvider _provider;
  ScrollController _scrollController = new ScrollController();

//  List<Post> _posts; //保存首页列表数据，下拉刷新，推荐点赞、评论最多，或者热门商家里的点评数据

  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();

  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();

  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    _provider = FragmentFriendProvider();
//    _provider.dispatch(FragmentFriendEventLoading(LoadType.refresh));
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _provider,
        builder: (BuildContext context, BaseState state) {
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
              child: _listViewBuilder(state),
              autoLoad: true,
              onRefresh: () async {
                _refresh();
              },
              loadMore: () async {
                _loadMore();
              });
        });
  }

  //下拉刷新，推荐点赞、评论最多，或者热门商家里的点评数据
  Future<Null> _refresh() async {
    _provider.dispatch(FragmentFriendEventLoading(LoadType.refresh));
  }

  //上拉加载更多，按照时间顺序排序的点评数据
  Future<Null> _loadMore() async {
    _provider.dispatch(FragmentFriendEventLoading(LoadType.loadMore));
  }

  //控制页面重绘
  @override
  bool get wantKeepAlive => true;

  Widget _listViewBuilder(BaseState state) {
    if (state is FragmentFriendStateLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state is FragmentFriendStateLoaded) {
      return ListView.builder(
        itemCount: state.posts.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
//      padding: new EdgeInsets.symmetric(vertical: 16.0),
        itemBuilder: (context, index) {
          return GestureDetector(
//            child: PostInfoItem(
//              key: new ObjectKey(state.posts[index].id),
//              data: state.posts[index],
//            ),
            onTap: () {
              //进入详情页
              PostDetailArgument postDetailArgument =
              new PostDetailArgument(state.posts[index].id, 113.347868, 23.007985);
              print("进入详情页");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      new DetailPagefulWidget(postDetailArgument)));
            },
          );
        },
        controller: _scrollController,
      );
    }
  }
}

//class PostInfoItem extends StatefulWidget {
//  final Post data;
//
//  PostInfoItem({Key key, this.data}) : super(key: key);
//
//  @override
//  State<StatefulWidget> createState() {
//    return PostInfoState();
//  }
//}
//
//class PostInfoState extends State<PostInfoItem> {
//  @override
//  Widget build(BuildContext context) {
//    return PostItemView(
//      key: widget.key,
//      data: widget.data,
//    );
//  }
//}
