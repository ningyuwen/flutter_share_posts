import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_mini_app/been/post_around_been.dart';
import 'package:my_mini_app/been/post_detail_argument.dart';
import 'package:my_mini_app/detail/detail_page.dart';
import 'package:my_mini_app/home/post_item_view.dart';
import 'package:my_mini_app/mine/my_collection_page.dart';
import 'package:my_mini_app/provider/db_provider.dart';
import 'package:my_mini_app/provider/fragment_around_provider.dart';
import 'package:my_mini_app/provider/return_top_provider.dart';
import 'package:my_mini_app/util/snack_bar_util.dart';
import 'package:my_mini_app/widget/no_internet_widget.dart';

class FragmentAroundPage extends StatefulWidget {
  @override
  FriendState createState() {
    return FriendState();
  }
}

class FriendState extends State<FragmentAroundPage>
    with AutomaticKeepAliveClientMixin {
  FragmentAroundProvider _blocProvider = FragmentAroundProvider.newInstance();

  ScrollController _scrollController = new ScrollController();

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  //控制页面重绘
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    print("FragmentFriendAndAround initState()");
    _blocProvider.loadMore();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _blocProvider.loadMore().then((ReturnData returnData) {
          if (returnData.success) {
            print("size is: ${_blocProvider.lengthOfData()}");
            for (int offset =
                    _blocProvider.lengthOfData() - returnData.dataSize;
                offset < _blocProvider.lengthOfData();
                offset++) {
              _listKey.currentState
                  .insertItem(offset, duration: Duration(milliseconds: 300));
            }
          }
        });
      }
    });
    ReturnTopProvider().stream().listen((int indexPage) {
      if (indexPage == 0) {
        _scrollController.animateTo(0,
            duration: Duration(milliseconds: 1000),
            curve: Curves.fastOutSlowIn);
        SnackBarUtil.show(context, "已返回顶部");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _blocProvider.dispose();
    _scrollController.dispose();
    print("FragmentFriendAndAround close 了了了");
    super.dispose();
  }

  static final Animatable<Offset> _drawerDetailsTween = Tween<Offset>(
    begin: Offset(1.0, 0.0),
    end: Offset.zero,
  ).chain(CurveTween(
    curve: Curves.fastLinearToSlowEaseIn,
  ));

  Future<Null> _handleRefresh() async {
    ReturnData returnData = await _blocProvider.refreshData();
    print("刷新了，但是我不知道success是啥：${returnData.dataSize}");
    if (returnData.success) {
      for (int offset = 0; offset < returnData.dataSize; offset++) {
        _listKey.currentState
            .insertItem(offset, duration: Duration(milliseconds: 300));
      }
      SnackBarUtil.show(context, "为您带来${returnData.dataSize}条点评信息");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _blocProvider.streamBuilder<List>(
        success: (List<Posts> data) {
          print("data length isHHHH: ${data.length}");
          return RefreshIndicator(
              displacement: 20.0,
              child: AnimatedList(
                  key: _listKey,
                  controller: _scrollController,
                  initialItemCount: data.length + 1,
                  itemBuilder:
                      (BuildContext context, int index, Animation animation) {
                    if (index == data.length) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: new Center(
                          child: new Opacity(
                            opacity: 1.0,
                            child: new CupertinoActivityIndicator(),
                          ),
                        ),
                      );
                    }
                    return SlideTransition(
                        position: animation.drive(_drawerDetailsTween),
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              child: PostInfoItem(
                                key: new ObjectKey(data[index].id),
                                data: data[index],
                              ),
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SimpleDialog(
                                        contentPadding: EdgeInsets.all(0.0),
                                        children: <Widget>[
                                          InkWell(
                                            child: Container(
                                                height: 50.0,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "添加收藏",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor),
                                                )),
                                            onTap: () {
                                              Navigator.pop(context);
                                              Posts post = data[index];
                                              Map<String, dynamic> map =
                                                  post.toJson();
                                              //保存
                                              DBProvider.db
                                                  .insertCollection(map)
                                                  .then((int res) {
                                                _showSnackBar(res);
                                              });
                                            },
                                          ),
                                          Divider(
                                            height: 0.0,
                                          ),
                                          InkWell(
                                            child: Container(
                                                height: 50.0,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "不看这条点评",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor),
                                                )),
                                            onTap: () {
                                              Navigator.pop(context);
                                              print(
                                                  "下标是：$index and name is: ${data[index].username}");
                                              Posts post = data[index];
                                              _deleteItem(index, post);
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              onTap: () {
                                _jumpToDetailPage(data[index]);
                              },
                            ),
                            Divider(
                              height: 0.0,
                            )
                          ],
                        ));
                  }),
              onRefresh: _handleRefresh);
        },
        error: (msg) {
          return NoInternetWidget(msg, () {
            _blocProvider.loadMore();
          });
        },
        empty: () {
          return Container(
            child: Center(
              child: Text("暂无数据"),
            ),
          );
        },
        loading: () {
          return Container(
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        },
        finished: () {});
  }

  void _jumpToDetailPage(Posts post) async {
    PostDetailArgument postDetailArgument =
        new PostDetailArgument(post.id, 113.347868, 23.007985);
    print("进入详情页");
    int comments = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new DetailPagefulWidget(postDetailArgument)));
    setState(() {
      post.comments = comments;
    });
  }

  //删除条目的动画
  void _deleteItem(int index, Posts post) {
    _blocProvider.deleteDataAtItem(index);
    _listKey.currentState.removeItem(index,
        (BuildContext context, Animation<double> animation) {
      return SlideTransition(
        position: animation.drive(_drawerDetailsTween),
        child: InkWell(
            child: PostInfoItem(
          key: new ObjectKey(post.id),
          data: post,
        )),
      );
    }, duration: Duration(milliseconds: 500));
    SnackBarUtil.show(context, "已删除此点评",
        action: SnackBarAction(
            label: "撤销",
            onPressed: () {
              _addItem(index, post);
            }),
        milliseconds: 2500);
  }

  //添加条目的动画
  void _addItem(int index, Posts post) {
    _blocProvider.addDataAtItem(index, post);
    _listKey.currentState
        .insertItem(index, duration: Duration(milliseconds: 400));
  }

  void _showSnackBar(int res) {
    if (res == 0) {
      SnackBarUtil.show(context, "已收藏，无需重复收藏",
          action: SnackBarAction(
              label: "查看",
              onPressed: () {
                //跳转我收藏的页面
                _jumpToCollectionPage();
              }),
          milliseconds: 2500);
    } else {
      SnackBarUtil.show(context, "添加收藏成功",
          action: SnackBarAction(
              label: "查看",
              onPressed: () {
                //跳转我收藏的页面
                _jumpToCollectionPage();
              }),
          milliseconds: 2500);
    }
  }

  void _jumpToCollectionPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => new MyCollectionPage()));
  }
}

class PostInfoItem extends StatelessWidget {
  final Posts data;

  PostInfoItem({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PostItemWidget(key, data);
  }
}
