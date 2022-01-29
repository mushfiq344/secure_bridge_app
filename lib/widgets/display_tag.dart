import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_tags/flutter_tags.dart';
import 'package:secure_bridges_app/Models/Tag.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';

class TagDisplayPage extends StatelessWidget {
  final List<Tag> _list;
  TagDisplayPage(this._list);

  bool _symmetry = false;
  bool _removeButton = true;
  bool _singleItem = true;

  int _column = 0;
  double _fontSize = 14;

  List _icon = [Icons.home, Icons.language, Icons.headset];

  List _items;

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

  @override
  Widget build(BuildContext context) {
    _items = _list.map<String>((e) => e.title).toList();

    return Container(
        child: Tags(
      key: _tagStateKey,
      symmetry: _symmetry,
      columns: _column,
      horizontalScroll: false,
      //verticalDirection: VerticalDirection.up, textDirection: TextDirection.rtl,
      heightHorizontalScroll: 60 * (_fontSize / 14),
      itemCount: _items.length,
      itemBuilder: (index) {
        final item = _items[index];

        return ItemTags(
          textColor: kPurpleColor,
          key: Key(index.toString()),
          index: index,
          title: item,
          pressEnabled: true,
          activeColor: Colors.blueGrey[600],
          singleItem: _singleItem,
          splashColor: kPurpleColor,
          combine: ItemTagsCombine.withTextBefore,
          textScaleFactor:
              utf8.encode(item.substring(0, 1)).length > 2 ? 0.8 : 1,
          textStyle: TextStyle(
            color: kPurpleColor,
            fontSize: 20,
          ),
          onPressed: (item) {
            print(item);
            // Navigator.push(
            //     context,
            //     new MaterialPageRoute(
            //         builder: (context) => ProfileForm()));
          },
        );
      },
    ));
  }
}
