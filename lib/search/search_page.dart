import 'package:flutter/material.dart';
import 'package:my_mini_app/util/const_util.dart';
import 'package:my_mini_app/util/toast_util.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Text("搜索"),
            centerTitle: true,
          ),
          preferredSize: Size.fromHeight(APPBAR_HEIGHT)),
      body: new _SearchPage(),
    );
  }
}

class _SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SearchState();
  }
}

class _SearchState extends State<_SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("ningyuwen"),
    );
  }
}

class SearchBarDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          showSuggestions(context);
          ToastUtil.showToast("showSuggestions");
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () => close(context, null),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: theme.appBarTheme.color,
      primaryIconTheme: theme.appBarTheme.iconTheme,
      primaryColorBrightness: theme.brightness,
      primaryTextTheme: theme.textTheme,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
        itemCount: 30,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              ToastUtil.showToast(index.toString());
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 48.0,
              alignment: Alignment.centerLeft,
              child: Text("ningyuwen"),
            ),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: <Widget>[
          GestureDetector(
            child: new ClipRRect(
              child: Container(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  "search",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
              ),
              borderRadius: new BorderRadius.circular(3.0),
            ),
            onTap: () {
//        debugPrint('onTap key-> ${childNode.getName()}');
              ToastUtil.showToast("点击搜索");
            },
          ),
          GestureDetector(
            child: new ClipRRect(
              child: Container(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  "search",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
              ),
              borderRadius: new BorderRadius.circular(3.0),
            ),
            onTap: () {
//        debugPrint('onTap key-> ${childNode.getName()}');
              ToastUtil.showToast("点击搜索");
            },
          ),
          GestureDetector(
            child: new ClipRRect(
              child: Container(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  "search",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
              ),
              borderRadius: new BorderRadius.circular(3.0),
            ),
            onTap: () {
//        debugPrint('onTap key-> ${childNode.getName()}');
              ToastUtil.showToast("点击搜索");
            },
          ),
          GestureDetector(
            child: new ClipRRect(
              child: Container(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  "search",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
              ),
              borderRadius: new BorderRadius.circular(3.0),
            ),
            onTap: () {
//        debugPrint('onTap key-> ${childNode.getName()}');
              ToastUtil.showToast("点击搜索");
            },
          ),
          GestureDetector(
            child: new ClipRRect(
              child: Container(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  "search",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
              ),
              borderRadius: new BorderRadius.circular(3.0),
            ),
            onTap: () {
//        debugPrint('onTap key-> ${childNode.getName()}');
              ToastUtil.showToast("点击搜索");
            },
          ),
          GestureDetector(
            child: new ClipRRect(
              child: Container(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  "search",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
              ),
              borderRadius: new BorderRadius.circular(3.0),
            ),
            onTap: () {
//        debugPrint('onTap key-> ${childNode.getName()}');
              ToastUtil.showToast("点击搜索");
            },
          ),
          GestureDetector(
            child: new ClipRRect(
              child: Container(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  "search",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
              ),
              borderRadius: new BorderRadius.circular(3.0),
            ),
            onTap: () {
//        debugPrint('onTap key-> ${childNode.getName()}');
              ToastUtil.showToast("点击搜索");
            },
          ),
          GestureDetector(
            child: new ClipRRect(
              child: Container(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  "search",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
              ),
              borderRadius: new BorderRadius.circular(3.0),
            ),
            onTap: () {
//        debugPrint('onTap key-> ${childNode.getName()}');
              ToastUtil.showToast("点击搜索");
            },
          ),
          GestureDetector(
            child: new ClipRRect(
              child: Container(
                padding: EdgeInsets.all(3.0),
                child: Text(
                  "search",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.blue,
              ),
              borderRadius: new BorderRadius.circular(3.0),
            ),
            onTap: () {
//        debugPrint('onTap key-> ${childNode.getName()}');
              ToastUtil.showToast("点击搜索");
            },
          )
        ],
      ),
    );
  }
}
