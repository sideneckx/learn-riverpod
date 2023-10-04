# riverpod_testing

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Provider type

- How to get value of a provider:

```dart
final model = ref.watch(aProvider);
```

- How to update state of a provider:

```dart
ref.read(aNotifier).doSomething();
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

- It just a getter state (cant change its state)

### [FutureProvider](https://riverpod.dev/docs/providers/future_provider)

- The same as `Provider` but its for async state
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

- It a setter / getter of a simple state (int, bool, string, enum...)
- A simpler version of `StateNotifierProvider`

### [StateNotifierProvider](https://riverpod.dev/docs/providers/state_notifier_provider)

- A `StateProvider` but its state can a an object
- `StateNotifierProvider` have two generic `<TheNotifier, TheModelThatWillBeNotified>`
- `TheNotifier` is subclass of `StateNotifier<TheModelThatWillBeNotified>`, which contain all of logic code to update state
