import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_mini_app/util/toast_util.dart';
import 'package:my_mini_app/been/post_around_been.dart';
import 'package:photo_view/photo_view.dart';
import 'package:my_mini_app/util/photo_view_util.dart';

class TimelineTwoPage extends StatefulWidget {
  final Post data;

  TimelineTwoPage({Key key, this.data}) : super(key: key);

  @override
  TimelineTwoPageState createState() {
    return TimelineTwoPageState();
  }
}

class TimelineTwoPageState extends State<TimelineTwoPage> {
//  ScrollController scrollController;
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
    return Container(
      child: bodyData(),
    );
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
              CircleAvatar(
                  radius: 22.0,
                  backgroundImage: NetworkImage(
                    _post.head_url,
                  )),
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
                        ToastUtil.showToast("评论");
                      },
                    )
                ),
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
                      icon: Icon(Icons.favorite, size: 20.0, color: Colors.grey),
                      onPressed: () {
                        ToastUtil.showToast("喜爱");
                        //添加喜爱
                        
                      },
                    )
                ),
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
                )
            ),
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
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                          new PhotoViewUtil(widget.key, _post.imgUrl))
                      );
                    },
                    child: Image.network(
                      _post.imgUrl,
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: 200.0,
                    ),
                  )
                ),
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
}
