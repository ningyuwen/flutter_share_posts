import 'dart:core';

import 'package:flutter/material.dart';
import 'package:my_mini_app/been/post_around_been.dart';
import 'package:my_mini_app/been/post_detail_argument.dart';
import 'package:my_mini_app/detail/detail_page.dart';
import 'package:my_mini_app/home/fragment_around_page.dart';
import 'package:my_mini_app/home/post_item_view.dart';
import 'package:my_mini_app/provider/db_provider.dart';
import 'package:my_mini_app/util/const_util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/cupertino.dart';

class MyCollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _MyCollection());
  }

  Widget _appBar() {
    return PreferredSize(
        child: AppBar(
          title: Text("我收藏的"),
          centerTitle: true,
        ),
        preferredSize: Size.fromHeight(APPBAR_HEIGHT));
  }
}

class _MyCollection extends StatefulWidget {
  @override
  _MyCollectionState createState() {
    return _MyCollectionState();
  }
}

class _MyCollectionState extends State<_MyCollection> {

  final PublishSubject<List<Posts>> _publishSubject = new PublishSubject();

  List<Posts> posts = new List();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _publishSubject.stream,
        builder: (context, AsyncSnapshot<List<Posts>> snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(itemBuilder: (context, index) {
              return InkWell(
                child: PostItemWidget(
                  new ObjectKey(snapshot.data[index].id),
                  snapshot.data[index],
                  page: "collectionPage",
                ),
                onTap: () {
                  _jumpToDetailPage(snapshot.data[index]);
                },
              );
            }, separatorBuilder: (context, index) => Divider(
              height: 0.0,
            ), itemCount: snapshot.data.length);
          } else {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
        });
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    if (!_publishSubject.isClosed) {
      _publishSubject.close();
    }
    super.dispose();
  }

  void _getData() async {
    DBProvider.db.getAllCollection().then((List<Posts> posts) {
      this.posts = posts;
      _publishSubject.sink.add(this.posts);
    });
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
    DBProvider.db.updateClient(post.toJson());
  }
}
