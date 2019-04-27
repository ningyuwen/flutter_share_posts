import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_mini_app/been/detail_comment.dart';
import 'package:my_mini_app/been/map_page_been.dart';
import 'package:my_mini_app/been/post_detail_argument.dart';
import 'package:my_mini_app/been/post_detail_been.dart';
import 'package:my_mini_app/home/consume_page.dart';
import 'package:my_mini_app/map/map_page.dart';
import 'package:my_mini_app/provider/auth_provider.dart';
import 'package:my_mini_app/provider/base_state.dart';
import 'package:my_mini_app/provider/detail_page_provider.dart';
import 'package:my_mini_app/provider/text_field_provider.dart';
import 'package:my_mini_app/util/fast_click.dart';
import 'package:my_mini_app/util/network_tuil.dart';
import 'package:my_mini_app/util/photo_view_util.dart';
import 'package:my_mini_app/util/progress_dialog.dart';
import 'package:my_mini_app/util/snack_bar_util.dart';
import 'package:my_mini_app/util/toast_util.dart';
import 'package:my_mini_app/widget/no_internet_widget.dart';
import 'package:rxdart/rxdart.dart';

class DetailPagefulWidget extends StatefulWidget {
  final PostDetailArgument _postDetailArgument;

  DetailPagefulWidget(this._postDetailArgument);

  @override
  State<StatefulWidget> createState() {
    print("createState()");
    return new _DetailPageState();
  }
}

class _DetailPageState extends State<DetailPagefulWidget> {
  DetailPageProvider _detailPageProvider = DetailPageProvider.newInstance();

  @override
  void initState() {
    print("DetailPageState initState()");
    _detailPageProvider.getDetailData(widget._postDetailArgument);
    super.initState();
  }

  @override
  void dispose() {
    _detailPageProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _DetailPageWidget(widget._postDetailArgument, _detailPageProvider);
  }
}

class _DetailPageWidget extends StatelessWidget {
  bool isAdded = false;

  final DetailPageProvider _detailPageProvider;

  PostDetail _postDetail;

  final PostDetailArgument _postDetailArgument;

  BuildContext context;

  _DetailPageWidget(this._postDetailArgument, this._detailPageProvider);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    if (!isAdded) {
      isAdded = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("详情"),
        centerTitle: true,
      ),
      body: _detailPageProvider.streamBuilder(
        success: (PostDetail data) {
          return Stack(
            children: <Widget>[
              _detailPage(data),
              Positioned(
                bottom: 0.0,
                child: _SendCommentStatefulWidget(
                    _postDetailArgument.postId, _detailPageProvider),
              ),
              Positioned(
                  bottom: 51.0,
                  child: Container(
                    height: 1.0,
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).dividerColor,
                  )),
            ],
          );
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (Object error) {
          return NoInternetWidget(error.toString(), () {
            _detailPageProvider.getDetailData(_postDetailArgument);
          });
        },
      ),
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
        style: TextStyle(
            fontSize: 17.0, color: Theme.of(context).textTheme.body1.color),
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
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
//                placeholder: SizedBox(
//                  height: 220.0,
//                  child: Center(
//                      child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      CircularProgressIndicator(
//                        backgroundColor: Colors.amber,
//                        strokeWidth: 2.0,
//                      ),
//                      SizedBox(
//                        height: 15.0,
//                      ),
//                      Text("图片加载中...")
//                    ],
//                  )),
//                ),
              imageUrl: item._imgUrl,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
//                height: 300.0,
              //屏幕宽度
//                errorWidget: Container(
//                  color: Colors.black45,
//                  height: 200.0,
//                  child: Center(
//                    child: Text(
//                      "无法查看图片，请稍后重试...",
//                      style: TextStyle(color: Colors.white),
//                    ),
//                  ),
//                )
            ),
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
//            child: CircleAvatar(
//                radius: 22.0,
//                backgroundImage: NetworkImage(
//                  _postDetail.headUrl,
//                )),
            child: ClipOval(
              clipBehavior: Clip.hardEdge,
              child: CachedNetworkImage(
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                imageUrl: _postDetail.headUrl,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                          new ConsumePage(_postDetail.userId)));
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
                style: Theme.of(context).textTheme.title,
              ),
              Text(
                _postDetail.releaseTime,
                style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).textTheme.subtitle.color),
              )
            ],
          ),
          //关注
          Expanded(
            child: _isMineSelf()
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
      child: GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset("image/ic_map.png", height: 20.0),
            Flexible(
                child: Container(
                  color: Theme.of(context).highlightColor,
                  child: Text(
                    _postDetail.location,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.0),
                  ),
                ))
          ],
        ),
        onTap: () {
          MapPageBeen been = new MapPageBeen(_postDetail.location, _postDetail.longitude, _postDetail.latitude, _postDetail.store);
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new MapWidget(been)));
        },
      )
    );
  }

  Widget showCommentsItem(CommentsItem item) {
    print("头像url is: ${item._comment.headUrl}");
    return Column(
      children: <Widget>[
        ListTile(
          leading: GestureDetector(
            child: ClipOval(
              clipBehavior: Clip.hardEdge,
              child: CachedNetworkImage(
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                imageUrl: item._comment.headUrl,
              ),
            ),
            onTap: () {
              SnackBarUtil.show(context, "点击头像");
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                item._comment.username,
                style:
                    TextStyle(color: Theme.of(context).textTheme.title.color),
              ),
              Text(
                item._comment.time,
                style: TextStyle(
                    fontSize: 12.0,
                    color: Theme.of(context).textTheme.subtitle.color),
              ),
            ],
          ),
          subtitle: Text(
            item._comment.content,
            style: TextStyle(
                fontSize: 14.0, color: Theme.of(context).textTheme.body1.color),
          ),
          trailing: GestureDetector(
            child: Icon(Icons.more_vert),
            onTap: () {
              print("点击更多");
              _showDeleteDialog(item);
            },
          ),
          onLongPress: () {
            _showDeleteDialog(item);
          },
        ),
        Divider(
          height: 0.0,
        ),
      ],
    );
  }

  Widget showBlankItem() {
    return SizedBox(
      height: 80.0,
    );
  }

  String _dialogText(DetailComment comment) {
    if (AuthProvider().userInfo == null) {
      return "当前未登录，无法操作";
    }
    if (comment.userId == AuthProvider().userInfo.userId) {
      return "删除";
    }
    return "举报";
  }

  void _deleteComment(CommentsItem item) {
    if (_dialogText(item._comment) == "删除") {
      print("AlertDialog() commentId is: ${item._comment.commentId}");
      _detailPageProvider.deleteComment(item._comment);
    }
    Navigator.pop(context);
  }

  void _showDeleteDialog(CommentsItem item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.all(0.0),
              content: ListTile(
                title: Text(
                  _dialogText(item._comment),
                  style: Theme.of(context).textTheme.title,
                ),
                onTap: () {
                  _deleteComment(item);
                },
              ));
        });
  }

  Widget _isMineSelf() {
    if (_postDetail.userId == AuthProvider().userInfo.userId) {
      return SizedBox();
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          RaisedButton(
            child: _UserFriendWidget(
                _detailPageProvider, _postDetail.isFriend),
            onPressed: () {
              //关注
              if (FastClick.isFastClick()) {
                return;
              }
              _detailPageProvider.postUserFriend(_postDetail.isFriend);
            },
            elevation: 1.0,
            highlightColor: const Color.fromARGB(255, 250, 250, 250),
            shape: const RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(4))),
          ),
        ],
      );
    }
  }
}

