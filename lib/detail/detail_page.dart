import 'package:flutter/material.dart';
import 'package:my_mini_app/util/photo_view_util.dart';
import 'package:my_mini_app/been/post_detail_been.dart';
import 'package:my_mini_app/util/api_util.dart';
import 'package:my_mini_app/util/snack_bar_util.dart';
import 'package:my_mini_app/been/post_detail_argument.dart';
import 'package:my_mini_app/util/snack_bar_util.dart';

class DetailPageStatelessWidget extends StatelessWidget {
  final PostDetailArgument _postDetailArgument;

  DetailPageStatelessWidget(this._postDetailArgument);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("详情"),
          backgroundColor: Color.fromARGB(255, 51, 51, 51),
          centerTitle: true,
        ),
        body: DetailPageStateFulWidget(_postDetailArgument));
  }
}

class DetailPageStateFulWidget extends StatefulWidget {
  final PostDetailArgument _postDetailArgument;

  DetailPageStateFulWidget(this._postDetailArgument);

  @override
  DetailPageState createState() {
    return DetailPageState();
  }
}

class DetailPageState extends State<DetailPageStateFulWidget> {
  PostDetail _postDetail;

  @override
  void initState() {
    super.initState();
    _postDetail = new PostDetail();
    getPostDetailData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        showUserInformation(),
        showContent(),
        showPicture(),
        showComments(),
      ],
    );
  }

  Widget showContent() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Text(
        _postDetail.content,
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  Widget showPicture() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      new PhotoViewUtil(widget.key, _postDetail.contentUrl)));
        },
        child: Image.network(
          _postDetail.contentUrl,
          filterQuality: FilterQuality.high,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
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

  void getPostDetailData() async {
    await ApiUtil.getInstance()
        .netFetch(
            "/post/getPostDetails",
            RequestMethod.GET,
            {
              "id": widget._postDetailArgument.postId,
              "longitude": widget._postDetailArgument.longitude,
              "latitude": widget._postDetailArgument.latitude
            },
            null)
        .then((values) {
      print("getPostDetailData() data is: " + values.toString());
      _postDetail = PostDetail.fromJson(values);
      print("getPostDetailData() url is: ${_postDetail.contentUrl}");
      setState(() {});
    });
  }

  Widget showComments() {
    return Text("aduning");
  }
}
