import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:owmflutter/store/store.dart';
import 'package:owmflutter/widgets/widgets.dart';
import 'dart:async';

class EntryLinkList extends StatelessWidget {
  final ConverterCallback converterCallback;
  final LoadDataCallback loadDataCallback;

  EntryLinkList({this.converterCallback, this.loadDataCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
        child: StoreConnector<AppState, EntrylistState>(
            converter: (store) => converterCallback(store),
            onInit: (store) => loadDataCallback(store, true, Completer()),
            builder: (context, state) {
              if (state == null || state.listState.isLoading && state.listState.page == 1) {
                return Center(child: CircularProgressIndicator());
              }
              return StoreConnector<AppState, ListRefreshCallback>(
                  converter: (store) {
                return (bool refresh, Completer completer) =>
                    loadDataCallback(store, refresh, completer);
              }, builder: (context, callback) {
                return RefreshIndicator(
                  onRefresh: () {
                    var completer = Completer();
                    callback(true, completer);
                    return completer.future;
                  },
                  child: InfiniteList(
                      isLoading: state.listState.isLoading,
                      hasReachedEnd: state.listState.haveReachedEnd,
                      loadData: () => callback(false, Completer()),
                      itemCount: state.entriesState.itemIds.length,
                      itemBuilder: (context, index) {
                        if (state.entriesState.itemIds[index] > 99999999) {
                          return EntryWidget(
                              entryId:
                                  state.entriesState.itemIds[index] ~/ 1000,
                              ellipsize: true);
                        } else {
                          return LinkWidget(
                              linkId: state.entriesState.itemIds[index]);
                        }
                      }),
                );
              });
            }));
  }
}