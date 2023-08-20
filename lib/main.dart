import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:state_management/actions/increment_action.dart';
import 'package:state_management/actions/reset_action.dart';
import 'package:state_management/persistor/persistor.dart';

import 'package:state_management/state/counter_state.dart';

late Store<CounterState> store;

void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  var persistor = MyPersistor();

  var initialState = await persistor.readState();

  if (initialState == null) {
      initialState = CounterState.initial();
      await persistor.saveInitialState(initialState);
    }


  store = Store<CounterState>(
    initialState: initialState,
    persistor: PersistorPrinterDecorator(persistor),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<CounterState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePageConnector(),
      ),
    );
  }
}


/// This widget is a connector.
/// It connects the store to [MyHomePage] (the dumb-widget).
/// Each time the state changes, it creates a view-model, and compares it
/// with the view-model created with the previous state.
/// Only if the view-model changed, the connector rebuilds.
class MyHomePageConnector extends StatelessWidget {
  const MyHomePageConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<CounterState, ViewModel>(
      vm: () => Factory(this),
      builder: (BuildContext context, ViewModel vm) => MyHomePage(
        counter: vm.counter,
        onIncrement: vm.onIncrement,
        onReset: vm.onReset,
      ),
    );
  }
}

/// Factory that creates a view-model for the StoreConnector.
class Factory extends VmFactory<CounterState, MyHomePageConnector, ViewModel>{
  Factory(connector) : super(connector);

  @override
  ViewModel fromStore() => ViewModel(
    counter: state.count!,
    onIncrement: () => dispatch(IncrementAction(amount: 1),),
    onReset: () => dispatch(ResetAction(),),
  );
}


/// A view-model is a helper object to a [StoreConnector] widget. It holds the
/// part of the Store state the corresponding dumb-widget needs, and may also
/// convert this state part into a more convenient format for the dumb-widget
/// to work with.
///
/// You must implement equals/hashcode for the view-model class to work.
/// Otherwise, the [StoreConnector] will think the view-model changed everytime,
/// and thus will rebuild everytime. This won't create any visible problems
/// to your app, but is inefficient and may be slow.
///
/// By extending the [Vm] class you can implement equals/hashcode without
/// having to override these methods. Instead, simply list all fields
/// (which are not immutable, like functions) to the [equals] parameter
/// in the constructor.
///
class ViewModel extends Vm {
  final int counter;
  final VoidCallback onIncrement;
  final VoidCallback onReset;

  ViewModel({
    required this.counter,
    required this.onIncrement,
    required this.onReset,

  }) : super(equals: [counter]);
}



/// This is the "dumb-widget". It has no notion of the store, the state, the
/// connector or the view-model. It just gets the parameters it needs to display
/// itself, and callbacks it should call when reacting to the user interface.
class MyHomePage extends StatelessWidget {
  final int? counter;
  final VoidCallback? onIncrement;
  final VoidCallback? onReset;

  const MyHomePage({
    Key? key,
    this.counter,
    this.onIncrement,
    this.onReset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Increment Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text('$counter', style: const TextStyle(fontSize: 30))
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: onIncrement,
              child: const Icon(Icons.add),
            ),
      
            const SizedBox(width: 30,),
      
            FloatingActionButton(
              onPressed: onReset,
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}