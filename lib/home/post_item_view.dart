import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_mini_app/been/post_around_been.dart';
import 'package:my_mini_app/been/post_detail_argument.dart';
import 'package:my_mini_app/detail/DetailPage.dart';
import 'package:my_mini_app/util/api_util.dart';
import 'package:my_mini_app/util/fast_click.dart';
import 'package:my_mini_app/util/photo_view_util.dart';
import 'package:my_mini_app/util/snack_bar_util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';

class PostItemView extends StatelessWidget {
  Post _post;
  BuildContext context;
  PageController _photosPageController = PageController(); //图片滑动监听
  var currentPageValue = 0.0; //当前页面编号

  PostItemView(Key key, Post post) {
    this._post = post;
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return bodyData();
  }

  Widget bodyData() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                child: ClipOval(
                  child: CachedNetworkImage(
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    imageUrl: _post.head_url,
//                    placeholder: CircularProgressIndicator(),
                  ),
                ),
                onTap: () {
                  SnackBarUtil.show(context, "点击头像");
                },
              ),
              rightColumn(_post),
            ],
          ),
        ),
        Divider(height: 2.0, color: Colors.black26),
      ],
    );
  }

  Widget actionRow(Post post) => Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 50.0),
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
                        SnackBarUtil.show(context, "点击详情");
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

  Widget rightColumn(Post post) => Expanded(
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
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                        text: "${post.releaseTime}",
                        style: TextStyle(color: Colors.grey, fontSize: 12.0))
                  ]),
                ),
              ),
              showContent(), //文字
              //图片
              Container(
                  padding: const EdgeInsets.only(left: 16.0),
                  height: 200.0,
                  child: ClipRRect(
                      borderRadius: new BorderRadius.circular(8.0),
                      child: Stack(
                        children: <Widget>[
                          showPhotos(), //图片
                          showIndicator(), //指示器
                        ],
                      ))),
              //地址
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
                child: Row(
                  children: <Widget>[
                    Image.asset("image/ic_map.png", height: 16.0),
                    Flexible(
                        child: Container(
                      color: Color.fromARGB(255, 239, 240, 241),
                      child: Text(
                        _post.position,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ))
                  ],
                ),
              ),
              //点赞、评论、分享
              actionRow(post),
            ],
          ),
        ),
      );

  Widget showPhotos() {
//    _photosPageController.addListener(() {
//      //  setState(() {
//      //    currentPageValue = _photosPageController.page;
//      //  });
//      print("页面发生了改变 ${_photosPageController.page}");
//    });
//    return PageView.builder(
//      controller: _photosPageController,
//      itemCount: _post.imgUrls.length,
//      itemBuilder: (context, index) {
//        return _rendRow(context, index);
//      },
//      scrollDirection: Axis.horizontal,
//    );
    //只展示一张图片
    return _rendRow(context, 0);
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
          //屏幕宽度
          height: 200.0,
          placeholder: Center(
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
          errorWidget: Container(
            color: Colors.black45,
            child: Center(
              child: Text(
                "无法查看图片，请稍后重试...",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )),
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
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontSize: 15.0,
        ),
        maxLines: 4,
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

//            child: Text(
//              "${currentPageValue.toInt() + 1}/${_post.imgUrls.length}",
//              style: TextStyle(
//                color: Colors.white,
//              ),
//            ),
          ),
        ));
  }
}

class _LikeWidget extends StatefulWidget {
  final Post _post;

  _LikeWidget(this._post);

  @override
  State<StatefulWidget> createState() {
    return new _LikeState();
  }
}

class _LikeState extends State<_LikeWidget> {
  final subject = new PublishSubject<Future<bool>>();

  @override
  void dispose() {
    subject.close();
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
