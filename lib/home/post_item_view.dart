import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_mini_app/been/map_page_been.dart';
import 'package:my_mini_app/been/post_around_been.dart';
import 'package:my_mini_app/been/post_detail_argument.dart';
import 'package:my_mini_app/detail/detail_page.dart';
import 'package:my_mini_app/home/consume_page.dart';
import 'package:my_mini_app/map/map_page.dart';
import 'package:my_mini_app/provider/auth_provider.dart';
import 'package:my_mini_app/util/api_util.dart';
import 'package:my_mini_app/util/fast_click.dart';
import 'package:my_mini_app/util/photo_view_util.dart';
import 'package:my_mini_app/util/snack_bar_util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';

class PostItemWidget extends StatelessWidget {
  Posts _post;
  BuildContext context;
  var currentPageValue = 0.0; //当前页面编号

  PostItemWidget(Key key, Posts post) {
    this._post = post;
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return bodyData();
  }

  Widget bodyData() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            child: ClipOval(
              clipBehavior: Clip.hardEdge,
              child: CachedNetworkImage(
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                imageUrl: _post.head_url,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new ConsumePage(_post.userId)));
            },
          ),
          rightColumn(_post),
        ],
      ),
    );
  }

  Widget actionRow(Posts post) => Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //评论按钮
            Row(
              children: <Widget>[
                SizedBox(
                    height: 26.0,
                    width: 34.0,
                    child: new IconButton(
                      padding: const EdgeInsets.all(0.0),
                      icon: Icon(Icons.comment, size: 20.0, color: Colors.grey),
                      onPressed: () {
                        PostDetailArgument postDetailArgument =
                            new PostDetailArgument(
                                post.id, 113.347868, 23.007985);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new DetailPagefulWidget(
                                    postDetailArgument)));
                      },
                    )),
                Text(_post.comments.toString()),
              ],
            ),
            //点赞按钮
            _LikeWidget(_post),
            //分享按钮
            SizedBox(
                height: 26.0,
                width: 34.0,
                child: new IconButton(
                  padding: const EdgeInsets.all(0.0),
                  icon: Icon(Icons.share, size: 20.0, color: Colors.grey),
                  onPressed: () {
//                    SnackBarUtil.show(context, "分享");
                    Share.share('${_post.content}；\n下面是拍的几张照片：'
                        '${getImgUrlsString()}店铺地址是：${_post.position}\n您也'
                        '可以下载Q晒单查看详细信息哦～');
                  },
                )),
          ],
        ),
      );

  String getImgUrlsString() {
    StringBuffer stringBuffer = new StringBuffer();
    for (String str in _post.imgUrls) {
      stringBuffer.write(str);
      stringBuffer.write("，\n");
    }
    return stringBuffer.toString();
  }

  Widget rightColumn(Posts post) => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: RichText(
                  maxLines: 1,
                  text: TextSpan(children: [
                    TextSpan(
                        text: "${post.username}  ",
                        style: Theme.of(context).textTheme.title),
                    TextSpan(
                        text: "${post.releaseTime}",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context).textTheme.subtitle.color)
//                        style: TextStyle(color: Colors.grey, fontSize: 12.0)
                        )
                  ]),
                ),
              ),
              //文字
              showContent(),
              //图片
              Container(
                height: 200.0,
                padding: const EdgeInsets.only(left: 16.0),
                width: MediaQuery.of(context).size.width,
                child: new Stack(
                  children: <Widget>[
                    Align(
                      child: showPhotos(),
                      alignment: FractionalOffset.topLeft,
                    ),
                    showIndicator()
                  ],
                ),
              ),
              //地址
              Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 10.0, 0.0, 8.0),
                  child: GestureDetector(
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          "image/ic_map.png",
                          height: 20.0,
                          width: 20.0,
                        ),
                        Flexible(
                            child: Container(
                          color: Theme.of(context).highlightColor,
                          child: Text(
                            _post.position == "" ? "" : _post.position,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                        ))
                      ],
                    ),
                    onTap: () {
                      //跳转地图页面
                      MapPageBeen been = new MapPageBeen(_post.position, _post.longitude, _post.latitude, _post.store);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new MapWidget(been)));
                    },
                  )),
              //点赞、评论、分享
              actionRow(post),
            ],
          ),
        ),
      );

  Widget showPhotos() {
    //只展示一张图片
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: new BorderRadius.circular(8.0),
      child: _rendRow(context, 0),
    );
  }

  Widget _rendRow(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    new PhotoViewUtil(key, _post.imgUrls[index])));
      },
      child: CachedNetworkImage(
          imageUrl: _post.imgUrls[index],
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: 200.0),
    );
  }

  Widget showContent() {
    if ("" == _post.content) {
      return Container(
        padding: const EdgeInsets.fromLTRB(16.0, 1.0, 8.0, 8.0),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
      child: Text(
        _post.content,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 15.0,
        ),
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  //图片显示第几张
  Widget showIndicator() {
    if (_post.imgUrls.length == 1) {
      return Container();
    }
    return Align(
        alignment: FractionalOffset.topRight,
        child: Container(
          margin: EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0.0),
          height: 18.0,
          width: 30.0,
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.circular(5.0),
            color: Colors.black54,
          ),
          child: Center(
            child: Text("共${_post.imgUrls.length}张",
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.white,
                )),
          ),
        ));
  }
}

