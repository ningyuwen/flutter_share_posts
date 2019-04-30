import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_mini_app/been/post_around_been.dart';
import 'package:my_mini_app/been/post_detail_argument.dart';
import 'package:my_mini_app/detail/detail_page.dart';
import 'package:my_mini_app/home/fragment_around_page.dart';
import 'package:my_mini_app/provider/seacrh_query_provider.dart';
import 'package:my_mini_app/provider/seacrh_suggest_provider.dart';
import 'package:my_mini_app/search/search.dart';

class SearchBarDelegate extends SearchDelegateMine<String> {
  SearchSuggestProvider _suggestProvider = SearchSuggestProvider.newInstance();
  SearchQueryProvider _queryProvider = SearchQueryProvider.newInstance();
  _SearchQueryWidget _queryWidget;
  _SearchSuggestWidget _suggestWidget;

  SearchBarDelegate(BuildContext context) {
    _queryWidget = _SearchQueryWidget(_queryProvider, query);
    _suggestWidget = _SearchSuggestWidget(_suggestProvider, (String key) {
      query = key;
      showResults(context);
    });
    _suggestProvider.fetchSuggestTag();
    _suggestProvider.fetchHistory();
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
    return _queryWidget;
  }

  @override
  void showResults(BuildContext context) {
    if (query != "") {
      _queryProvider.fetchQueryTag(query);
      _suggestProvider.addQueryToHistory(query);
      super.showResults(context);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _suggestWidget;
  }

  @override
  void showSuggestions(BuildContext context) {
    if (query == "") {
//      ToastUtil.showToast("showSuggestions");
      super.showSuggestions(context);
    }
  }

  @override
  void close(BuildContext context, String result) {
    _queryProvider.dispose();
    _suggestProvider.dispose();
    super.close(context, result);
  }
}

class _SearchSuggestWidget extends StatefulWidget {
  final callback;
  final SearchSuggestProvider _provider;

  _SearchSuggestWidget(this._provider, this.callback);

  @override
  State<StatefulWidget> createState() {
    return _SearchSuggestState();
  }
}

class _SearchSuggestState extends State<_SearchSuggestWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
              delegate: SliverChildListDelegate([
            _suggestWidget(),
          ])),
          _historyWidget(),
        ],
      ),
    );
  }

  Widget _historyWidget() {
    return widget._provider.streamBuilderHistory<List<String>>(
        success: (List<String> data) {
      print("有数据了");
      return SliverList(delegate: SliverChildListDelegate(_listWidget(data)));
    }, loading: () {
      return SliverList(
          delegate: SliverChildListDelegate([
        Container(
          width: MediaQuery.of(context).size.width,
          height: 100.0,
          child: CupertinoActivityIndicator(),
        )
      ]));
    }, error: (error) {
      return Text(error);
    });
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
          widget.callback(text);
        },
      ));
    }
    return widgets;
  }

  Widget _suggestWidget() {
    return widget._provider.streamBuilder<List<String>>(
        success: (List<String> data) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "为您推荐以下分类:",
            style: Theme.of(context).textTheme.title,
          ),
          Divider(),
          Wrap(spacing: 8.0, runSpacing: 8.0, children: _buildWidget(data)),
          Divider(),
        ],
      );
    }, loading: () {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 100.0,
        child: CupertinoActivityIndicator(),
      );
    }, error: (error) {
      return Text(error);
    });
  }

  List<Widget> _listWidget(List<String> data) {
    List<Widget> widgets = new List();
    if (data.isEmpty) {
      return widgets;
    }
    widgets.add(new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "搜索历史:",
          style: Theme.of(context).textTheme.title,
        ),
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      content: new Text("您确定删除搜索记录吗？"),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Text("取消"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        new FlatButton(
                          child: new Text("确定"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget._provider.deleteHistory();
                          },
                        )
                      ]);
                });
          },
          child: Text(
            "删除记录",
            style: Theme.of(context).textTheme.body1,
          ),
        )
      ],
    ));
    widgets.add(Divider());
    for (String text in data) {
      widgets.add(InkWell(
          onTap: () {
            widget.callback(text);
          },
          child: Container(
            height: 36.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(text),
              ],
            ),
          )));
    }
    return widgets;
  }

  @override
  bool get wantKeepAlive => true;
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

class _SearchQueryState extends State<_SearchQueryWidget>
    with AutomaticKeepAliveClientMixin {
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
                  new PostDetailArgument(data[index].id, 113.347868, 23.007985);
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
    }, loading: () {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }, error: (error) {
      return Center(
        child: Text(error),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
