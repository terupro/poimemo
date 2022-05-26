import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poimemo/component/cardButton.dart';
import 'package:poimemo/model/db/db.dart';
import 'package:poimemo/model/freezed/todo.dart';
import 'package:poimemo/util/util.dart';
import 'package:poimemo/view_model/provider.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

Widget card(TodoItemData item, TodoDatabaseNotifier db) {
  return Consumer(
    builder: ((context, ref, child) {
      final _darkModeProvider = ref.watch(darkModeProvider);
      final _darkModeNotifier = ref.watch(darkModeProvider.notifier);
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: kMainBorderRadius,
        ),
        child: Container(
          padding: const EdgeInsets.only(
            top: 7,
            bottom: 7,
            left: 2.8,
            right: 1.5,
          ),
          decoration: BoxDecoration(
            color: kCardColor(_darkModeProvider),
            borderRadius: kMainBorderRadius,
            boxShadow: [
              BoxShadow(
                offset: const Offset(4, 4),
                color: kCardTopShadow(_darkModeProvider),
                blurRadius: 6,
                inset: true,
              ),
              BoxShadow(
                offset: const Offset(-3, -3),
                color: kCardBottomShadow(_darkModeProvider),
                blurRadius: 6,
                inset: true,
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 1, right: 17, bottom: 1, left: 17),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: CopyableText(
                      item.title,
                      style: TextStyle(
                        fontSize: 16,
                        color: kTextColor(_darkModeProvider),
                      ),
                    ),
                  ),
                ),
                cardButton(
                  () async {
                    await db.deleteData(item);
                    HapticFeedback.heavyImpact();
                  },
                  Icons.close,
                  kIconDeleteColor(_darkModeProvider),
                ),
              ],
            ),
          ),
        ),
      );
    }),
  );
}

class CopyableText extends Text {
  const CopyableText(String data, {Key? key, TextStyle? style, VoidCallback})
      : super(data, key: key, style: style);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () async {
        await Clipboard.setData(ClipboardData(text: data));
        HapticFeedback.heavyImpact();
        Fluttertoast.showToast(
          msg: "メモをコピーしました！",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      },
      child: super.build(context),
    );
  }
}
