# riverpod_testing

## Provider type

- How to get value of a provider:

```dart
final model = ref.watch(aProvider);
```

- How to update state of a provider:

```dart
///In case of `StateNotifyProvider`
ref.read(aProvider.notifier).increase(by: 1);

///In case of `StateProvider`
ref.read(counterGetSetProvider.notifier).state++;
```

- How to refresh a part of screen instead of whole screen

```dart
Consumer(
	builder: (context, ref, child) {
		final counter = ref.watch(countGetterProvider);
		return Column(
			children: [
				Text('$counter'),
				child
			]
		);
	},
	child: ...
)
```

### [Provider](https://riverpod.dev/docs/providers/provider)

- It just a **getter** state (cant change its state)

### [FutureProvider](https://riverpod.dev/docs/providers/future_provider)

- The same as `Provider` (just a **getter**) but its for async state
- It have 3 state loading, got state and error

```dart
final activityProvider = FutureProvider.autoDispose((ref) async {
	// Using package:http, we fetch a random activity from the Bored API.
	final response = await http.get(Uri.https('boredapi.com', '/api/activity'));
	// Using dart:convert, we then decode the JSON payload into a Map data structure.
	final json = jsonDecode(response.body) as Map<String, dynamic>;
	// Finally, we convert the Map into an Activity instance.
	return Activity.fromJson(json);
});


Consumer(
	builder: (context, ref, child) {
		final activity = ref.watch(activityProvider);

		return Center(
			child: switch (activity) {
			AsyncData(:final value) => Text('Activity: ${value.activity}'),
			AsyncError() => const Text('Oops, something unexpected happened'),
			_ => const CircularProgressIndicator(),
			},
		);
	}
)
```

### [StateProvider](https://riverpod.dev/docs/providers/state_provider)

- It a setter / getter of a simple state (`int`, `bool`, `string`, `enum`...)
- A simpler version of `StateNotifierProvider`

### [StateNotifierProvider](https://riverpod.dev/docs/providers/state_notifier_provider)

- A `StateProvider` but its state can a an object
- `StateNotifierProvider` have two generic `<TheNotifier, TheModelThatWillBeNotified>`
- `TheNotifier` is subclass of `StateNotifier<TheModelThatWillBeNotified>`, which contain all of logic code to update state

> if you want a `FutureProvider` but it can change its state, use `StateNotifierProvider` with `StateNotifier<AsyncValue<T>>`

```dart
final boardGamesListControllerProvider = StateNotifierProvider<BoardGameList, AsyncValue<List<BoardGame>>>((ref) {
  	return BoardGameList(const AsyncValue.data([]), ref);
});


class BoardGameList extends StateNotifier<AsyncValue<List<BoardGame>>> {
  BoardGameList(AsyncValue<List<BoardGame>> items, this.ref) : super(items){
    init();
  }

  final Ref ref;

  Future<void> init() async {
    state = const AsyncValue.loading();
    try {
      final search = await ref.watch(boardGamesListProvider('').future);
      state = AsyncValue.data(search);
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }

  Future<void> search(String request) async {
    state = const AsyncValue.loading();
    try {
      final search = await ref.watch(boardGamesListProvider(request).future);
      state = AsyncValue.data(search);
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }
}
```
