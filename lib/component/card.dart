import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poimemo/component/cardButton.dart';
import 'package:poimemo/model/db/db.dart';
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
                offset: const Offset(3, 3),
                color: kCardTopShadow(_darkModeProvider),
                blurRadius: 4,
                inset: true,
              ),
              BoxShadow(
                offset: const Offset(-3, -3),
                color: kCardBottomShadow(_darkModeProvider),
                blurRadius: 4,
                inset: true,
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 5, right: 17, bottom: 5, left: 17),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: SelectableText(
                      item.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
