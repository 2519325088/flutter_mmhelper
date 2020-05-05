import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/Models/DataListModel.dart';

class CupertinoActionSheetActionWidget extends StatefulWidget {
  @override
  _CupertinoActionSheetActionWidgetState createState() =>
      _CupertinoActionSheetActionWidgetState();
  String languageCode;
  DataList dataList;
  final ValueChanged<DataList> onPressedCall;
  String typeStringData;

  CupertinoActionSheetActionWidget({
    this.languageCode,
    this.dataList,
    this.onPressedCall,
  });
}

class _CupertinoActionSheetActionWidgetState
    extends State<CupertinoActionSheetActionWidget> {
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheetAction(
      child: Text(widget.dataList.getValueByLanguageCode(widget.languageCode)),
      onPressed: () {
        widget.onPressedCall(widget.dataList);
      },
    );
  }
}
