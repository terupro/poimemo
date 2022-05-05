import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:poimemo/component/cardButton.dart';
import 'package:poimemo/main.dart';
import 'package:poimemo/model/db/db.dart';
import 'package:poimemo/model/freezed/todo.dart';
import 'package:poimemo/util/util.dart';
import 'package:poimemo/view_model/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:poimemo/component/allCard.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // 入力中のtodoのインスタンスを作成
  TempTodoItemData temp = TempTodoItemData();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    final _darkModeNotifier = ref.watch(darkModeProvider.notifier);
    setState(() {
      _darkModeNotifier.state = prefs.getBool('themeSetting')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 状態が変化するたびに再ビルドする
    final _todoDatabaseProvider = ref.watch(todoDatabaseProvider);

    // メソッドや値を取得する
    final _todoDatabaseNotifier = ref.watch(todoDatabaseProvider.notifier);

    // 追加画面を閉じたら再ビルドするために使用する
    List<TodoItemData> _todoItems = _todoDatabaseNotifier.state.todoItems;

    // コントローラ
    final _textController = TextEditingController();

    // Providerの監視
    final _darkModeProvider = ref.watch(darkModeProvider);
    final _darkModeNotifier = ref.watch(darkModeProvider.notifier);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        temp = temp.copyWith(title: '');
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned(
                bottom: 123,
                right: 10,
                left: 10,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: kIconImage(_darkModeProvider),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Copyright @ Teruya Hasegawa\nAll rights reserved',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kCopyrightColor(_darkModeProvider),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 20,
                        right: 17,
                        left: 17,
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
                            offset: const Offset(-4, -4),
                            color: kCardBottomShadow(_darkModeProvider),
                            blurRadius: 6,
                            inset: true,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  'memo',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  if (_darkModeProvider == true) {
                                    _darkModeNotifier.state = false;
                                  } else {
                                    _darkModeNotifier.state = true;
                                  }
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool(
                                      'themeSetting', _darkModeNotifier.state);
                                  setState(() {
                                    prefs.getBool('themeSetting');
                                  });
                                  HapticFeedback.heavyImpact();
                                },
                                icon: Icon(
                                  Icons.brightness_6_outlined,
                                  color: kTextColor(_darkModeProvider),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Flexible(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kCardColor(_darkModeProvider),
                                    borderRadius: kMainBorderRadius,
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(-3, -3),
                                        color:
                                            kCardTopShadow(_darkModeProvider),
                                        blurRadius: 3,
                                        inset: true,
                                      ),
                                      BoxShadow(
                                        offset: const Offset(3, 3),
                                        color: kCardBottomShadow(
                                            _darkModeProvider),
                                        blurRadius: 3,
                                        inset: true,
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    maxLength: null,
                                    keyboardType: TextInputType.multiline,
                                    controller: _textController,
                                    onChanged: (value) {
                                      temp = temp.copyWith(title: value);
                                      print(_textController.text);
                                    },
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kTextColor(_darkModeProvider),
                                    ),
                                    decoration: InputDecoration(
                                      filled: false,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 10,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kTextFieldBorderColor(
                                            _darkModeProvider,
                                          ),
                                          width: 2,
                                        ),
                                        borderRadius: kMainBorderRadius,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kTextFieldBorderColor(
                                            _darkModeProvider,
                                          ),
                                          width: 2,
                                        ),
                                        borderRadius: kMainBorderRadius,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: cardButton(() async {
                                  await _todoDatabaseNotifier.writeData(temp);
                                  HapticFeedback.heavyImpact();
                                  temp = temp.copyWith(title: '');
                                }, Icons.add, kIconAddColor(_darkModeProvider)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7.3),
                      child: ListView(
                        children: allCard(_todoItems, _todoDatabaseNotifier),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
