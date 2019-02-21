import 'package:flutter/material.dart';
import 'package:my_mini_app/util/photo_view_util.dart';
import 'package:my_mini_app/been/post_detail_been.dart';
import 'package:my_mini_app/util/api_util.dart';
import 'package:my_mini_app/util/snack_bar_util.dart';
import 'package:my_mini_app/been/post_detail_argument.dart';
import 'package:my_mini_app/util/snack_bar_util.dart';
import 'package:my_mini_app/been/detail_comment.dart';

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
      body: DetailPageStateFulWidget(_postDetailArgument),
      bottomSheet: BottomSheet(
          onClosing: () {},
          builder: (BuildContext context) {
            return SendCommentStatefulWidget();
          }),
//      bottomNavigationBar: BottomNavigationBar(
//          items: [BottomNavigationBarItem(icon: Icon(Icons.more_vert))]),
    );
  }
}

class SendCommentStatefulWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SendCommentState();
  }
}

class SendCommentState extends State<SendCommentStatefulWidget> {
  final _sendMsgTextField = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    _sendMsgTextField.addListener(() {
      if (_sendMsgTextField.text != "") {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      color: Colors.black12,
      height: 60.0,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width - 56.0,
              child: TextField(
                controller: _sendMsgTextField,
                maxLines: 1,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: '发布回复点评',
                ),
              ),
            ),
            GestureDetector(
              child: Icon(
                Icons.send,
                color: getSendBtnColor(),
                size: 28.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  Color getSendBtnColor() {
    if (_sendMsgTextField.text == "") {
      return Colors.grey;
    } else {
      return Colors.blue;
    }
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

abstract class ListItem {}

class HeadViewItem extends ListItem {
  final PostDetail _postDetail;

  HeadViewItem(this._postDetail);
}

class CommentsItem extends ListItem {
  final DetailComment _comment;

  CommentsItem(this._comment);
}

class BlankItem extends ListItem {

  BlankItem();
}

class DetailPageState extends State<DetailPageStateFulWidget> {
  PostDetail _postDetail;
  Future<PostDetail> data;

  @override
  void initState() {
    super.initState();
    _postDetail = new PostDetail();
    data = getPostDetailData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PostDetail>(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _postDetail = snapshot.data;
          final items =
              List<ListItem>.generate(_postDetail.mCommentList.length + 2, (i) {
            if (i == 0) {
              return HeadViewItem(_postDetail);
            } else if (i > 0 && i < _postDetail.mCommentList.length + 1){
              return CommentsItem(_postDetail.mCommentList[i - 1]);
            } else {
              return BlankItem();
            }
          });
          return ListView.builder(
              itemCount: items.length,
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
                            showPicture(),
                            showPosition(),
                          ],
                        ),
                      ),
                      Divider(
                        height: 3.0,
                      )
                    ],
                  );
                } else if (item is CommentsItem) {
                  return showCommentsItem(item);
                } else if (item is BlankItem) {
                  return showBlankItem();
                }
              });
        } else if (snapshot.hasError) {
          return Center();
        }
        // By default, show a loading spinner
        return Center(
          child: CircularProgressIndicator(),
        );
      },
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
//          filterQuality: FilterQuality.high,
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

  Future<PostDetail> getPostDetailData() async {
    PostDetail postDetail;
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
      postDetail = PostDetail.fromJson(values);
    });
    return postDetail;
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
          GestureDetector(
            child: Container(
              color: Color.fromARGB(255, 239, 240, 241),
              child: Text(
                _postDetail.location,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            onTap: () {
              SnackBarUtil.show(context, "点击location");
            },
          )
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
      height: 30.0,
    );
  }
}

class ListViewCommentItem extends StatefulWidget {
  final DetailComment data;

  ListViewCommentItem({Key key, this.data}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ListViewCommentItemState();
  }
}

class ListViewCommentItemState extends State<ListViewCommentItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      child: Text(widget.data.content),
    );
  }
}
