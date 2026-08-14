import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'app_lifecycle_store.g.dart';

@singleton
class AppLifecycleStore = _AppLifecycleStore with _$AppLifecycleStore;

abstract class _AppLifecycleStore with Store {
  @readonly
  AppLifecycleState _state = AppLifecycleState.resumed;

  @computed
  bool get isForeground => _state == AppLifecycleState.resumed;

  @action
  void onStateChanged(AppLifecycleState state) {
    _state = state;
  }
}
