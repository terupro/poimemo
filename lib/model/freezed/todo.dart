import 'package:poimemo/model/db/db.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';

@freezed
class TodoData with _$TodoData {
  // DBの状態を保持するクラス
  factory TodoData({
    @Default(false) bool isLoading,
    @Default(false) bool isReadyData,
    @Default([]) List<TodoItemData> todoItems,
  }) = _TodoData;
}

@freezed
class TempTodoItemData with _$TempTodoItemData {
  // 入力中のtodoの状態を保持するクラス
  factory TempTodoItemData({
    @Default('') String title,
  }) = _TempTodoItemData;
}
