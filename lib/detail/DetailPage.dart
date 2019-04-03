import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_mini_app/been/detail_comment.dart';
import 'package:my_mini_app/been/post_detail_argument.dart';
import 'package:my_mini_app/been/post_detail_been.dart';
import 'package:my_mini_app/provider/base_state.dart';
import 'package:my_mini_app/provider/detail_page_provider.dart';
import 'package:my_mini_app/provider/text_field_provider.dart';
import 'package:my_mini_app/util/photo_view_util.dart';
import 'package:my_mini_app/util/snack_bar_util.dart';

class DetailPagefulWidget extends StatefulWidget {
  final PostDetailArgument _postDetailArgument;

  DetailPagefulWidget(this._postDetailArgument);

  @override
  State<StatefulWidget> createState() {
    print("createState()");
    return new DetailPageState();
  }
}

class DetailPageState extends State<DetailPagefulWidget> {
  DetailPageProvider _detailPageProvider = DetailPageProvider();

  @override
  void initState() {
    print("DetailPageState initState()");
    _detailPageProvider
        .dispatch(DetailPageEventLoading(widget._postDetailArgument));
    super.initState();
  }

  @override
  void dispose() {
    _detailPageProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetailPageWidget(widget._postDetailArgument, _detailPageProvider);
  }
}

class DetailPageWidget extends StatelessWidget {
  bool isAdded = false;

  final DetailPageProvider _detailPageProvider;

  PostDetail _postDetail;

  final PostDetailArgument _postDetailArgument;

  BuildContext context;

  DetailPageWidget(this._postDetailArgument, this._detailPageProvider);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    if (!isAdded) {
      isAdded = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("详情"),
        backgroundColor: Color.fromARGB(255, 51, 51, 51),
        centerTitle: true,
      ),
      body: BlocBuilder(
          bloc: _detailPageProvider,
          builder: (BuildContext context, BaseState state) {
            print("state is : $state");
            if (state is DetailPageStateLoaded) {
              return _detailPage(state.postDetail);
            }
            if (state is DetailPageStateLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      bottomSheet: BottomSheet(
          onClosing: () {},
          builder: (BuildContext context) {
            return SendCommentStatefulWidget(
                _postDetailArgument.postId, _detailPageProvider);
          }),
    );
  }

  Widget _detailPage(PostDetail postDetail) {
    _postDetail = postDetail;
    //总items个数是头部加图片加评论加空白item
    final items = List<ListItem>.generate(
        _postDetail.mCommentList.length + _postDetail.imgUrls.length + 2, (i) {
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
    final ScrollController scrollController = new ScrollController();
    scrollController.addListener(() {
      FocusScope.of(context).requestFocus(new FocusNode());
//      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
    return ListView.builder(
        controller: scrollController,
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
            print("has 评论");
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
                  builder: (context) => new PhotoViewUtil(key, item._imgUrl)));
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

class SendCommentStatefulWidget extends StatefulWidget {
  final int postId;
  final DetailPageProvider detailPageProvider;

  SendCommentStatefulWidget(this.postId, this.detailPageProvider);

  @override
  State<StatefulWidget> createState() {
    return SendCommentState();
  }
}

class SendCommentState extends State<SendCommentStatefulWidget>
    with AutomaticKeepAliveClientMixin {
  final _sendMsgTextField = TextEditingController(text: "");
  final TextFieldProvider _bloc = TextFieldProvider();

  @override
  void initState() {
    super.initState();
    _sendMsgTextField.addListener(() {
      if (_sendMsgTextField.text.isEmpty) {
        _bloc.dispatch(DetailPageEventTextField(false));
      } else {
        _bloc.dispatch(DetailPageEventTextField(true));
      }
      print(_sendMsgTextField.text);
    });
  }

  static final GlobalKey<FormFieldState<String>> _orderFormKey =
      GlobalKey<FormFieldState<String>>();

  //控制页面重绘
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
              child: TextFormField(
                controller: _sendMsgTextField,
                maxLines: 1,
                keyboardType: TextInputType.text,
                key: _orderFormKey,
                decoration: const InputDecoration(
                  hintText: '发布回复点评',
                ),
              ),
            ),
            BlocBuilder(
                bloc: _bloc,
                builder: (BuildContext context, BaseState state) {
                  return GestureDetector(
                    onTap: () {
                      if (_sendMsgTextField.text != "") {
                        widget.detailPageProvider.dispatch(
                            DetailPageEventPostComment(widget.postId,
                                _sendMsgTextField.text.toString()));
                        FocusScope.of(context).requestFocus(new FocusNode());
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: getSendBtnColor(state),
                      size: 28.0,
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  Color getSendBtnColor(BaseState state) {
    if (state is DetailPageTextFieldInput) {
      return Colors.blue;
    } else if (state is DetailPageTextFieldNotInput) {
      return Colors.grey;
    }
//    if (_sendMsgTextField.text == "") {
//      return Colors.grey;
//    } else {
//      return Colors.blue;
//    }
  }
}
