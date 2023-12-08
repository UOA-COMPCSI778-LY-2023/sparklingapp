import 'dart:ui';

import 'package:flutter/material.dart';

enum ToastPostion {
  top,
  center,
  bottom,
}

/**
 * 无打扰提示框
 *          //默认是显示在中间的
          Toast.toast(context,msg: "中间显示的 ");
          
          Toast.toast(context,msg: "中间显示的 ",position: ToastPostion.center);
          
          Toast.toast(context,msg: "顶部显示的 Toast $_count",position: ToastPostion.top);
          
          Toast.toast(context,msg: "底部显示的 Toast $_count",position: ToastPostion.bottom);
 */
class Toast {
  static OverlayEntry? _overlayEntry;
  static bool _showing = false;
  static DateTime _startedTime = DateTime.now();
  static String? _msg;
  static int _showTime = 1;
  static Color? _bgColor;
  static Color? _textColor;
  static double? _textSize;
  static ToastPostion? _toastPosition;
  // 左右边距
  static double _pdHorizontal = 0;
  // 上下边距
  static double _pdVertical = 0;
  static void toast(
    BuildContext context, {
    //显示的文本
    String? msg,
    //显示的时间 单位毫秒
    int showTime = 5000,
    //显示的背景
    Color bgColor = Colors.blue,
    //显示的文本颜色
    Color textColor = Colors.white,
    //显示的文字大小
    double textSize = 14.0,
    //显示的位置
    ToastPostion position = ToastPostion.center,
    //文字水平方向的内边距
    double pdHorizontal = 20.0,
    //文字垂直方向的内边距
    double pdVertical = 10.0,
  }) async {
    assert(msg != null);
    _msg = msg;
    _startedTime = DateTime.now();
    _showTime = showTime;
    _bgColor = bgColor;
    _textColor = textColor;
    _textSize = textSize;
    _toastPosition = position;
    _pdHorizontal = pdHorizontal;
    _pdVertical = pdVertical;
    OverlayState? overlayState = Overlay.of(context);
    _showing = true;
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
          builder: (BuildContext context) => Positioned(
                top: buildToastPosition(context),
                child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: AnimatedOpacity(
                        opacity: _showing ? 1.0 : 0.0,
                        duration: _showing
                            ? Duration(milliseconds: 100)
                            : Duration(milliseconds: 400),
                        child: _buildToastWidget(),
                      ),
                    )),
              ));
      overlayState.insert(_overlayEntry!);
    } else {
      _overlayEntry?.markNeedsBuild();
    }
    await Future.delayed(Duration(milliseconds: _showTime));
    if (DateTime.now().difference(_startedTime).inMilliseconds >= _showTime) {
      _showing = false;
      _overlayEntry?.markNeedsBuild();
      await Future.delayed(Duration(milliseconds: 400));
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  static void showBreifInfo(
    BuildContext context, {
    Widget? wt,
    int showTime = 5000,
  }) async {
    assert(wt != null);
    _startedTime = DateTime.now();
    _showTime = showTime;
    _toastPosition = ToastPostion.top;
    _bgColor = Colors.white;
    _textColor = Colors.black;

    _textSize = 14;
    _pdHorizontal = 20.0;
    _pdVertical = 10.0;
    OverlayState? overlayState = Overlay.of(context);
    _showing = true;
    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (BuildContext context) => Positioned(
          left: 10,
          right: 10,
          top: 80,
          child: Material(
            elevation: 15,
            child: GestureDetector(
              onTap: () async {
                _showing = false;
                _overlayEntry?.markNeedsBuild();
                await Future.delayed(Duration(milliseconds: 400));
                _overlayEntry?.remove();
                _overlayEntry = null;
              },
              child: Container(
                alignment: Alignment.center,
                // width: MediaQuery.of(context).size.width - 20,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  child: AnimatedOpacity(
                    opacity: _showing ? 1.0 : 0.0, //目标透明度
                    duration: _showing
                        ? Duration(milliseconds: 100)
                        : Duration(milliseconds: 400),
                    child: wt,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      overlayState.insert(_overlayEntry!);
    } else {
      _overlayEntry?.markNeedsBuild();
    }
    await Future.delayed(Duration(milliseconds: _showTime));
    if (DateTime.now().difference(_startedTime).inMilliseconds >= _showTime) {
      _showing = false;
      _overlayEntry?.markNeedsBuild();
      await Future.delayed(Duration(milliseconds: 400));
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  static _buildToastWidget() {
    return Center(
      child: Card(
        color: _bgColor,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: _pdHorizontal, vertical: _pdVertical),
          child: Text(
            _msg!,
            style: TextStyle(
              fontSize: _textSize,
              color: _textColor,
            ),
          ),
        ),
      ),
    );
  }

  static buildToastPosition(context) {
    var backResult;
    if (_toastPosition == ToastPostion.top) {
      backResult = MediaQuery.of(context).size.height * 1 / 4;
    } else if (_toastPosition == ToastPostion.center) {
      backResult = MediaQuery.of(context).size.height * 2 / 5;
    } else {
      backResult = MediaQuery.of(context).size.height * 3 / 4;
    }
    return backResult;
  }
}

class MsgView {
  static showConfirm(context, String title, String msg, Function okfn,
      [Function? cancelfn]) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(msg),
            elevation: 24,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            actions: <Widget>[
              OutlinedButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop('cancel');
                  if (cancelfn != null) cancelfn();
                },
              ),
              OutlinedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop('ok');
                  okfn();
                },
              ),
            ],
          );
        });
  }

  static showInfoChange(context, String title, Widget ct,
      [Function? okfn, Function? cancelfn]) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title, textAlign: TextAlign.center),
            content: ct,
            elevation: 24,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actionsPadding: EdgeInsets.fromLTRB(30, 0, 30, 10),
            actions: <Widget>[
              OutlinedButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop('cancel');
                  if (cancelfn != null) cancelfn();
                },
              ),
              OutlinedButton(
                child: Text('Confirm'),
                onPressed: () {
                  Navigator.of(context).pop('ok');
                  if (okfn != null) okfn();
                },
              ),
            ],
          );
        });
  }

  static showRightMenu(
      BuildContext context, LongPressStartDetails detail, pop) {
    var menu = pop();
    final RelativeRect position = RelativeRect.fromLTRB(
        detail.globalPosition.dx,
        detail.globalPosition.dy + 20,
        detail.globalPosition.dx,
        detail.globalPosition.dy + 20);
    //var pop = _popMenu();
    showMenu(
      context: context,
      items: menu.itemBuilder(context),
      position: position,
    ).then((newValue) {
      //if (!mounted) return null;
      if (newValue == null) {
        if (menu.onCanceled != null) menu.onCanceled!();
        return null;
      }
      if (menu.onSelected != null) menu.onSelected!(newValue);
    });
  }
}
