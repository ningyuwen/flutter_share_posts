import 'package:flutter/material.dart';
import 'package:my_mini_app/been/post_around_been.dart';
import 'package:my_mini_app/been/post_detail_argument.dart';
import 'package:my_mini_app/detail/detail_page.dart';
import 'package:my_mini_app/home/fragment_around_page.dart';
import 'package:my_mini_app/provider/seacrh_query_provider.dart';
import 'package:my_mini_app/provider/seacrh_suggest_provider.dart';
import 'package:my_mini_app/util/const_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_mini_app/util/toast_util.dart';
import 'package:my_mini_app/widget/no_internet_widget.dart';

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

  SearchSuggestProvider _suggestProvider = SearchSuggestProvider.newInstance();
  SearchQueryProvider _queryProvider = SearchQueryProvider.newInstance();

  SearchBarDelegate() {
    print("ss");
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          showSuggestions(context);
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
    return _SearchQueryWidget(_queryProvider, query);
  }

  @override
  void showResults(BuildContext context) {
//    ToastUtil.showToast("点击搜索 $query");
    if (query != "") {
//      ToastUtil.showToast("showResults");
      _queryProvider.fetchQueryTag(query);
      super.showResults(context);
    }
//    super.showResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _SearchSuggestWidget((String key) {
      query = key;
      showResults(context);
    });
  }

  @override
  void showSuggestions(BuildContext context) {
    if (query == "") {
//      ToastUtil.showToast("showSuggestions");
      super.showSuggestions(context);
    }
  }
}

class _SearchSuggestWidget extends StatefulWidget {

  final callback;

  _SearchSuggestWidget(this.callback);

  @override
  State<StatefulWidget> createState() {
    return _SearchSuggestState();
  }
}

class _SearchSuggestState extends State<_SearchSuggestWidget> {

  SearchSuggestProvider _provider = SearchSuggestProvider.newInstance();

  @override
  void initState() {
    //请求数据
    _provider.fetchSuggestTag();
    super.initState();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _provider.streamBuilder<List<String>>(
      success: (List<String> data) {
        return Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("为您推荐以下分类:", style: Theme.of(context).textTheme.title,),
              Divider(),
              Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _buildWidget(data)
              ),
              Divider(),
            ],
          )
        );
      },
      loading: () {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 100.0,
          child: CupertinoActivityIndicator(),
        );
      },
      error: (error) {
        return Text(error);
      }
    );
  }

  List<Widget> _buildWidget(List<String> data) {
    List<Widget> widgets = new List();
    for (String text in data) {
      widgets.add(GestureDetector(
        child: new ClipRRect(
          child: Container(
            padding: EdgeInsets.all(3.0),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            color: Colors.blue,
          ),
          borderRadius: new BorderRadius.circular(3.0),
        ),
        onTap: () {
//          ToastUtil.showToast(text);
          widget.callback(text);
        },
      ));
    }
    return widgets;
  }

}

class _SearchQueryWidget extends StatefulWidget {

  final keyword;
  final SearchQueryProvider _queryProvider;

  _SearchQueryWidget(this._queryProvider, this.keyword);

  @override
  State<StatefulWidget> createState() {
    print("createState");
    return _SearchQueryState();
  }
}

class _SearchQueryState extends State<_SearchQueryWidget> {

//  SearchQueryProvider _provider = SearchQueryProvider.newInstance();

  @override
  void initState() {
    widget._queryProvider.fetchQueryTag(widget.keyword);
//    widget._queryProvider.sinkAdd();
    super.initState();
  }

  @override
  void dispose() {
//    widget._queryProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget._queryProvider.streamBuilder<List<Posts>>(
      success: (List<Posts> data) {
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(
            height: 0.0,
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: PostInfoItem(
                key: new ObjectKey(data[index].id),
                data: data[index],
              ),
              onTap: () {
                //进入详情页
                PostDetailArgument postDetailArgument =
                new PostDetailArgument(
                    data[index].id, 113.347868, 23.007985);
                print("进入详情页");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        new DetailPagefulWidget(postDetailArgument)));
              },
            );
          },
        );
      },
      loading: () {
        return Center(
          child: CupertinoActivityIndicator(),
        );
      },
      error: (error) {
        return Center(
          child: Text(error),
        );
      }
    );
  }
}


