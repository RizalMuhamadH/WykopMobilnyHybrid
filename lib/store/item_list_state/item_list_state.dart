import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';

import 'package:built_value/serializer.dart';
import 'package:owmflutter/models/models.dart';
import 'package:owmflutter/store/store.dart';

part 'item_list_state.g.dart';

abstract class ItemListState
    implements Built<ItemListState, ItemListStateBuilder> {
  PaginationState get paginationState;
  ListState get listState;

  factory ItemListState() {
    return _$ItemListState._(
        paginationState: PaginationState(), listState: new ListState());
  }

  ItemListState._();
  static Serializer<ItemListState> get serializer =>
      _$itemListStateSerializer;
}