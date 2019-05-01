import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/phoenix_header.dart';
import 'package:my_mini_app/been/post_around_been.dart';
import 'package:my_mini_app/been/post_detail_argument.dart';
import 'package:my_mini_app/detail/detail_page.dart';
import 'package:my_mini_app/home/post_item_view.dart';
import 'package:my_mini_app/provider/fragment_friend_provider.dart';
import 'package:my_mini_app/widget/no_internet_widget.dart';

class FragmentFriendPage extends StatefulWidget {
  @override
  FriendState createState() {
    return FriendState();
  }
}

class FriendState extends State<FragmentFriendPage>
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
    _blocProvider.fetchQueryList(1);
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
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              height: 0.0,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: PostInfoItem(
                  key: new ObjectKey(data[index].id),
                  data: data[index],
                ),
                onTap: () {
                  //进入详情页
                  _jumpToDetailPage(data[index]);
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
      return NoInternetWidget(msg, () {
        _blocProvider.fetchQueryList(1);
      });
    }, empty: () {
      return Container(
        child: Center(
          child: Text("暂无数据"),
        ),
      );
    }, loading: () {
      return Container(
        child: Center(
          child: const CupertinoActivityIndicator(),
        ),
      );
    }, finished: () {
      if (_headerKey.currentState != null) {
        _headerKey.currentState.onRefreshClose();
      }
    });
  }

  void _jumpToDetailPage(Posts post) async {
    PostDetailArgument postDetailArgument =
    new PostDetailArgument(
        post.id, 113.347868, 23.007985);
    print("进入详情页");
    int comments = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
            new DetailPagefulWidget(postDetailArgument)));
    setState(() {
      post.comments = comments;
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
    return PostItemWidget(key, data);
  }
}