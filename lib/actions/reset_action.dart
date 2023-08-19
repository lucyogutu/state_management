
import 'package:async_redux/async_redux.dart';
import 'package:state_management/state/counter_state.dart';

class ResetAction extends ReduxAction<CounterState> {
  @override
  CounterState? reduce() => state.copyWith(count: 0);
}