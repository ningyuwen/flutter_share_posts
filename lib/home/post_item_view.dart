import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:my_mini_app/util/toast_util.dart';
import 'package:my_mini_app/been/post_around_been.dart';
import 'package:my_mini_app/util/photo_view_util.dart';
import 'package:my_mini_app/util/api_util.dart';
import 'package:my_mini_app/util/snack_bar_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share/share.dart';

class PostItemView extends StatefulWidget {
  final Post data;

  PostItemView({Key key, this.data}) : super(key: key);

  @override
  TimelineTwoPageState createState() {
    return TimelineTwoPageState();
  }
}

class TimelineTwoPageState extends State<PostItemView> {
  Post _post;
  PageController _photosPageController = PageController(); //图片滑动监听
  var currentPageValue = 0.0; //当前页面编号

  @override
  void initState() {
    super.initState();
    _post = widget.data;
//    scrollController = ScrollController();
//    scrollController.addListener(() {
//      if (scrollController.position.userScrollDirection ==
//          ScrollDirection.reverse) postBloc.fabSink.add(false);
//      if (scrollController.position.userScrollDirection ==
//          ScrollDirection.forward) postBloc.fabSink.add(true);
//    });
  }

  @override
  void dispose() {
//    postBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                child: CircleAvatar(
                    radius: 22.0,
                    backgroundImage: NetworkImage(
                      _post.head_url,
                    )),
                onTap: () {
                  SnackBarUtil.show(context, "点击头像");
                },
              ),
              rightColumn(_post),
//              Container(
//                height: 350.0,
//                width: MediaQuery.of(context).size.width,
//                child: Center(
//                  child: Text("ningyuwen"),
//                ),
//              )
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
            Row(
              children: <Widget>[
                SizedBox(
                    height: 26.0,
                    width: 34.0,
                    child: new IconButton(
                      padding: const EdgeInsets.all(0.0),
                      icon: Icon(Icons.comment, size: 20.0, color: Colors.grey),
                      onPressed: () {
//                        ToastUtil.showToast("评论");
                      },
                    )),
                Text(_post.comments.toString()),
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(
                    height: 26.0,
                    width: 34.0,
                    child: new IconButton(
                      padding: const EdgeInsets.all(0.0),
                      icon: getVoteIcon(),
                      onPressed: () {
//                        ToastUtil.showToast("喜爱");
                        //添加喜爱
                        clickVoteIcon();
                      },
                    )),
                Text(_post.votes.toString()),
              ],
            ),
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
//                    TextSpan(
//                        text: "@${post.position} · ",
//                        style: TextStyle(color: Colors.grey)),
                    TextSpan(
                        text: "${post.releaseTime}",
                        style: TextStyle(color: Colors.grey, fontSize: 12.0))
                  ]),
                ),
              ),
              showContent(), //文字
//              CachedNetworkImage(
//                  imageUrl: _post.imgUrls[0],
//                  fit: BoxFit.cover,
//                  height: 200.0,
//                  width: MediaQuery.of(context).size.width,
//                  placeholder: Center(
//                    child: CircularProgressIndicator(),
//                  ),
//                  errorWidget: Container(
//                    color: Colors.black45,
//                    child: Center(
//                      child: Text(
//                        "无法查看图片，请稍后重试...",
//                        style: TextStyle(color: Colors.white),
//                      ),
//                    ),
//                  )),
//              Container(
//                height: 200.0,
//                child: Center(
//                  child: Text("ningyuwen"),
//                ),
//              ),
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
                      )
                  )),
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
              actionRow(post),
            ],
          ),
        ),
      );

  void clickVoteIcon() {
    if (_post.isVote) {
      //已点赞，取消赞
      postCancelVoteData();
    } else {
      //未点赞，点赞
      postVoteData();
    }
  }

  void postCancelVoteData() async {
    await ApiUtil.getInstance()
        .netFetch(
            "/vote/cancelVote", RequestMethod.POST, {"postId": _post.id}, null)
        .then((values) {
      print("postCancelVoteData() data is: " + values);
      if ("" == values) {
        //取消点赞成功
        _post.isVote = false;
        _post.votes--;
        setState(() {});

        SnackBarUtil.show(context, "取消点赞成功");
      }
    });
  }

  void postVoteData() async {
    await ApiUtil.getInstance()
        .netFetch("/vote/vote", RequestMethod.POST, {"postId": _post.id}, null)
        .then((values) {
      print("postVoteData() data is: " + values);
      if ("" == values) {
        //点赞成功
//        _post.votes++;
//        _post.isVote = true;
        setState(() {
          _post.votes++;
          _post.isVote = true;
        });

//        SnackBarUtil.show(context, "点赞成功");
      }
    });
  }

  //点赞图标
  Widget getVoteIcon() {
    if (_post.isVote) {
      return Icon(Icons.favorite, size: 20.0, color: Colors.red);
    } else {
      return Icon(Icons.favorite, size: 20.0, color: Colors.grey);
    }
  }

  Widget showPhotos() {
    _photosPageController.addListener(() {
      setState(() {
        currentPageValue = _photosPageController.page;
      });
    });
    return PageView.builder(
      controller: _photosPageController,
      itemCount: _post.imgUrls.length,
      itemBuilder: (context, index) {
        return _rendRow(context, index);
//        return Container(
//          height: 200.0,
//        );
      },
      scrollDirection: Axis.horizontal,
    );
  }

  static const MethodChannel _channel =
      const MethodChannel('com.mrper.framework.plugins/toast');

  Widget _rendRow(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
//        showToast();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    new PhotoViewUtil(widget.key, _post.imgUrls[index])));
      },
//      child: Container(
//        height: 200.0,
//      ),

      child: CachedNetworkImage(
          imageUrl: _post.imgUrls[index],
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width, //屏幕宽度
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
            )
          ),
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
          height: 28.0,
          width: 40.0,
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.circular(10.0),
            color: Colors.black54,
          ),
          child: Center(
            child: Text(
              "${currentPageValue.toInt() + 1}/${_post.imgUrls.length}",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ));
  }

  void showToast() {
    _channel.invokeMethod('showToast', {'message': '你点击了按钮！', 'duration': 6});
  }
}
