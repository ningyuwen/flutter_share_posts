import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoGalleryUtil extends StatefulWidget {
  final List<String> imgUrls;
  final PageController pageController = new PageController();

  PhotoGalleryUtil(this.imgUrls);

  @override
  State<StatefulWidget> createState() {
    print("查看图片的链接为：$imgUrls");
    return PhotoViewState();
  }
}

class PhotoViewState extends State<PhotoGalleryUtil> {

  int _currentIndex = 1;

  List<PhotoViewGalleryPageOptions> _buildPageOptions() {
    List<PhotoViewGalleryPageOptions> list = new List();
    for (var url in widget.imgUrls) {
      list.add(new PhotoViewGalleryPageOptions(
        imageProvider: CachedNetworkImageProvider(url),
        heroTag: url,
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      onVerticalDragEnd: (DragEndDetails details) {
        Navigator.pop(context);
      },
      child: Stack(
        children: <Widget>[
          PhotoViewGallery(
            pageOptions: _buildPageOptions(),
            pageController: widget.pageController,
            loadingChild: const CupertinoActivityIndicator(),
            onPageChanged: onPageChanged,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text("$_currentIndex/${widget.imgUrls.length}",
                style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                    decoration: TextDecoration.none)),
          )
        ],
      ),
    );
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index + 1;
    });
  }
}
