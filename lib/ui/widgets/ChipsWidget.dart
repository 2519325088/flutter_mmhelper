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
  bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
    if (isSelected) {
      widget.typeStringList.add(widget.dataList.nameId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      padding: EdgeInsets.symmetric(horizontal: 5),
      label: Text(widget.dataList.getValueByLanguageCode(widget.languageCode)),
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          isSelected = selected;
          if (isSelected == true) {
            widget.typeStringList.add(widget.dataList.nameId);
            print(widget.typeStringList);
          } else {
            widget.typeStringList.removeAt(
                widget.typeStringList.indexOf(widget.dataList.nameId));
            print(widget.typeStringList);
          }
        });
      },
      selectedColor: Colors.pink,
      checkmarkColor: Colors.black,
    );
  }
}
