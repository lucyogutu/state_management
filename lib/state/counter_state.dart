import 'package:freezed_annotation/freezed_annotation.dart';

part 'counter_state.freezed.dart';

part 'counter_state.g.dart';

@freezed
class CounterState with _$CounterState {
  const factory CounterState({required int? count}) = _CounterState;

  factory CounterState.fromJson(Map<String, Object?> json) => _$CounterStateFromJson(json);

  factory CounterState.initial() => const CounterState(count: 0);

}