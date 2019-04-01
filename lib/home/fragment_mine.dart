import 'package:flutter/material.dart';
import 'package:my_mini_app/been/mine_post_been.dart';
import 'package:my_mini_app/provider/fragment_mine_provider.dart';

class FragmentMineWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MineState();
  }
}

class MineState extends State<FragmentMineWidget>
    with AutomaticKeepAliveClientMixin {
  FragmentMineProvider _blocProvider = new FragmentMineProvider();

  @override
  void initState() {
    _blocProvider.fetchMinePostData();
    super.initState();
  }

  @override
  void dispose() {
    _blocProvider.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return _blocProvider.streamBuilder<MinePost>(
        success: (MinePost data) {
          return Center(
            child: Text("${data.username} and size is: ${data.posts.length}"),
          );
        },
        error: (msg) {
          return Container(
            child: Center(
              child: Text(msg),
            ),
          );
        },
        empty: () {
          return Container(
            child: Center(
              child: Text("暂无数据"),
            ),
          );
        },
        loading: () {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
