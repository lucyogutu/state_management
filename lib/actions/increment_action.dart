import 'package:async_redux/async_redux.dart';
import 'package:state_management/state/counter_state.dart';

class IncrementAction extends ReduxAction<CounterState> {
  final int amount;

  IncrementAction({required this.amount});

  @override
  CounterState? reduce() => state.copyWith(count: state.count! + amount);
}