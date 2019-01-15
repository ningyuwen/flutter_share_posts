import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_mini_app/util/toast_util.dart';
import 'package:my_mini_app/been/post_around_been.dart';
import 'package:my_mini_app/util/photo_view_util.dart';
import 'package:my_mini_app/util/api_util.dart';
import 'package:my_mini_app/util/snack_bar_util.dart';
import 'package:my_mini_app/detail/detail_page.dart';
import 'package:my_mini_app/been/post_detail_argument.dart';


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
//    return Scaffold(
//      backgroundColor: Colors.grey.shade900,
//      body: bodyData(),
//    );
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
                    ToastUtil.showToast("分享");
                  },
                )),
          ],
        ),
      );

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
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                child: Text(
                  post.content,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 15.0,
                  ),
                  maxLines: 4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ClipRRect(
                    borderRadius: new BorderRadius.circular(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new PhotoViewUtil(
                                    widget.key, _post.imgUrl)));
                      },
                      child: Image.network(
                        _post.imgUrl,
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: 200.0,
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
                child: Row(
                  children: <Widget>[
                    Image.asset("image/ic_map.png", height: 16.0),
                    Container(
                      color: Color.fromARGB(255, 239, 240, 241),
                      child: Text(
                        _post.position,
                        style: TextStyle(fontSize: 11.0),
                      ),
                    )
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
        _post.isVote = true;
        _post.votes++;
        setState(() {});

        SnackBarUtil.show(context, "点赞成功");
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
}
