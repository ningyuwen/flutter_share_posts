import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_mini_app/been/mine_post_been.dart';
import 'package:my_mini_app/been/post_detail_argument.dart';
import 'package:my_mini_app/detail/DetailPage.dart';
import 'package:my_mini_app/util/photo_view_util.dart';
import 'package:share/share.dart';

class MinePostItemView extends StatelessWidget {
  Posts _post;
  BuildContext context;
  var currentPageValue = 0.0; //当前页面编号

  MinePostItemView(Key key, Posts post) {
    this._post = post;
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return GestureDetector(
      child: bodyData(),
      onTap: () {
        jumpToDetailPage();
      },
    );
  }

  Widget bodyData() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: Column(
        children: <Widget>[
          mainColumn(_post),
          Divider(height: 2.0, color: Colors.black26),
        ],
      ),
    );
  }

  Widget actionRow(Posts post) => Padding(
        padding: const EdgeInsets.only(
            left: 20.0, bottom: 0.0, right: 20.0, top: 0.0),
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
                      icon:
                          Icon(Icons.comment, size: 20.0, color: Colors.white),
                      onPressed: () {
                        jumpToDetailPage();
                      },
                    )),
                Text(_post.comments.toString(),
                    style: TextStyle(color: Colors.white)),
              ],
            ),
            //点赞按钮
            Row(
              children: <Widget>[
                SizedBox(
                  height: 26.0,
                  width: 34.0,
                  child:
                      new Icon(Icons.favorite, size: 20.0, color: Colors.red),
                ),
                Text(_post.votes.toString(),
                    style: TextStyle(color: Colors.white)),
              ],
            ),
            //分享按钮
            SizedBox(
                height: 26.0,
                width: 34.0,
                child: new IconButton(
                  padding: const EdgeInsets.all(0.0),
                  icon: Icon(Icons.share, size: 20.0, color: Colors.white),
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

  Widget showPhotos() {
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
          height: 230.0,
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
            height: 200.0,
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
        padding: const EdgeInsets.fromLTRB(5.0, 8.0, 8.0, 5.0),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 8.0, 8.0, 5.0),
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
          ),
        ));
  }

  Widget mainColumn(Posts post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("${post.store}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  )),
              Text("${post.releaseTime}",
                  style: TextStyle(color: Colors.grey, fontSize: 12.0))
            ],
          ),
        ),
        //文字
        showContent(),
        SizedBox(
          height: 5.0,
        ),
        //图片
        Container(
            color: Colors.white,
            child: ClipRRect(
                borderRadius: new BorderRadius.circular(8.0),
                child: Stack(
//                  alignment: new Alignment(0.0, 1.0),
                  children: <Widget>[
                    showPhotos(), //图片
                    showIndicator(), //指示器
                    //点赞、评论、分享
                    Positioned(
                      bottom: -0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        height: 36.0,
                        color: Colors.black54,
                        child: actionRow(post),
                      ),
                    )
                  ],
                ))),
        //地址
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 6.0),
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
      ],
    );
  }

  void jumpToDetailPage() {
    PostDetailArgument postDetailArgument =
        new PostDetailArgument(_post.id, 113.347868, 23.007985);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new DetailPagefulWidget(postDetailArgument)));
  }
}