class _LikeWidget extends StatefulWidget {
  final Posts _post;

  _LikeWidget(this._post);

  @override
  State<StatefulWidget> createState() {
    return new _LikeState();
  }
}

class _LikeState extends State<_LikeWidget> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
            height: 26.0,
            width: 34.0,
            child: new IconButton(
              padding: const EdgeInsets.all(0.0),
              icon: getVoteIcon(),
              onPressed: () {
                //添加喜爱
                clickVoteIcon();
              },
            )),
        Text(widget._post.votes.toString()),
      ],
    );
  }

  //点赞图标
  Widget getVoteIcon() {
    if (widget._post.isVote) {
      return Icon(Icons.favorite, size: 20.0, color: Colors.red);
    } else {
      return Icon(Icons.favorite, size: 20.0, color: Colors.grey);
    }
  }

  void clickVoteIcon() {
    if (FastClick.isFastClick()) {
      return;
    }
    if (!AuthProvider().isLogin()) {
      AuthProvider().showLoginDialog("点赞需要您先登录，是否需要进行登录？");
      return;
    }
    if (widget._post.isVote) {
      //已点赞，取消赞
      postCancelVoteData();
      Observable.fromFuture(postCancelVoteData()).listen((data) {
        if (data) {
          //取消点赞成功
          setState(() {
            widget._post.isVote = false;
            widget._post.votes--;
          });
          SnackBarUtil.show(context, "取消点赞成功");
        }
      });
    } else {
      //未点赞，点赞
      Observable.fromFuture(postVoteData()).listen((data) {
        print("data is: $data");
        if (data) {
          //点赞成功
          setState(() {
            widget._post.isVote = true;
            widget._post.votes++;
            SnackBarUtil.show(context, "点赞成功");
          });
        }
      });
    }
  }

  Future<bool> postCancelVoteData() async {
    dynamic map = await ApiUtil.getInstance().netFetch("/vote/cancelVote",
        RequestMethod.POST, {"postId": widget._post.id}, null);
    print("postCancelVoteData() data is: " + map);
    if (map == "") {
      return true;
    }
    return false;
  }

  Future<bool> postVoteData() async {
    dynamic map = await ApiUtil.getInstance().netFetch(
        "/vote/vote", RequestMethod.POST, {"postId": widget._post.id}, null);
    if (map == "") {
      return true;
    }
    return false;
  }
}
