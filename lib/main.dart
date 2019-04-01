import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_mini_app/home/main_page.dart';
import 'package:flutter/rendering.dart';


class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition);
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print(error);
  }
}

//void main() => runApp(MyApp());
void main() {
//  debugPaintSizeEnabled = true;
//  debugDumpRenderTree();
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(MaterialApp(
    home: TestLogin(),
    title: "Flutter Dem a hhh Page",
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(key: ValueKey("dajs"), title: 'Flutter Dem a hhh Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  final String name = "ningyuwenHHH";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;


  @override
  void initState() {
    super.initState();
    judgeHasLogin();
  }

  @override
  void dispose() {
    //注意这里关闭
    super.dispose();
  }

  void judgeHasLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isLogin = preferences.getBool("isLogin");
    //测试代码
    if (isLogin) {
      //跳转home page
      Navigator.pop(context);
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new MainPage()),
      );
    } else {

    }
  }

  void _incrementCounter() {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new TestLogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.name),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add_a_photo),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
