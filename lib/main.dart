//import 'package:amap_location/amap_location.dart';
import 'package:amap_location/amap_location.dart';
import 'package:bloc/bloc.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_mini_app/home/main_page.dart';
import 'package:my_mini_app/provider/auth_provider.dart';

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

  _startLocationService();
  AuthProvider();

  BlocSupervisor().delegate = SimpleBlocDelegate();

  runApp(_MyAppStateWidget());
}

void _startLocationService() async {
  AMapLocationClient.setApiKey("4c6f8a60ec44f308a05d60c65ce721a2");
  await AMapLocationClient.startup(new AMapLocationOption(
      desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
}

class _MyAppStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => _buildTheme(brightness),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            home: MainPage(),
            checkerboardOffscreenLayers: true,
            theme: theme,
            title: "Flutter Dem a hhh Page",
          );
        });
  }

  ThemeData _buildTheme(Brightness brightness) {
    print("_buildTheme dark: $brightness");
    if (brightness == Brightness.dark) {
      return ThemeData.dark().copyWith(
          //theme
//          textTheme: ThemeData.dark().textTheme.apply(
//                bodyColor: Color.fromARGB(255, 129, 129, 129),
//                displayColor: Color.fromARGB(255, 129, 129, 129),
//                fontFamily: 'Basier',
//              ),
          textTheme: const TextTheme(
            title: const TextStyle(
                fontSize: 18.0, color: Color.fromARGB(255, 153, 153, 153)),
            subtitle: const TextStyle(
                fontSize: 14.0, color: Color.fromARGB(255, 97, 97, 97)),
            body1: const TextStyle(
                fontSize: 16.0, color: Color.fromARGB(255, 127, 127, 127)),
            button: const TextStyle(
                fontSize: 14.0, color: Color.fromARGB(255, 220, 220, 220)),
            body2: const TextStyle(
                fontSize: 16.0, color: Colors.white), //snackBarUtil专用
          ),
          primaryTextTheme: ThemeData.dark().primaryTextTheme.apply(
                bodyColor: Color.fromARGB(255, 26, 26, 26),
                displayColor: Color.fromARGB(255, 26, 26, 26),
                fontFamily: 'Basier',
              ),
          appBarTheme: ThemeData.dark().appBarTheme.copyWith(
              elevation: 1.0,
              color: const Color.fromARGB(255, 26, 26, 26),
              iconTheme: const IconThemeData(
                  color: const Color.fromARGB(255, 153, 153, 153)),
              textTheme: const TextTheme(
                title: const TextStyle(
                    fontSize: 19.0,
                    color: const Color.fromARGB(255, 153, 153, 153)),
              )),
          dialogTheme: ThemeData.light().dialogTheme.copyWith(
              contentTextStyle:
                  const TextStyle(fontSize: 16.0, color: Colors.white)),

          //color
          primaryColor: Color.fromARGB(255, 153, 153, 153),
          primaryColorBrightness: Brightness.dark,
          buttonColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 26, 26, 26),
          //主色调
          scaffoldBackgroundColor: const Color.fromARGB(255, 26, 26, 26));
    } else {
      return ThemeData.light().copyWith(
          //theme
//          textTheme: ThemeData.light().textTheme.apply(
//                bodyColor: Color.fromARGB(255, 26, 26, 26),
//                displayColor: Color.fromARGB(255, 26, 26, 26),
//                fontFamily: 'Basier',
//              ),
          textTheme: const TextTheme(
            title: const TextStyle(
                fontSize: 18.0, color: Color.fromARGB(255, 26, 26, 26)),
            subtitle: const TextStyle(
                fontSize: 14.0, color: Color.fromARGB(255, 156, 156, 156)),
            body1: const TextStyle(
                fontSize: 16.0, color: Color.fromARGB(255, 68, 68, 68)),
            button: const TextStyle(
                fontSize: 14.0, color: Color.fromARGB(255, 26, 26, 26)),
            body2: const TextStyle(
                fontSize: 16.0, color: Colors.black), //snackBarUtil专用
          ),
          primaryTextTheme: ThemeData.light().primaryTextTheme.apply(
                bodyColor: Color.fromARGB(255, 26, 26, 26),
                displayColor: Color.fromARGB(255, 26, 26, 26),
                fontFamily: 'Basier',
              ),
          appBarTheme: ThemeData.light().appBarTheme.copyWith(
              elevation: 1.0,
              color: Colors.white,
              iconTheme: const IconThemeData(
                  color: const Color.fromARGB(255, 129, 129, 129)),
              textTheme: const TextTheme(
                title: const TextStyle(
                    fontSize: 19.0,
                    color: const Color.fromARGB(255, 129, 129, 129)),
              )),
          buttonTheme: ThemeData.light()
              .buttonTheme
              .copyWith(textTheme: ButtonTextTheme.accent),
          dialogTheme: ThemeData.light().dialogTheme.copyWith(
              contentTextStyle:
                  TextStyle(color: Colors.black87, fontSize: 16.0)),

          //color
//          accentColor: Colors.purple,
          primaryColor: const Color.fromARGB(255, 129, 129, 129),
          primaryColorBrightness: Brightness.light,
          backgroundColor: Colors.white,
          //主色调
          scaffoldBackgroundColor: Colors.white);
    }
  }
}
