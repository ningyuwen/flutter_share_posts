import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mmkv_flutter/mmkv_flutter.dart';
import 'package:my_mini_app/util/api_util.dart';
import 'package:rxdart/rxdart.dart';

class SearchSuggestProvider {
  final String _EMPTY = "_empty_";

  final _fetcher = new PublishSubject<List<String>>();

  final _fectcherHistory = new PublishSubject<List<String>>();

  List<String> _data = new List();

  List<String> _dataHistory = new List();

  stream() => _fetcher.stream;

  streamHistory() => _fectcherHistory.stream;

  void dispose() {
    if (!_fetcher.isClosed) {
      _fetcher.close();
      _saveHistory();
      _fectcherHistory.close();
    }
  }

  static SearchSuggestProvider newInstance() => new SearchSuggestProvider();

  Widget streamBuilder<T>({
    T initialData,
    Function success,
    Function error,
    Function empty,
    Function loading,
    Function finished,
  }) {
    return StreamBuilder(
        stream: stream(),
        initialData: initialData,
        builder: (context, AsyncSnapshot<T> snapshot) {
          if (finished != null) {
            finished();
          }
          if (_data.isNotEmpty) {
            return success(_data);
          }
          if (snapshot.hasData) {
            if (success != null) return success(snapshot.data);
          } else if (snapshot.hasError) {
            final errorStr = snapshot.error;
            if (errorStr == _EMPTY) {
              if (empty != null) return empty();
            } else {
              if (error != null) return error(errorStr);
            }
          } else {
            if (loading != null) return loading();
          }
        });
  }

  void fetchSuggestTag() {
    Observable.fromFuture(_getDataFromLocal()).map((List<String> data) {
      if (data.isEmpty) {
        return false;
      }
      _data.addAll(data);
      return true;
    }).listen((success) {
      print("是否有缓存 is: $success");
      if (success) {
        _fetcher.sink.add(_data);
      } else {
        _getDataFromRemote();
      }
    });
  }

  Future<void> _getDataFromRemote() async {
    dynamic map = await ApiUtil.getInstance()
        .netFetch("/search/getHotTags", RequestMethod.GET, {}, null);
    if (map is List) {
      print("是list");
      for (var data in map) {
        print("${data['label']}");
        _data.add(data['label'].toString().substring(2));
      }
      _fetcher.sink.add(_data);
      saveDataToLocal(map);
    } else {
      print("不是list and data is ${map.toString()}");
      _fetcher.sink.addError(map);
    }
  }

  Future<List<String>> _getDataFromLocal() async {
    List<String> list = new List();
    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
    String data = await mmkv.getString("/search/getHotTags");
    if (data != "") {
      for (var data in jsonDecode(data)) {
        print("缓存: ${data['label']}");
        list.add(data['label'].toString().substring(2));
      }
    }
    return list;
  }

  void saveDataToLocal(List map) async {
    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
    await mmkv.setString("/search/getHotTags", jsonEncode(map));
  }

  Widget streamBuilderHistory<T>({
    T initialData,
    Function success,
    Function error,
    Function empty,
    Function loading,
    Function finished,
  }) {
    return StreamBuilder(
        stream: streamHistory(),
        initialData: initialData,
        builder: (context, AsyncSnapshot<T> snapshot) {
          if (finished != null) {
            finished();
          }
          if (_dataHistory.isNotEmpty) {
            return success(_dataHistory);
          }
          if (snapshot.hasData) {
            if (success != null) return success(snapshot.data);
          } else if (snapshot.hasError) {
            final errorStr = snapshot.error;
            print("error is: $errorStr");
            if (errorStr == _EMPTY) {
              if (empty != null) return empty();
            } else {
              if (error != null) return error(errorStr);
            }
          } else {
            if (loading != null) return loading();
          }
        });
  }

  void fetchHistory() async {
    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
    String history = await mmkv.getString("/search/history");
    print(history);
    if (history.isNotEmpty) {
      for (var str in jsonDecode(history)) {
        _dataHistory.add(str);
      }
    }
    print("_dataHistory.length is: ${_dataHistory.length}");
    await Future.delayed(new Duration(milliseconds: 500), () {
      _fectcherHistory.sink.add(_dataHistory);
    });
  }

  void _saveHistory() async {
    String history = jsonEncode(_dataHistory);
    print(history);
    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
    await mmkv.setString("/search/history", history);
  }

  void deleteHistory() async {
    MmkvFlutter mmkv = await MmkvFlutter.getInstance(); //初始化mmkv
    await mmkv.setString("/search/history", "");
    _dataHistory = new List();
    _fectcherHistory.sink.add(_dataHistory);
  }

  void addQueryToHistory(String query) {
    int index = _dataHistory.indexOf(query);
    if (index != -1) {
      //存在，先删除
      _dataHistory.removeAt(index);
    }
    _dataHistory.insert(0, query);
  }
}
