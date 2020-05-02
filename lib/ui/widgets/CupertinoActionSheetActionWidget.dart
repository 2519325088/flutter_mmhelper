import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/Models/DataListModel.dart';

class CupertinoActionSheetActionWidget extends StatefulWidget {
  @override
  _CupertinoActionSheetActionWidgetState createState() =>
      _CupertinoActionSheetActionWidgetState();
  String languageCode;
  DataList dataList;
  String typeStringData;
  TextEditingController textEditingController;

  CupertinoActionSheetActionWidget(
      {this.languageCode,
      this.dataList,
      this.textEditingController,
      this.typeStringData});
}

class _CupertinoActionSheetActionWidgetState
    extends State<CupertinoActionSheetActionWidget> {
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheetAction(
      child: Text(widget.dataList.getValueByLanguageCode(widget.languageCode)),
      onPressed: () {
        widget.textEditingController.text =
            widget.dataList.getValueByLanguageCode(widget.languageCode);
        widget.typeStringData = widget.dataList.nameEn;
        print(widget.typeStringData);
        Navigator.pop(context);
      },
    );
  }
}
