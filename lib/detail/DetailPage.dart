import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_mini_app/been/detail_comment.dart';
import 'package:my_mini_app/been/post_detail_argument.dart';
import 'package:my_mini_app/been/post_detail_been.dart';
import 'package:my_mini_app/provider/detail_page_provider.dart';
import 'package:my_mini_app/util/photo_view_util.dart';
import 'package:my_mini_app/util/snack_bar_util.dart';

class DetailPageLessWidget extends StatelessWidget {
  final PostDetailArgument _postDetailArgument;
  DetailPageLessWidget(this._postDetailArgument);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: DetailPageProvider(),
      child: DetailPageWidget(_postDetailArgument),
    );
//    MaterialApp(
////      home: HomePage(),
//      home: BlocProvider(
//        bloc: TestBloc(),
//        child: HomePageState(context),
//      ),
//    );
  }

}

class DetailPageWidget extends StatelessWidget {

  bool isAdded = false;

  DetailPageProvider _detailPageProvider;

  PostDetail _postDetail;

  final PostDetailArgument _postDetailArgument;

  BuildContext context;

  DetailPageWidget(this._postDetailArgument);

  @override
  Widget build(BuildContext context) {
    print("build");
    this.context = context;
    if (!isAdded) {
      _detailPageProvider = BlocProvider.of<DetailPageProvider>(this.context);
      _detailPageProvider.dispatch(DetailPageEventLoading(_postDetailArgument));
      isAdded = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("详情"),
        backgroundColor: Color.fromARGB(255, 51, 51, 51),
        centerTitle: true,
      ),
      body: BlocProvider<DetailPageProvider>(
        bloc: _detailPageProvider,
        child: BlocBuilder(
            bloc: _detailPageProvider,
            builder: (BuildContext context, BaseState state) {
              print("state is : $state");
              if (state is DetailPageStateLoaded) {
                return _detailPage(state.postDetail);
//                return Center(
//                  child: Text("加载完成"),
//                );
              }
              if (state is DetailPageStateLoading) {
                return Center(
                  child: Text("加载中"),
                );
              }
            }),
      ),
//      bottomSheet: BottomSheet(
//          onClosing: () {},
//          builder: (BuildContext context) {
////            return SendCommentStatefulWidget(_postDetailArgument.postId);
//          }),
    );
  }

  Widget _detailPage(PostDetail postDetail) {
    _postDetail = postDetail;
    //总items个数是头部加图片加评论加空白item
    final items = List<ListItem>.generate(
        _postDetail.mCommentList.length + _postDetail.imgUrls.length + 2,
            (i) {
          if (i == 0) {
            return HeadViewItem(_postDetail);
          } else if (i > 0 && i <= _postDetail.imgUrls.length) {
            return PhotosViewItem(_postDetail.imgUrls[i - 1]);
          } else if (i > _postDetail.imgUrls.length &&
              i <
                  _postDetail.imgUrls.length +
                      _postDetail.mCommentList.length +
                      1) {
            return CommentsItem(
                _postDetail.mCommentList[i - _postDetail.imgUrls.length - 1]);
          } else {
            return BlankItem();
          }
        });
    return ListView.builder(
        itemCount: items.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = items[index];
          if (item is HeadViewItem) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      showUserInformation(),
                      showContent(),
//                            showPicture(),
                      showPosition(),
                    ],
                  ),
                ),
                Divider(
                  height: 3.0,
                )
              ],
            );
          } else if (item is PhotosViewItem) {
            return showPicture(item);
          } else if (item is CommentsItem) {
            return showCommentsItem(item);
          } else if (item is BlankItem) {
            return showBlankItem();
          }
        });
  }

  Widget showContent() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Text(
        _postDetail.content,
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }

  //显示图片
  Widget showPicture(PhotosViewItem item) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                  new PhotoViewUtil(key, item._imgUrl)));
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
                placeholder: SizedBox(
                  height: 220.0,
                  child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(
                            backgroundColor: Colors.amber,
                            strokeWidth: 2.0,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text("图片加载中...")
                        ],
                      )),
                ),
                imageUrl: item._imgUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
//                height: 300.0,
                //屏幕宽度
                errorWidget: Container(
                  color: Colors.black45,
                  height: 200.0,
                  child: Center(
                    child: Text(
                      "无法查看图片，请稍后重试...",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )),
          ),
        ));
  }

  Widget showUserInformation() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            child: CircleAvatar(
                radius: 22.0,
                backgroundImage: NetworkImage(
                  _postDetail.headUrl,
                )),
            onTap: () {
              SnackBarUtil.show(context, "点击头像");
            },
          ),
          SizedBox(
            width: 10.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _postDetail.username,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Text(
                _postDetail.releaseTime,
                style: TextStyle(fontSize: 14.0),
              )
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_down),
                  onPressed: () {
                    SnackBarUtil.show(context, "点击箭头");
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget showComments(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, top: 10.0),
      child: Text(
        "评论",
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget showPosition() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.asset("image/ic_map.png", height: 24.0),
          Flexible(
              child: Container(
                color: Color.fromARGB(255, 239, 240, 241),
                child: Text(
                  _postDetail.location,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.0),
                ),
              ))
        ],
      ),
    );
  }

  Widget showCommentsItem(CommentsItem item) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: GestureDetector(
            child: CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(
                  item._comment.headUrl,
                )),
            onTap: () {
              SnackBarUtil.show(context, "点击头像");
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(item._comment.username),
              Text(
                item._comment.time,
                style: TextStyle(fontSize: 12.0),
              ),
            ],
          ),
          subtitle: Text(item._comment.content),
          trailing: GestureDetector(
            child: Icon(Icons.more_vert),
            onTap: () {
              SnackBarUtil.show(context, "点击更多");
            },
          ),
          onTap: () {
            SnackBarUtil.show(context, "点击评论条目");
          },
        ),
        Divider(
          height: 3.0,
        )
      ],
    );
  }

  Widget showBlankItem() {
    return SizedBox(
      height: 80.0,
    );
  }
}

abstract class ListItem {}

class HeadViewItem extends ListItem {
  final PostDetail _postDetail;

  HeadViewItem(this._postDetail);
}

class PhotosViewItem extends ListItem {
  final String _imgUrl; //多张图片中的其中一张

  PhotosViewItem(this._imgUrl);
}

class CommentsItem extends ListItem {
  final DetailComment _comment;

  CommentsItem(this._comment);
}

class BlankItem extends ListItem {
  BlankItem();
}