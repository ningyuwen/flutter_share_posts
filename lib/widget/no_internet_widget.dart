import 'package:flutter/material.dart';

class NoInternetWidget extends StatelessWidget {
  final String errorMessage;
  final Function tryAgain;

  NoInternetWidget(this.errorMessage, this.tryAgain);

  @override
  Widget build(BuildContext context) {
    print("NoInternetWidget()");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          errorMessage,
          style: Theme.of(context).textTheme.body1,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 30.0,
        ),
        RotateButtonIcon(tryAgain, false),
      ],
    );
  }
}

class RotateButtonIcon extends StatefulWidget {
  final Function tryAgain;
  bool _click = false;

  RotateButtonIcon(this.tryAgain, this._click);

  @override
  State<StatefulWidget> createState() {
    print("_RotateButtonState()");
    return new _RotateButtonState();
  }
}

class _RotateButtonState extends State<RotateButtonIcon>
    with TickerProviderStateMixin {
  bool _click = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._click) {
      return RefreshProgressIndicator();
    }
    return Container(
      child: IconButton(
        iconSize: 30.0,
        onPressed: () {
          //刷新
          widget.tryAgain();
          setState(() {
            widget._click = true;
          });
        },
        icon: Icon(
          Icons.refresh,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
