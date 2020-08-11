import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class _SheetModal extends StatelessWidget {
  final Widget child;
  final Widget title;
  final Widget action;
  final bool alignActionLeft;

  const _SheetModal({
    Key key,
    @required this.child,
    @required this.title,
    this.alignActionLeft = false,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          bottom: false,
          child: Material(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                _SheetModalHeader(
                  title: title,
                  alignActionLeft: alignActionLeft,
                  action: action,
                ),
                Expanded(child: child)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetModalHeader extends StatelessWidget {
  final Widget title;
  final Widget action;
  final bool alignActionLeft;

  const _SheetModalHeader({
    Key key,
    this.title,
    this.action,
    this.alignActionLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Stack(
        children: <Widget>[
          Center(
            child: title,
          ),
          Positioned(
            right: alignActionLeft ? null : 0,
            left: alignActionLeft ? 0 : null,
            child: action,
          )
        ],
      ),
    );
  }
}

Future<T> showSheetModal<T>(
  BuildContext context, {
  Widget child,
  Widget title,
  Widget action,
  bool alignActionLeft = false,
}) async {
  final modalFuture = Platform.isIOS
      ? CupertinoScaffold.showCupertinoModalBottomSheet<T>(
          context: context,
          builder: (context, scrollController) {
            return _SheetModal(
              child: child,
              title: title,
              action: action,
              alignActionLeft: alignActionLeft,
            );
          })
      : showMaterialModalBottomSheet<T>(
          context: context,
          builder: (context, scrollController) {
            return _SheetModal(
              child: child,
              title: title,
              action: action,
              alignActionLeft: alignActionLeft,
            );
          });

  return await modalFuture;
}
