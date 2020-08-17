import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class _SheetModal extends StatelessWidget {
  final Widget child;
  final Widget header;

  const _SheetModal({
    Key key,
    @required this.child,
    @required this.header,
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
              children: <Widget>[header, Expanded(child: child)],
            ),
          ),
        ),
      ),
    );
  }
}

class SheetModalHeader extends StatelessWidget {
  final Widget title;
  final Widget action;
  final bool alignActionLeft;

  const SheetModalHeader({
    Key key,
    this.title,
    this.action,
    this.alignActionLeft = false,
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
          if (action != null)
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
  Widget header,
  bool enableDrag = true,
}) async {
  final modalFuture = Platform.isIOS
      ? CupertinoScaffold.showCupertinoModalBottomSheet<T>(
          context: context,
          enableDrag: enableDrag,
          builder: (context, scrollController) {
            return _SheetModal(
              child: child,
              header: header,
            );
          })
      : showMaterialModalBottomSheet<T>(
          context: context,
          enableDrag: enableDrag,
          builder: (context, scrollController) {
            return _SheetModal(
              child: child,
              header: header,
            );
          });

  return await modalFuture;
}
