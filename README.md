# clackety

A lightweight [Flutter package](https://pub.dev/packages/clackety) (zero external dependencies) to animate the typing of text (like a typewriter / typist). You can provide new typing targets via the controller and clackety will amend the text already written.

![Clackety demo animation](https://raw.githubusercontent.com/jimmyff/clackety/master/example/example.gif "clackety demo")

---

## Features

- Corrects text in realtime when new typing target is provided
- Easy to use with or without Controller
- Zero dependencies, lightweight & optimised
- Tap to fast-forward
- onCompelte callback support

---

## Getting started

Install the package:

```shell
flutter pub add flutter_local_notifications
```

---

## Usage: Basic

As a replacement Text() widget

```dart
Clackety.text("Clackety Example")
```

## Usage: Advanced

With a Clackety Controller.

```dart
// Create a the ClacketyController
_clacketyController = ClacketyController(value: '');

// Add the Clackety widget to your ui widget tree
Clackety(
    controller: _clacketyController,
    builder: (context, text) => Text(text)),

// Type new text whenever required!
_clacketyController.type('... Happy clacking!');
```

---

Happy clacking!
