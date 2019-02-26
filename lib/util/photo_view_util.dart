import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewUtil extends StatefulWidget {
  final String imgUrl;

  PhotoViewUtil(Key key, this.imgUrl) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    print("查看图片的链接为：$imgUrl");
    return PhotoViewState();
  }
}

class PhotoViewState extends State<PhotoViewUtil> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
//      onTap: () {
////        Navigator.pop(context);
//      },
//      onVerticalDragEnd: (DragEndDetails details) {
////        Navigator.pop(context);
//      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: PhotoView(
          imageProvider: NetworkImage(widget.imgUrl),
        ),
      ),
    );
  }
}
