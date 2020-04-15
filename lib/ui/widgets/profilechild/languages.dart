import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_mmhelper/ui/widgets/profile.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:flutter_mmhelper/utils/data.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:after_init/after_init.dart';

class LanguagePage extends StatefulWidget {

  LanguagePage({Key key, this.title,this.langtag="null"}) : super(key: key);
  final String title;
  final String langtag;
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  ScrollController _scrollViewController;

  final _list = language;
  String languagelist ="";

  bool _symmetry = false;
  bool _removeButton = true;
  bool _singleItem = false;
  bool _startDirection = false;
  bool _horizontalScroll = false;
  bool _withSuggesttions = false;
  int _count = 0;
  int _column = 0;
  double _fontSize = 14;

  String _itemCombine = 'withTextBefore';

  String _onPressed = '';

  List _icon = [Icons.home, Icons.language, Icons.headset];

  @override
  void didInitState() {
    if (widget.langtag !="null"){
      List bb = widget.langtag.split(";");
      for (int instindex=0;instindex<bb.length;instindex++){
        int indexnumber=0;
        for(int intindex=0;intindex<language.length;intindex++){
          if(bb[instindex] != language[intindex]){
            indexnumber+=1;
          }
        }
        if (indexnumber == language.length && bb[instindex] !=""){
          language.add(bb[instindex]);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollViewController = ScrollController();

    _items = _list.toList();
  }

  List _items;

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  final TextEditingController workskillController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.white,
        title: Text(
          'Languages',
          style: TextStyle(
            color: Colors.pinkAccent,
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            color: Colors.white,
            child: Icon(
              Icons.check,
              color: Colors.pinkAccent,
            ),
            onPressed: (){
              for(int dataindex=0;dataindex<datalanguage.length;dataindex++){
                languagelist +=datalanguage[dataindex]+";";
              }
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                return MamaProfile(languageText: languagelist,);
              }));
            },
          )
        ],
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return MamaProfile();
                }));
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    width: 0.5,//宽度
                    color: Colors.black //边框颜色
                ),
              ),
              child: TextFormField(
                controller: workskillController,
                cursorColor: Theme.of(context).accentColor,
                decoration: InputDecoration(
                    border: InputBorder.none
                ),
                onFieldSubmitted: (String value){
                  List aa =value.split(";");
                  for (int i =0;i<aa.length;i++){
                    language.add(aa[i]);
                    datalanguage.add(aa[i]);
                  }
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return LanguagePage();
                  }));
                },
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 0),
                child: CustomScrollView(
                  shrinkWrap: true,
                  physics:const ScrollPhysics(),
                  slivers: <Widget>[
                    SliverList(
                        delegate: SliverChildListDelegate([
                          _tags1,
                          Container(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: <Widget>[
                                  Divider(
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Text(_onPressed),
                                  ),
                                ],
                              )),
                        ])),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _tags1 {
    return Tags(
      key: _tagStateKey,
      symmetry: _symmetry,
      columns: _column,
      horizontalScroll: _horizontalScroll,
      //verticalDirection: VerticalDirection.up, textDirection: TextDirection.rtl,
      heightHorizontalScroll: 60 * (_fontSize / 14),
      itemCount: _items.length,
      itemBuilder: (index) {
        final item = _items[index];

        return ItemTags(
          key: Key(index.toString()),
          index: index,
          title: item,
          pressEnabled: true,
          active: index <3 && ( datalanguage.indexOf(item)==-1)  ? false:true,
          activeColor:Colors.pinkAccent,
          textActiveColor:Colors.white,
          color:Colors.grey[400],
          textColor:Colors.white,
          singleItem: _singleItem,
          combine: ItemTagsCombine.withTextBefore,
          textScaleFactor:
          utf8.encode(item.substring(0, 1)).length > 2 ? 0.8 : 1,
          textStyle: TextStyle(
            fontSize: _fontSize,
          ),
          onPressed: (item){
            if(item.active==true){
              datalanguage.add(item.title);
            }else{
              for (int tagindex=0;tagindex<datalanguage.length;tagindex++){
                if(datalanguage[tagindex]==item.title){
                  datalanguage.remove(item.title);
                }
              }
            }
            print(datalanguage);
          },
        );
      },
    );
  }

  List<DropdownMenuItem> _buildItems() {
    List<DropdownMenuItem> list = [];

    int count = 19;

    list.add(
      DropdownMenuItem(
        child: Text("Not set"),
        value: 0,
      ),
    );

    for (int i = 1; i < count; i++)
      list.add(
        DropdownMenuItem(
          child: Text(i.toString()),
          value: i,
        ),
      );

    return list;
  }

//  List<DropdownMenuItem> _buildItems2() {
//    List<DropdownMenuItem> list = [];
//
//    list.add(DropdownMenuItem(
//      child: Text("onlyText"),
//      value: 'onlyText',
//    ));
//
//    list.add(DropdownMenuItem(
//      child: Text("onlyIcon"),
//      value: 'onlyIcon',
//    ));
//    list.add(DropdownMenuItem(
//      child: Text("onlyImage"),
//      value: 'onlyImage',
//    ));
//    list.add(DropdownMenuItem(
//      child: Text("imageOrIconOrText"),
//      value: 'imageOrIconOrText',
//    ));
//    list.add(DropdownMenuItem(
//      child: Text("withTextBefore"),
//      value: 'withTextBefore',
//    ));
//    list.add(DropdownMenuItem(
//      child: Text("withTextAfter"),
//      value: 'withTextAfter',
//    ));
//
//    return list;
//  }
}