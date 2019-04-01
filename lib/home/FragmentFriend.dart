import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_header.dart';
import 'package:my_mini_app/provider/fragment_friend_provider.dart';

class TestFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<TestFragment> {
  FragmentFriendProvider _blocProvider = FragmentFriendProvider.newInstance();

  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();

  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();

  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    _blocProvider.fetchQueryList();
    super.initState();
  }

  @override
  void dispose() {
    _blocProvider.dispose();
    super.dispose();
  }

  void finished() {}

  @override
  Widget build(BuildContext context) {
    return buildBody();
  }

  Widget buildData() {
    return _blocProvider.streamBuilder<List>(success: (data) {
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
          child: buildList(data),
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
    });
  }

  //下拉刷新，推荐点赞、评论最多，或者热门商家里的点评数据
  Future<Null> _refresh() async {
//    _blocProvider.addData();
//    setState(() {});
    return;
  }

  //上拉加载更多，按照时间顺序排序的点评数据
  Future<Null> _loadMore() async {
//    _blocProvider.addData();
//    setState(() {});
    return;
  }

  Widget buildList(List<int> data) {
    return ListView.builder(
      itemCount: data.length,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        int itemModel = data[index];
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 50.0,
          child: Center(
            child: Text("$itemModel"),
          ),
        );
      },
    );
  }

  Widget buildBody() {
    return buildData();
  }
}
