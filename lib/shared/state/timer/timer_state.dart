import 'dart:async';

import 'package:mobx/mobx.dart';

part 'timer_state.g.dart';

class TimerState = _TimerState with _$TimerState;

abstract class _TimerState with Store {
  Timer? _timer;

  @observable
  int secondsLeft = 0;

  @computed
  bool get isRunning => secondsLeft > 0;

  @computed
  bool get canResend => secondsLeft == 0;

  @computed
  String get formattedTime {
    final minutes = secondsLeft ~/ 60;
    final seconds = secondsLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @action
  void start(int totalSeconds) {
    _timer?.cancel();
    secondsLeft = totalSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft <= 1) {
        secondsLeft = 0;
        timer.cancel();
      } else {
        secondsLeft--;
      }
    });
  }

  @action
  void reset() {
    _timer?.cancel();
    secondsLeft = 0;
  }

  void dispose() {
    _timer?.cancel();
  }
}
