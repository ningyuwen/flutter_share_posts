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
      if (url.contains("@600w_480h")) {
        url = url.replaceAll("@600w_480h", "");
        print("变化后的url: $url");
      }
      list.add(new PhotoViewGalleryPageOptions(
        imageProvider: CachedNetworkImageProvider(url),
        heroTag: url,
      ));
    }
    return list;
  }

  List<PhotoViewGalleryPageOptions> _list;

  @override
  void initState() {
    _list = _buildPageOptions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Stack(
        children: <Widget>[
          PhotoViewGallery(
            pageOptions: _list,
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