class _UserFriendWidget extends StatefulWidget {
  final DetailPageProvider _detailPageProvider;
  final bool _isFriend;

  _UserFriendWidget(this._detailPageProvider, this._isFriend);

  @override
  State<StatefulWidget> createState() {
    return _UserFriendState();
  }
}

class _UserFriendState extends State<_UserFriendWidget> {
  @override
  Widget build(BuildContext context) {
    return _userFriendWidget();
  }

  Widget _userFriendWidget() {
    return StreamBuilder(
      initialData: widget._isFriend,
      stream: widget._detailPageProvider.userFriendStream(),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (!snapshot.data) {
            return Row(
              children: <Widget>[
                Icon(
                  Icons.add,
//                  color: const Color.fromARGB(255, 51, 132, 245),
                ),
                Text(
                  "关注",
                  style: TextStyle(
//                      color: const Color.fromARGB(255, 51, 132, 245),
                      fontWeight: FontWeight.bold),
                )
              ],
            );
          } else {
            return Text(
              "已关注",
              style: TextStyle(
                fontWeight: FontWeight.bold,
//                  color: Color.fromARGB(255, 154, 154, 154)
              ),
            );
          }
        } else {
          return Container(
            width: 24.0,
            height: 24.0,
            child: CircularProgressIndicator(
              strokeWidth: 1.0,
            ),
          );
        }
      },
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

class _SendCommentStatefulWidget extends StatefulWidget {
  final int postId;
  final DetailPageProvider detailPageProvider;

  _SendCommentStatefulWidget(this.postId, this.detailPageProvider);

  @override
  State<StatefulWidget> createState() {
    return _SendCommentState();
  }
}

class _SendCommentState extends State<_SendCommentStatefulWidget>
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
      color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.only(left: 12.0, right: 14.0),
      height: 52.0,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width - 60.0,
              child: TextFormField(
                style: Theme.of(context).textTheme.body1,
                controller: _sendMsgTextField,
                maxLines: 1,
                keyboardType: TextInputType.text,
                key: _orderFormKey,
                decoration: const InputDecoration(
                  hintText: '请输入评论',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            BlocBuilder(
                bloc: _bloc,
                builder: (BuildContext context, BaseState state) {
                  return GestureDetector(
                      onTap: () {
                        if (_sendMsgTextField.text != "") {
                          if (!AuthProvider().isLogin()) {
                            AuthProvider()
                                .showLoginDialog("发表评论需要您先登录，是否需要进行登录？");
                          } else {
                            _checkNetworkAndComment();
                          }
                        }
                      },
                      child: Text(
                        "发布",
                        style: TextStyle(
                            fontSize: 16.0, color: _getSendBtnColor(state)),
                      ));
                })
          ],
        ),
      ),
    );
  }

  void _checkNetworkAndComment() {
    Observable.fromFuture(NetworkUtil.hasNetwork()).listen((hasNetwork) {
      if (hasNetwork) {
        //显示dialog
        ProgressDialog.showProgressDialog(context);
        widget.detailPageProvider.postComment(widget.postId,
            _sendMsgTextField.text.toString(), () {
              Navigator.pop(context);
              _sendMsgTextField.text = "";
            });
        FocusScope.of(context)
            .requestFocus(new FocusNode());
        SystemChannels.textInput
            .invokeMethod('TextInput.hide');
      } else {
        ToastUtil.showToast(NetworkUtil.NO_NETWORK);
      }
    });
  }

  Color _getSendBtnColor(BaseState state) {
    if (state is DetailPageTextFieldInput) {
      return Colors.blue;
    } else if (state is DetailPageTextFieldNotInput) {
      return Colors.grey;
    }
    return Colors.grey;
  }
}
