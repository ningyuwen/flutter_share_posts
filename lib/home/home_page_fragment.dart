import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/phoenix_header.dart';
import 'package:my_mini_app/been/post_around_been.dart';
import 'package:my_mini_app/been/post_detail_argument.dart';
import 'package:my_mini_app/detail/detail_page.dart';
import 'package:my_mini_app/home/post_item_view.dart';
import 'package:my_mini_app/provider/fragment_friend_provider.dart';

class FragmentFriendAndAround extends StatefulWidget {
  @override
  FriendState createState() {
    return FriendState();
  }
}

class FriendState extends State<FragmentFriendAndAround>
    with AutomaticKeepAliveClientMixin {
  FragmentFriendProvider _blocProvider = FragmentFriendProvider.newInstance();

  ScrollController _scrollController = new ScrollController();

  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();

  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();

  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    print("FragmentFriendAndAround initState()");
    _blocProvider.fetchQueryList();
    super.initState();
  }

  @override
  void dispose() {
    _blocProvider.dispose();
    _scrollController.dispose();
    print("FragmentFriendAndAround close 了了了");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _blocProvider.streamBuilder<List>(success: (List<Posts> data) {
//      print("刷新完成得到数据 data size is: ${data.length}");
      return EasyRefresh(
          refreshHeader: PhoenixHeader(
            key: _headerKey,
          ),
          firstRefresh: false,
          refreshFooter: MaterialFooter(
            key: _footerKey,
          ),
          key: _easyRefreshKey,
          child: ListView.builder(
            itemCount: data.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
//              return IgnorePointer(
//                ignoring: true,
//                child: PostInfoItem(
//                  key: new ObjectKey(data[index].id),
//                  data: data[index],
//                ),
//              );

              return GestureDetector(
                child: PostInfoItem(
                  key: new ObjectKey(data[index].id),
                  data: data[index],
                ),
                onTap: () {
                  //进入详情页
                  PostDetailArgument postDetailArgument =
                      new PostDetailArgument(
                          data[index].id, 113.347868, 23.007985);
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
          ),
          autoLoad: true,
          onRefresh: () async {
            _refresh();
          },
          loadMore: () async {
            _loadMore();
          });
    }, error: (msg) {
      return Container(
        child: Center(
          child: Text(msg),
        ),
      );
    }, empty: () {
      return Container(
        child: Center(
          child: Text("暂无数据"),
        ),
      );
    }, loading: () {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }, finished: () {
//      print("刷新完成 ${_headerKey.currentState}");
      if (_headerKey.currentState != null) {
        _headerKey.currentState.onRefreshClose();
      }
    });
  }

  //下拉刷新，推荐点赞、评论最多，或者热门商家里的点评数据
  Future<Null> _refresh() async {
    _blocProvider.refreshData();
  }

  //上拉加载更多，按照时间顺序排序的点评数据
  Future<Null> _loadMore() async {
    _blocProvider.loadMore();
  }

  //控制页面重绘
  @override
  bool get wantKeepAlive => true;
}

class PostInfoItem extends StatelessWidget {
  final Posts data;

  PostInfoItem({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PostItemView(key, data);
  }
}
