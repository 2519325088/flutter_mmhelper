import 'package:flutter/material.dart';
import 'package:flutter_mmhelper/Models/DataListModel.dart';

class ChipsWidget extends StatefulWidget {
  @override
  _ChipsWidgetState createState() => _ChipsWidgetState();
  String languageCode;
  DataList dataList;
  List<String> typeStringList;
  bool isSelected;

  ChipsWidget(
      {this.languageCode, this.dataList, this.typeStringList, this.isSelected});
}

class _ChipsWidgetState extends State<ChipsWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.isSelected &&
        !widget.typeStringList.contains(widget.dataList.nameId)) {
      widget.typeStringList.add(widget.dataList.nameId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      padding: EdgeInsets.symmetric(horizontal: 5),
      label: Text(widget.dataList.getValueByLanguageCode(widget.languageCode)),
      labelStyle:
          TextStyle(color: widget.isSelected ? Colors.white : Colors.black),
      selected: widget.isSelected,
      onSelected: (selected) {
        setState(() {
          widget.isSelected = selected;
          if (widget.isSelected) {
            widget.typeStringList.add(widget.dataList.nameId);
            print(widget.typeStringList);
          } else {
            widget.typeStringList.removeAt(
                widget.typeStringList.indexOf(widget.dataList.nameId));
            print(widget.typeStringList);
          }
        });
      },
      selectedColor: Theme.of(context).primaryColor,
      checkmarkColor: Colors.black,
    );
  }
}
