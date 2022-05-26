import 'package:flutter/material.dart';
import 'package:poimemo/component/card.dart';
import 'package:poimemo/model/db/db.dart';
import 'package:poimemo/model/freezed/todo.dart';
import 'package:poimemo/view_model/provider.dart';

List<Widget> allCard(
  List<TodoItemData> items,
  TodoDatabaseNotifier db,
) {
  List<Widget> list = [];
  for (TodoItemData item in items) {
    Widget _card = card(item, db);
    list.insert(0, _card);
  }
  return list;
}
